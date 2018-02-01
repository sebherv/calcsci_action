
clear; close all;

% Discretisation

N = 100; % nombre de mailles internes
a = 0;   % bord gauche du domaine
b = N; % bord droit du domaine


%tn = zeros(0,1); % stocke les valeurs de tn (pas variable)
t = 0;
alpha = 0.9;

% Initialisation de u_n[i]: un step de niveau
%hn = [ones(1,50) zeros(1,50)];
hn = ones(1,1000);
hn(500)=10;
%hn(1)=2;
%hn = [ones(1,50) ones(1,50)];
hvn = zeros(1,1000);

u = [hn;hvn];


figure;
hold on;


step = 1;

for n = 1 : 1000
u = finiteVolume1d(u, a, b, step, alpha);
pause(0.2)
clf;
hold on;
plot(zeros(1,100));
plot(2*ones(1,100));
plot(u(1,:));


end;









