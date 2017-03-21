function [Tracks,X] = DetectionLink(Detections)
% Prediction: prediction composed of xp1 (prediction for Centroid) and xp2 (prediction for Intensity)
% Detections: detection result from 'MitoDetection'
% Update: updated result with Kalman filter

fprintf('Linking the mito detections into trajectories...\n');

tracks=(1:size(Detections{1},1))';
nframe=size(Detections,2);
X=cell(1,nframe);
Xp=cell(1,nframe);

%% Initialization for Kalman Filter
A1=[1,0,0,1,0,0;
    0,1,0,0,1,0;
    0,0,1,0,0,1;
    0,0,0,1,0,0;
    0,0,0,0,1,0;
    0,0,0,0,0,1];
H1=[1,0,0,0,0,0;
    0,1,0,0,0,0;
    0,0,1,0,0,0];
Q1=0.01*eye(6);
P1=100*eye(6);
R1=[3.8144,0.2586,0;0.2586,0.1051,0;0,0,0]; % empirically set

A2=[1,1;0,1];
H2=[1,0];
Q2=0.01*eye(2);
P2=100*eye(2);
R2=80; % empirically set

A3=[1,1;0,1];
H3=[1,0];
Q3=0.01*eye(2);
P3=100*eye(2);
R3=130; % empirically set

for dn=1:size(Detections{1},1)
    X{1}(dn).X1=[Detections{1}(dn).Centroid,0,0,0];
    X{1}(dn).X2=[Detections{1}(dn).Intensity,0];
    X{1}(dn).X3=[Detections{1}(dn).Area,0];
    X{1}(dn).frame=1;
    X{1}(dn).No=dn;
end
X{1}=X{1}';

%% Update the position and intensity using Detections and Predictions
for frame=2:nframe
    
    % update Kalman filter
    PP1=A1*P1*A1'+Q1;
    K1=PP1*H1'/(H1*PP1*H1'+R1);
    P1=(eye(6)-K1*H1)*PP1;
    
    PP2=A2*P2*A2'+Q2;
    K2=PP2*H2'/(H2*PP2*H2'+R2);
    P2=(eye(2)-K2*H2)*PP2;
    
    PP3=A3*P3*A3'+Q3;
    K3=PP3*H3'/(H3*PP3*H3'+R3);
    P3=(eye(2)-K3*H3)*PP3;
    
    % prediction of Update in last frame
    Predictions=struct('Centroid',[],'Intensity',[]);
    for n=1:size(X{frame-1},1)
        Xp{frame}(n).X1=(A1*double(X{frame-1}(n).X1)')';
        Xp{frame}(n).X2=(A2*double(X{frame-1}(n).X2)')';
        Xp{frame}(n).X3=(A3*double(X{frame-1}(n).X3)')';
        Xp{frame}(n).frame=X{frame-1}(n).frame;
        Xp{frame}(n).No=X{frame-1}(n).No;
        Predictions(n).Centroid=Xp{frame}(n).X1(1:3);
        Predictions(n).Intensity=Xp{frame}(n).X2(1);
        Predictions(n).Area=Xp{frame}(n).X3(1);
    end
    Xp{frame}=Xp{frame}';
    Predictions=Predictions';
    
    % calculate the cost and match
    FC=FrameCost(Detections{frame},Predictions);
    CM=CostMatch(FC,10);
    
    matchmem=zeros(size(Predictions,1),1); % the position of matched Predictions is set to 'true' to avoid another match
    
    % update the position and intensity of particles
    for dn=1:size(Detections{frame},1)
        if ~isempty(CM(dn,:))
            p=find(CM(dn,:),1,'first');
            if matchmem(p)==0
                matchmem(p)=1;
                X{frame}(dn).X1=(Xp{frame}(p).X1'+K1*double((Detections{frame}(dn).Centroid)'-H1*Xp{frame}(p).X1'))';
                X{frame}(dn).X2=(Xp{frame}(p).X2'+K2*double((Detections{frame}(dn).Intensity)'-H2*Xp{frame}(p).X2'))';
                X{frame}(dn).X3=(Xp{frame}(p).X3'+K3*double((Detections{frame}(dn).Area)'-H3*Xp{frame}(p).X3'))';
                ind=tracks(:,Xp{frame}(p).frame)==Xp{frame}(p).No;
                tracks(ind,frame)=dn;
            else
                X{frame}(dn).X1=[Detections{frame}(dn).Centroid,0,0,0];
                X{frame}(dn).X2=[Detections{frame}(dn).Intensity,0];
                X{frame}(dn).X3=[Detections{frame}(dn).Area,0];
                tracks(size(tracks,1)+1,frame)=dn;
            end
        else
            X{frame}(dn).X1=[Detections{frame}(dn).Centroid,0,0,0];
            X{frame}(dn).X2=[Detections{frame}(dn).Intensity,0];
            X{frame}(dn).X3=[Detections{frame}(dn).Area,0];
            tracks(size(tracks,1)+1,frame)=dn;
        end
        X{frame}(dn).frame=frame;
        X{frame}(dn).No=dn;
    end
    
    unmatchedp=find(~matchmem);
    for i=1:size(unmatchedp,1)
        if (frame-Xp{frame}(unmatchedp(i)).frame)<2
            X{frame}=[X{frame},Xp{frame}(unmatchedp(i))];
        end
    end
    
    X{frame}=X{frame}';
end

Tracks.id=tracks;
Tracks.x=zeros(size(tracks));
Tracks.y=zeros(size(tracks));
Tracks=UpdateTracksCoodinates(Tracks,Detections);

fprintf('Done.\n')