function [ U ] = finiteVolume1d( U0, a, b, tmax, alpha )
%FINITEVOLUME1D 
%Effectue le calcul en volume fini avec le schéma de rusanov en 1D avec les
%arguments suivants:
% - U0: la liste des vecteurs initiaux
% - a: la borne initiale du domaine
% - b: la borne maximale du domaine
% - tmax : le temps de simulation
% - alpha: utilisé dans le calcul de la durée de pas.

% Récupérer le nombre de mailles
[M,N] = size(U0);
deltax = (b-a)/N;
t=0;

% Init u
u = U0;

% Conditions initiales au bord
u0n = u(:,1);
uMn = u(:,end);



n = 0;   % l'index initial

while ( t < tmax)
    % Calcul de Ln
    L = 0;
    B = zeros(M,N);
    
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
    end;
    
    %Mettre à jour les bords
    u0n = u(:,1);
    u0n(2) = -u0n(2);
    uMn = u(:,end);
    uMn(2) = -uMn(2);
   

    t = t + dt;
    n = n+1;
    
end;

U = u;
end

