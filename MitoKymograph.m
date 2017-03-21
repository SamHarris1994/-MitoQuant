function MitoKymograph(Img)
%MitoKymograph(Img) plots the kymograph of mitochondrial movement.
%
%   INPUTS
%   Img           : a structure which contains mitochondrial moving images.
%                   Typically, the matrix was exported by tif2mat() function.

figure;
Ip(:,:,:)=max(Img.data,[],3);
scale = 2/Img.xResolution;
I=uint8(Ip(1:2:end,1:2:end,1:1:end)*255/max(Ip(:)));
vol3d('cdata',I,'texture','3D');
colormap(gray(256));
view(3); 
Axis = [0 size(I,2) 0 size(I,1) 0 size(I,3)];
axis(Axis);
alphamap('rampup');
alphamap(.06 .* alphamap);
set(gca,'Color','black','Projection','perspective','ZDir','reverse',...
'YDir','reverse','Box','on','DataAspectRatio',[1.2 1 1.8],'View',[14 25])
set(gca,'XTickLabel',str2num(get(gca,'XTickLabel'))*scale)
set(gca,'YTickLabel',str2num(get(gca,'YTickLabel'))*scale)
set(gca,'ZTickLabel',str2num(get(gca,'ZTickLabel'))*Img.f)