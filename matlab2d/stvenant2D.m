
clear; close all;

% Discretisation

N = 80;
N2 = N*N; % nombre de mailles "physiques"
a = 0; % bord gauche du domaine
b = 10; % bord droit du domaine
c = b; % profondeur

%tn = zeros(0,1); % stocke les valeurs de tn (pas variable)
t = 0;
alpha = 0.9;

% Initialisation de u_n[i]
%hn = [0.5*ones(1,N2/2) 2*ones(1,N2/2)];
%hn(10*N+10)=10;

hn = ones(1,N2);

% hn(N/4) = 50;
% hn(N*3/4) = 50;
hn(1:N) = 4;

hun = zeros(1,N2);
hvn = zeros(1,N2);

u = [hn;hun;hvn];


figure

step = 0.05;

for n = 1 : 1000
    
    n
    
u = finiteVolume2d(u, a, b, c, step, alpha, N);
pause(0.1)
clf;

x = linspace(a,b,N);
y = linspace(a,b,N);
[X,Y] = meshgrid(x,y);

Z = [];
for i = 1:N
    Z = [Z; u(1,(i-1)*N+1:i*N)];
end
h = surf(X,Y,Z);
zlim([0 2]);
view(135+n*0.5,30)
shading interp

hold on
end;









