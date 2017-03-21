function [Detections] = MitoDetect(Img,st)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%MitoDetect function detects the particles with watershed algorithm and
%gradient magnitude to segment the picture.
%   INPUTS
%   Img         : original image, containing the 4-D matrix of moving mitochondria
%                 image sequences. This structure should be exported by function tif2mat.
%   st          : a threshould vector for mitochondrial segmentation. For best
%                 segmentation results, users may use SegmentThresh
%                 function to tune the threshold.
%   OUTPUTS
%   Detection   : a cell of the detecting results containing the particle
%                 position and intensity.

fprintf('Mito Detecting may take several minutes to process.\n')
fprintf('Processing...\n')
fprintf('+------------------------------------------------+\n') % 50 

for i=1:size(Img.data,4)
    Detections{i}=ParticleSegment(Img.data(:,:,:,i),st(i));
    if mod(i,(size(Img.data,4)/50))==0
         fprintf('+')
    end
end
fprintf('\ndone.\n')