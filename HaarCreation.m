function [h1,h2]=HaarCreation(psize)
% This function is to create haar-like filters.

hsize1=psize*2+1;
hsize2=psize*4-1;
delta=(psize+1)/2;
h1=-ones(hsize1,hsize1,hsize1);
h2=-ones(hsize1,hsize2,hsize1);
h1((1+delta):(hsize1-delta),(1+delta):(hsize1-delta),(1+delta):(hsize1-delta))=1;
h2((1+delta):(hsize1-delta),(1+delta):(hsize2-delta),(1+delta):(hsize1-delta))=1;