
clear, close all;

% Simulation Froude Fluvial

global SV_TITLE
global SV_DROP_AT
SV_TITLE = "Effet d'une exitation sur un bord";


global SV_FN_U0T
SV_FN_U0T = @(t) 3* sin(10*t);

length = 20;
width = 1;
res = 10;
du = 0;
dv = 0;
tmax = 100;

SV_DROP_AT = tmax +1;
setUpFiniteVolume(length, width, res, du, dv, tmax);