function [Detec]=ParticleSegment(PE,st)

D=bwdist(PE>(mean(PE(:))*st));
bgm=~(imdilate(~D,ones(3,3,3)));
fmarker=imregionalmax(PE).*(PE>mean(PE(:))*st);

hx(1,:,:)=[1 1 1;1 2 1;1 1 1];
hx(2,:,:)=[0 0 0;0 0 0;0 0 0];
hx(3,:,:)=-[1 1 1;1 2 1;1 1 1];

hy(:,1,:)=[1 1 1;1 2 1;1 1 1];
hy(:,2,:)=[0 0 0;0 0 0;0 0 0];
hy(:,3,:)=-[1 1 1;1 2 1;1 1 1];

hz(:,:,1)=[1 1 1;1 2 1;1 1 1];
hz(:,:,2)=[0 0 0;0 0 0;0 0 0];
hz(:,:,3)=-[1 1 1;1 2 1;1 1 1];

Iy=convn(PE,hy,'same');
Ix=convn(PE,hx,'same');
Iz=convn(PE,hz,'same');
gradmag=(Ix.^2+Iy.^2+Iz.^2).^.5;

gradmag2=imimposemin(gradmag,bgm|fmarker);
detection=watershed(gradmag2);
detection=uint16(detection);

Seg1=regionprops(detection,'Area','Centroid');
Seg2=regionprops(detection,PE,'MeanIntensity');

n=1;
for i=1:size(Seg1,1)
    if Seg1(i).Area<500
        if numel(Seg1(i).Centroid)==2
            Detec(n).Centroid=[Seg1(i).Centroid,1];
        else
            Detec(n).Centroid=Seg1(i).Centroid;
        end
        Detec(n).Intensity=Seg2(i).MeanIntensity;
        Detec(n).Area=Seg1(i).Area;
        n=n+1;
    end
end
Detec=Detec';
