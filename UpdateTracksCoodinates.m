function [Tracks]=UpdateTracksCoodinates(Tracks,Detection)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%UpdateTracksCoodinates
%   INPUTS
%   result  : 
%
%   OUTPUTS
%   Tracks  : 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Created By Yang Li ; Date 2016.01.22
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

nframe=size(Tracks.id,2);

trackX=zeros(size(Tracks.id));
trackY=zeros(size(Tracks.id));
trackI=zeros(size(Tracks.id));
trackA=zeros(size(Tracks.id));
tracks=Tracks.id;
for i=1:nframe
    ind=find(tracks(:,i));
    if numel(ind)>0
    for j=1:size(ind,1)
        p=Detection{i}(tracks(ind(j),i)).Centroid;
        trackX(ind(j),i)=p(1);
        trackY(ind(j),i)=p(2);
        trackI(ind(j),i)=Detection{i}(tracks(ind(j),i)).Intensity;
        trackA(ind(j),i)=Detection{i}(tracks(ind(j),i)).Area;
    end
    end
end

Tracks.id=tracks;
Tracks.x=trackX;
Tracks.y=trackY;
Tracks.intensity=trackI;
Tracks.area=trackA;