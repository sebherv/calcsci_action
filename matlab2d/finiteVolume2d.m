function [ U ] = finiteVolume1d( U0, a, b, c, N, tmax, alpha )
%FINITEVOLUME1D 
%Effectue le calcul en volume fini avec le schéma de rusanov en 1D avec les
%arguments suivants:
% - U0: la liste des vecteurs initiaux
% - a: la borne initiale du domaine
% - b: la borne maximale du domaine
% - c: profondeur
% - N: mailles par côté (supposé carré)
% - tmax : le temps de simulation
% - alpha: utilisé dans le calcul de la durée de pas.

% Récupérer le nombre de mailles
[M,N] = size(U0);
deltax = (b-a)/N;
t=0;

% Init u
u = U0;

% Conditions initiales au bord
u0n = u(:,1:N);
uMn = u(:,N:end);
v0n = u(:,1:N); % TODO adapter avec les vrais bords
vMn = u(:,N:end); % TODO adapter avec les vrais bords



n = 0;   % l'index initial

while ( t < tmax)
    % Calcul de Ln
    L = 0;
    B = zeros(M,N);
    
    % Boucle sur les interfaces Internes
    for i = 1 : N
        for j = 1 : N
            
            % Interface horizontale
            if(j<N)
                k = i*N+j;
                l = i*N+j+1
                u1 = u(:,k);
                u2 = u(:,l);
        
                [gi, c] = g(u1,u2, 1);

                B(:,k) = B(:,k) + gi;
                B(:,l) = B(:,l) - gi;
            
                % Update if necessary
                if c > L
                    L = c;
                end;
            end;
            
            % Interface verticale
            if(i<N)
                k = i*N+j;
                l = (i+1)*N+j;
                u1 = u(:,k);
                u2 = u(:,l);
        
                [gi, c] = g(u1,u2, 2);

                B(:,k) = B(:,k) + gi;
                B(:,l) = B(:,l) - gi;
        
                % Update if necessary
                if c > L
                    L = c;
                end;
            end;
        end
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

