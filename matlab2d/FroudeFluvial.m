
clear, close all;

% Simulation Froude Fluvial

global SV_TITLE
global SV_DROP_AT
global SV_FN_PERFORM
SV_FN_PERFORM = false;
SV_TITLE = "Effet d'une goutte sur un �coulement � Fr = 0.32";
SV_DROP_AT = 0.2;

length = 5;
width = 5;
res = 40;
du = 1;
dv = 0;
tmax = 1.5;
setUpFiniteVolume(length, width, res, du, dv, tmax);