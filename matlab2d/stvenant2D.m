
clear; close all;

% Discretisation

N = 100;
N2 = N*N; % nombre de mailles "physiques"
a = 0; % bord gauche du domaine
b = 1; % bord droit du domaine
c = b; % profondeur

%tn = zeros(0,1); % stocke les valeurs de tn (pas variable)
t = 0;
alpha = 0.9;

% Initialisation de u_n[i]
hn = ones(1,N2)
hun = zeros(1,N2);
hvn = zeros(1,N2);

u = [hn;hun;hvn];
figure;
hold on;


step = 1;

for n = 1 : 1000
u = finiteVolume2d(u, a, b, c, step, alpha);
pause(0.2)
clf;
hold on;
plot(zeros(1,100));
plot(2*ones(1,100));
plot(u(1,:));


end;









