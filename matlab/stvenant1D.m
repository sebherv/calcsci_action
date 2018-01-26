
clear; close all;

% Discretisation

N = 100; % nombre de mailles internes
a = 0;   % bord gauche du domaine
b = N; % bord droit du domaine

deltax = (b-a)/N;

n = 0;   % l'index initial
nmax = 1000; % valeur maximale de n
tmax = 100;

%tn = zeros(0,1); % stocke les valeurs de tn (pas variable)
t = 0;
alpha = 0.9;

% Initialisation de u_n[i]: un step de niveau
%hn = [ones(1,50) zeros(1,50)];
%hn = ones(1,100);
hn = [2*ones(1,50) ones(1,50)];
hvn = zeros(1,100);

u = [hn;hvn];

% Conditions initiales au bord
u0n = u(:,1);
uMn = u(:,end);



figure;
hold on;


while (n < nmax)
    % Calcul de Ln
    L = 0;
    B = zeros(2,100);
    
    % Boucle sur les interfaces Internes
    for i = 1 : N-1
        u1 = u(:,i);
        u2 = u(:,i+1);
        
        [gi, c] = g(u1,u2);

        B(:,i) = B(:,i) + gi;
        B(:,i+1) = B(:,i+1) - gi;
        
        % Update if necessary
        if c > L
            L = c;
        end;
    end;
    
    % Boucle sur les interfaces Externes
    % A gauche
    u1 = u(:,1);
    B(:,1) = B(:,1) - g(u0n, u1);
    
    un = u(:,end);
    B(:,end) = B(:,end) + g(un, uMn);

    % Calcul de delta t
    dt = alpha * deltax / (2*L);
    dt = min([dt tmax - t]);

    % Boucle sur les mailles
    for i = 1:N
        u(:,i) = u(:,i) - dt*B(:,i)/deltax;
        u0n = u(:,1);
        uMn = u(:,end);
    end;

    t = t + dt;
    n = n+1;
    
    plot(u(1,:));
    
end;

hold off;

figure

plot(u(2,:));


