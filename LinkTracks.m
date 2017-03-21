function [Tracks,X]=LinkTracks(Tracks,Detections,X)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%LinkTracks
%   INPUTS
%   result 
%
%   OUTPUTS
%   Tracks  : 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Created By Sheng Lu ; Date 2016.05.20
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

track=Tracks.id;
TrackX=Tracks.x;
TrackY=Tracks.y;
TrackI=Tracks.intensity;
TrackA=Tracks.area;
numtrack=size(track,1);
for i=1:numtrack
    indtrack=find(track(i,:));
    if numel(indtrack)>0
        numpoint=size(indtrack,2);
        indtrackm=find(track(:,indtrack(numpoint))==0);
        numtrackm=size(indtrackm,1);
        
        indm=cell(1,numtrackm);
        diff=zeros(1,numtrackm);
        diff(:)=inf;
        
        X1=X{indtrack(numpoint)}(track(i,indtrack(numpoint))).X1;
        X2=X{indtrack(numpoint)}(track(i,indtrack(numpoint))).X2;
        X3=X{indtrack(numpoint)}(track(i,indtrack(numpoint))).X3;
        
        for j=1:numtrackm
            indm{j}=find(track(indtrackm(j),:));
            if numel(indm{j})>0 && indm{j}(1)>indtrack(numpoint)
                distframe=abs(indm{j}(1)-indtrack(numpoint));
                if distframe<=5
                    distx=TrackX(indtrackm(j),indm{j}(1))-X1(1); % TrackX(i,indtrack(numpoint));
                    disty=TrackY(indtrackm(j),indm{j}(1))-X1(2); % TrackY(i,indtrack(numpoint));
                    distintensity=TrackI(indtrackm(j),indm{j}(1))-X2(1); % TrackI(i,indtrack(numpoint));
                    distarea=TrackA(indtrackm(j),indm{j}(1))-X3(1); % TrackA(i,indtrack(numpoint));
                    diffintensity=abs(distintensity-(X2(2)*distframe));
                    diffarea=abs(distarea-(X3(2)*distframe));
                    if diffintensity<15 && diffarea<100
                        diffx=abs(distx-(X1(4)*distframe));
                        diffy=abs(disty-(X1(5)*distframe));
                        diffxy=(diffx.^2+diffy.^2).^.5;
                        diff(j)=0.4*distframe+0.6*diffxy;
                    end
                end
            end
        end
        matchedtrack=find(diff==min(diff));
        if min(diff)<12
            p1=indtrackm(matchedtrack(1));
            p2=indm{matchedtrack(1)}(1);
            q=indtrack(numpoint);
            if p2<size(track,2) && track(p1,p2+1)==0
                distframe=p2-q;
                X{p2}(track(p1,p2)).X1(4)=(TrackX(p1,p2)-TrackX(i,q))/distframe;
                X{p2}(track(p1,p2)).X1(5)=(TrackY(p1,p2)-TrackY(i,q))/distframe;
                X{p2}(track(p1,p2)).X2(2)=(TrackI(p1,p2)-TrackI(i,q))/distframe;
                X{p2}(track(p1,p2)).X3(2)=(TrackA(p1,p2)-TrackA(i,q))/distframe;
            end
            track(i,:)=track(i,:)+track(p1,:);
            track(p1,:)=0;
        end
    end
end
Tracks.id=track;
[Tracks]=UpdateTracksCoodinates(Tracks,Detections);