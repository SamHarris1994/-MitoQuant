function [V]=TransSpeedAnalysis(Img,Tracks,w)
%TRANSPEEDANALYSIS  compute the sustained component and the transient
%                   component of the velocity within a short time window.
%  INPUTS
%  Img      : original image, containing the 4-D matrix of moving mitochondria
%             image sequences. This structure should be exported by function tif2mat.
%  Tracks   : The mitochodrial movement trajectories. 
%  w        : window size (in points) for transient speed analysis;
%
%  OUTPUTS
%  V        : a structure containning trainsient speed and sustained speed;
fprintf('Performing transient speed analysis ...\n');

tracks=Tracks.id;
tracksX=Tracks.x;
tracksY=Tracks.y;

numTracks=size(tracks,1);
numFrames=size(tracks,2);

Vs=zeros(numTracks,numFrames-w);
Vs(:)=NaN;

Vt=zeros(numTracks,numFrames-w);
Vt(:)=NaN;

ind=find(tracksX==0);
tracksX(ind)=NaN;
tracksY(ind)=NaN;
stx=1.5;
sty=1.5;
halfw=w/2;
for i=halfw+1:numFrames-halfw
%     WRx=tracksX(:,i:i+w-1);
%     WRy=tracksY(:,i:i+w-1);
    for j=1:numTracks
        WRx=tracksX(j,i-halfw:i+halfw);
        WRy=tracksY(j,i-halfw:i+halfw);
        ind=~isnan(WRx);
        WRx=WRx(ind);
        WRy=WRy(ind);
        n=numel(WRx);
        % do only when more than half of points were defined in the
        % window
        if n>halfw
            Px=polyfit(1:n,WRx,1);
            Py=polyfit(1:n,WRy,1);
            Vs(j,i)=Px(1);
            x=1:n;
            Dx=WRx-(Px(1)*x+Px(2));
            Dy=WRy-(Py(1)*x+Py(2));
            Dx=(Dx>=stx).*Dx;
            Dy=(Dy>=sty).*Dy;
            Vt(j,i)=sum(Dx+Dy)/n;
        else
            Vt(j,i)=NaN;
            Vs(j,i)=NaN;
        end
    end
end
u=1/Img.xResolution;
f=Img.f;
V.transient = Vt*u/f;
V.sustained = Vs*u/f;
V.w = w;
V.f = Img.f;
V.sizeX = size(Img.data,1)/Img.xResolution;
V.sizeY = size(Img.data,2)/Img.yResolution;
V.timespan = Img.f * size(Img.data,4);

fprintf('Done.\n')