clear, close all;

% Simulation Sillage Fluvial

global SV_TITLE
global SV_DROP_AT
global SV_FN_PERFORM
global SV_PILIER
SV_FN_PERFORM = false;
SV_TITLE = "Sillage sur un écoulement à Fr = 0.32";


length = 5;
width = 5;
res = 40;
du = 3.13;
dv = 0;
tmax = 1.5;

SV_DROP_AT = tmax + 1;
setUpFiniteVolume(length, width, res, du, dv, tmax);