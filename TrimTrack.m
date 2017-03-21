function [Tracks]=TrimTrack(Tracks,Detection)

Threshold=10; % threshold set for Trajectory trimming

tracks=Tracks.id;
numtrack=size(tracks,1);
cnt=1;
for i=1:numtrack
    n=size(find(tracks(i,:)),2);
    if n>=Threshold
        T(cnt,:)=tracks(i,:);
        cnt=cnt+1;
    end
end
Tracks.id=T;
Tracks=UpdateTracksCoodinates(Tracks,Detection);