
clear, close all;

% Simulation Froude Fluvial

global SV_TITLE
global SV_DROP_AT
global SV_FN_PERFORM
SV_FN_PERFORM = false;
SV_TITLE = "Surface plate reste plate";
SV_DROP_AT = 10;

length = 5;
width = 5;
res = 40;
du = 0;
dv = 0;
tmax = 1.5;
setUpFiniteVolume(length, width, res, du, dv, tmax);