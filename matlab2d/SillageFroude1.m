clear, close all;

% Simulation Sillage Fluvial

global SV_TITLE
global SV_DROP_AT
global SV_FN_PERFORM
global SV_PILIER
SV_FN_PERFORM = false;
SV_TITLE = "Sillage sur un écoulement à Fr = 1";


length = 10;
width = 10;
res = 80;
du = 3.13;
dv = 0;
tmax = 10;

SV_DROP_AT = tmax + 1;
setUpFiniteVolumePilier(length, width, res, du, dv, tmax);