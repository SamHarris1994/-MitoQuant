clear all; clc

%% Importing and Pre-processing
imagename = 'Div7MitoMove37C-Series023';
filename = strcat(imagename, '.tif');
% frameinterval = 1.5s
Io = tif2mat(filename, 1.5);
Io_test = Io;
Io_test.data = Io.data(401:500,401:600,:,:);
% mitosize = 5 pixels;
I_test = ParticleEnhancement(Io_test, 5);
% Kymograph
MitoKymograph(I_test);

%% Detect-and-link method based on Kalman filter
load st
% detect and link
D = MitoDetect(I_test, st);
[L, X] = DetectionLink(D);
T = TrackRectify(L, D, X);
% window = 16 points
V = TransSpeedAnalysis(I_test, T, 16);
SpeedMap(V, 16);
% Show AR and RR only
MitoTrajectories(D, T, V, [0 0 1 1]);
