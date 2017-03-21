function [ImgFlt]=ParticleEnhancement(Img,mitoSize)
%ParticleEnhancement(I,mitoSize)  uses several Haar-like feature based filters
%to enhance the SNR of the 4-D image.
%   INPUTS
%   Img         : original image, containing the 4-D matrix of moving mitochondria
%                 image sequences. This structure should be exported by function tif2mat.
%   mitoSize    : set the range of and average diameter of mitochondria so
%                  that a particle enhancement filter can be properly set. Users may
%                  measure this diameter in z-stack image by using ImageJ and input the
%                  value in pixels. The value may be adjusted depending on neuronal types
%                  and culture conditions, between 5 pixels and 13 pixels. In a typical
%                  experiment in our study, the average diameter was set at 7 pixels.
%
%   OUTPUTS
%   ImgFlt        : the enhanced particle image structure.

ImgFlt=Img;
I=Img.data;
Iout=zeros(size(I));
fprintf('Particle enhancement filtering may take several minutes to process.\n')
fprintf('Processing...\n')
fprintf('+------------------------------------------------+\n') % 50 
[h11,h12]=HaarCreation(mitoSize-2);
[h21,h22]=HaarCreation(mitoSize);

for i=1:size(I,4)

H1(:,:,:,1)=HaarFeature(I(:,:,:,i),h11);
H1(:,:,:,2)=HaarFeature(I(:,:,:,i),h21);

H2(:,:,:,1)=HaarFeature(I(:,:,:,i),h12);
H2(:,:,:,2)=HaarFeature(I(:,:,:,i),h22);

H1m=max(H1,[],4);
H2m=max(H2,[],4);

PP=H1m*.4+H2m*.6;
lambda=max(max(max(PP)))*0.04;
PP=PP.*(PP>lambda);

SmallArea=ones(5,5);
P=ones(size(PP));
for k=1:size(PP,3)
    L=bwlabeln(PP(:,:,k),4);
    L(L>0)=1;
    P(:,:,k)=convn(L,SmallArea,'same')>(0.5*sum(sum(SmallArea)));
end
PP=PP.*P;

load h
Iout(:,:,:,i)=convn(PP,h,'same');
    if mod(i,(size(I,4)/50))==0
         fprintf('+')
    end
end
fprintf('\ndone.\n')
ImgFlt.data=uint16(Iout);