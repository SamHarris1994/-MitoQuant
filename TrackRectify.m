function [TrackLd] = TrackRectify(Tracks,Detections,X)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%TrackRectify function link short trajectories into longer ones and trim
%the trajectory fragments.
%   INPUTS
%   Tracks      : original image, containing the 4-D matrix of moving mitochondria
%                 image sequences. This structure should be exported by function tif2mat.
%   Detections  : a cell of the detecting results containing the particle
%                 position and intensity.
%   OUPUTS
%   TrackLd     : Rectified trajectories.

fprintf ('Processing trajectories rectification...\n')
    TrackLd=Tracks;
    for k=1:10
        [TrackLd,X]=LinkTracks(TrackLd,Detections,X);
    end
    fprintf('Linking tracks done.\n')
    TrackLd=TrimTrack(TrackLd,Detections);
    
fprintf ('Done.\n')