function SpeedMap(V,w)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%SpeedMap function draws the scatter plot of sustained speed and transient
%speed.
%   INPUTS
%   V        : a structure containning trainsient speed and sustained speed;

figure,plot(V.transient(1:(w/2):end),V.sustained(1:(w/2):end),'.');
end