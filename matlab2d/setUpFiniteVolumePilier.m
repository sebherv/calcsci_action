function [ output_args ] = setUpFiniteVolume( length, width, resolution, du, dv, tmax )
%SETUPFINITEVOLUME 
% Configure et démarre la simulation , affiche des données à l'écran
% - lenght: longueur du domaine (m)
% - width: largeur du domaine (m)
% - resolution: mailles sur la largeur
% - du: débit dans la direction u
% - dv: débit dans la direction v
% - tmax: durée maximale de la simulation


% Vérifier la configuration des bords:
global SV_REFLECT_TOP;
global SV_REFLECT_BOTTOM;
global SV_REFLECT_LEFT;
global SV_REFLECT_RIGHT;

global SV_DEBIT_U;
global SV_DEBIT_V;

global SV_TITLE;
global SV_DROP_AT

if ~exist('SV_REFLECT_TOP','var')
    SV_REFLECT_TOP=true;
end

if ~exist('SV_REFLECT_BOTTOM','var')
    SV_REFLECT_BOTTOM=true;
end

if ~exist('SV_REFLECT_LEFT','var')
    SV_REFLECT_LEFT=true;
end

if ~exist('SV_REFLECT_RIGHT','var')
    SV_REFLECT_RIGHT=true;
end

SV_DEBIT_U = du
if du ~= 0.0
    SV_REFLECT_LEFT = false;
    SV_REFLECT_RIGHT = false;
end

SV_DEBIT_V = dv
if dv ~= 0.0
    SV_REFLECT_TOP = false;
    SV_REFLECT_BOTTOM = false;
end

% Monter le domaine
deltax = width / resolution;
Nu = length / deltax;
Nv = width / deltax;

N2 = Nu * Nv

alpha = 0.9;

% Configurer le fluide
hn = ones(1,N2);

hun = du * ones(1,N2);
hvn = dv * ones(1,N2);

u = [hn;hun;hvn];

t = 0;
dt = 0.01;

if exist('SV_DROP_AT', 'var')
    drop_at = SV_DROP_AT;
else
    drop_at = tmax+1;
end

while t < tmax
    
    if (t > drop_at -dt) & (t < drop_at + dt)
        u(1, (Nv + 1) * Nu/2 ) = 5;
    end
    u = finiteVolume2dPilier(u,dt,t,alpha, Nu, Nv, deltax);
    pause(0.1)
    t = t + dt
    clf;

    x = linspace(0,length,Nu);
    y = linspace(0,width,Nv);
    [X,Y] = meshgrid(x,y);
    
    Z = [];
    PU = [];
    PV = [];
    for i = 1:Nv
        Z = [Z; u(1,(i-1)*Nu+1:i*Nu)];
        PU = [PU; u(2,(i-1)*Nu+1:i*Nu)];
        PV = [PV; u(3,(i-1)*Nu+1:i*Nu)];
    end
    
    hold on
    h = surf(X,Y,Z);
    %quiver(X,Y,PU,PV);
    zlim([0 2.5]);
    daspect([1 1 1]);
    %view(135- 30 * t,30-20 * sin(t))
    view(135,30)
    shading interp
    
    title({SV_TITLE sprintf("t = %.2f s", t)});
    


    
end;
end

