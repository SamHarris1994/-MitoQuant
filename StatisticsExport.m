function [ StatResult ] = StatisticsExport( V, thresh)
%StatisticsExport function calculates and generate statistical results
%including the proportion of mitochondria in each movement state and the
%average running speed.
%   INPUTS
%   V           : transient speed;
%   thresh      : a threshold set to distinguish AR, DP and RR from eacn
%                 other. In our experiment, the threshold was set to
%                 0.05um/s.
%
%   OUTPUTS
%   StatResult  : a struct consisting the proportion of mitochondria in each movement state and the average running speed;
%                 TotalNum      : total number of mitochondria in the file;
%                 ProportionST  : proportion of mitochondria in movement state Stationary;
%                 ProportionDP  : proportion of mitochondria in movement state Dynamic Pause;
%                 ProportionAR  : proportion of mitochondria in movement state Anterograde Running;
%                 ProportionRR  : proportion of mitochondria in movement state Retrograde Running;
%                 AvgSpdAR      : average running speed of mitochondria in movement state Anterograde Running;
%                 AvgSpdRR      : average running speed of mitochondria in movement state Retrograde Running;

%% PreProcessing
w = V.w;
TranSpeedWithST=V.transient(1:(w/2):end);
SusSpeedWithST=V.sustained(1:(w/2):end);
StatResult.TotalNum=length(TranSpeedWithST);
%% Stationary
TranSpeed=TranSpeedWithST(find(TranSpeedWithST>(thresh/5)));
SusSpeed=SusSpeedWithST(find(TranSpeedWithST>(thresh/5)));
STNumber=StatResult.TotalNum-length(TranSpeed);
StatResult.ProportionST=STNumber/StatResult.TotalNum;
%% Dynamic Pause
DynamicPause=SusSpeed(find(abs(SusSpeed)<=thresh));
DPNumber=length(DynamicPause);
StatResult.ProportionDP=DPNumber/StatResult.TotalNum;
%% Anterograde Running
Anterograde=SusSpeed(find(SusSpeed>thresh));
ARNumber=length(Anterograde);
StatResult.ProportionAR=ARNumber/StatResult.TotalNum;
%% Retrograde Running
Retrograde=SusSpeed(find(SusSpeed<-thresh));
RRNumber=length(Retrograde);
StatResult.ProportionRR=RRNumber/StatResult.TotalNum;
%% Average Running Speed
StatResult.AvgSpdAR=mean(Anterograde);
StatResult.AvgSpdRR=mean(Retrograde);
end