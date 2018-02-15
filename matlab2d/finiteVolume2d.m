function [ U ] = finiteVolume2d( U0, a, b, c, tmax, alpha, N)
%FINITEVOLUME1D 
%Effectue le calcul en volume fini avec le schema de rusanov en 1D avec les
%arguments suivants:
% - U0: la liste des vecteurs initiaux
% - a: la borne initiale du domaine
% - b: la borne maximale du domaine
% - c: profondeur
% - N: mailles par cote (suppose carre)
% - tmax : le temps de simulation
% - alpha: utilis� dans le calcul de la dur�e de pas.

% R�cup�rer le nombre de mailles
[M,NUMElem] = size(U0);
deltax = (b-a)/N;
t=0;

% Init u
u = U0;

% Conditions initiales au bord
u0n = u(:,1:N);           % Bord horizontal bas
uMn = u(:,(N*(N-1)+1):end); % Bord horizontal haut
v0n = u(:,1:N:end);       % Bord vertical gauche
vMn = u(:,N:N:end);       % Bord vertical droit

for i =1 : N
        %u0n(2,i) = -u0n(2,i);
        u0n(3,i) = -u0n(3,i);
        %uMn(2,i) = -uMn(2,i);
        uMn(3,i) = -uMn(3,i);
        v0n(2,i) = -v0n(2,i);
        %v0n(3,i) = -v0n(3,i);
        vMn(2,i) = -vMn(2,i);
        %vMn(3,i) = -vMn(3,i);
    end

n = 0;   % l'index initial

while ( t < tmax)
    % Calcul de Ln
    L = 0;
    B = zeros(M,NUMElem);
    
    % Boucle sur les interfaces Internes
    for i = 0 : N-1
        for j = 1 : N
            % Interface horizontale
            if(j<N)
                k = i*N+j;
                l = i*N+j+1;
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
            if(i<N-1)
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
    
    for i = 1 : N
        %u0n = u(:,1:N); % Bord horizontal bas
        uk = u0n(:,i);
        ul = u(:,i);
        
        [gi, c] = g(uk,ul, 2);
        B(:,i) = B(:,i) - gi;
        
        
    end
    
    for i = 1 : N
        %uMn = u(:,(N*(N-1)):end); % Bord horizontal haut
        uk = u(:,N*(N-1)+i);
        ul = uMn(:,i);
        
        [gi, c] = g(uk,ul, 2);
        B(:,N*(N-1)+i) = B(:,N*(N-1)+i) + gi;
    end
    
    for i = 1 : N
        %v0n = u(:,1:N:end);       % Bord vertical gauche
        uk = v0n(:,i);
        ul = u(:,1+(i-1)*N);
        
        [gi, c] = g(uk,ul, 1);
        B(:,1+(i-1)*N) = B(:,1+(i-1)*N) - gi;
    end

    for i = 1 : N
        %vMn = u(:,N:N:end);       % Bord vertical droit
        uk = u(:,N*i);
        ul = uMn(:,i);
        
        [gi, c] = g(uk,ul, 1);
        B(:,N*i) = B(:,N*i) + gi;
    end

    % Calcul de delta t
    dt = alpha * deltax / (2*L);
    dt = min([dt tmax - t]);

    % Boucle sur les mailles
    for i = 1:NUMElem
        u(:,i) = u(:,i) - dt*B(:,i)/deltax;
    end;
    
    %Mettre à jour les bords
    u0n = u(:,1:N);           % Bord horizontal bas
    uMn = u(:,(N*(N-1)+1):end); % Bord horizontal haut
    v0n = u(:,1:N:end);       % Bord vertical gauche
    vMn = u(:,N:N:end);       % Bord vertical droit
    

for i =1 : N
        %u0n(2,i) = -u0n(2,i);
        u0n(3,i) = -u0n(3,i);
        %uMn(2,i) = -uMn(2,i);
        uMn(3,i) = -uMn(3,i);
        v0n(2,i) = -v0n(2,i);
        %v0n(3,i) = -v0n(3,i);
        vMn(2,i) = -vMn(2,i);
        %vMn(3,i) = -vMn(3,i);
    end
   

    t = t + dt;
    n = n+1;
    
end;

U = u;
end

