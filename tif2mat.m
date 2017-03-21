function [I]=tif2mat(filename,frameinterval)
%tif2mat(filename, frameinterval) converts tif image to 4-D matrix for MiTracker.
%   INPUTS
%   filename : file name of the tif image which contains mitochondrial
%              moving image data.
%   frameinterval: the frame interval (s) in second.
%
%   OUTPUTS
%   I        : a struct contains image data and info, including following
%              fields:
%              data -- the image data, a 4-D matrix.
%              info -- the file description 
%              xResolution -- the resolution in x direction. (pixel/um) 
%              yResolution -- the resolution in y direction. (pixel/um)
%              framesNum -- number of temporal frames. 
%              layersNum -- number of z-layer.


% read the image info
info=imfinfo(filename);
I.xResolution=info(1).XResolution;
I.yResolution=info(1).YResolution;
I.info=info(1);

decript=info(1).ImageDescription;
C=strsplit(decript);
s=strfind(C,'slices');
f=strfind(C,'frames');
fprintf('Reading the image...\n')
for i=1:size(C,2)
    if f{i}==1
        a=strsplit(C{i},'=');
        I.framesNum=str2num(a{2});   
    end
    if s{i}==1
        a=strsplit(C{i},'=');
        I.layersNum=str2num(a{2});
    end  
end

% read the image data
for frame=1:I.framesNum
   for i=1:I.layersNum
     T(:,:,i,frame)=imread(filename,(frame-1)*I.layersNum+i);
   end
end
I.data=uint16(T);
I.f=frameinterval;
fprintf('Done.\n')