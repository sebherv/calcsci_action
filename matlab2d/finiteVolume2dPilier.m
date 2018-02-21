function [ U ] = finiteVolume2d( U0, tmax, tinit, alpha, Nu, Nv, deltax)
%FINITEVOLUME1D 
%Effectue le calcul en volume fini avec le schema de rusanov en 1D avec les
%arguments suivants:
% - U0: la liste des vecteurs initiaux
% - tmax : le temps de simulation
% - tinit : temps initial
% - alpha: utilisé dans le calcul de la duree de pas
% - Nu: nombre de mailles dans la direction u
% - Nv: nombre de mailles dans la direction v
% - deltax: longueur côté maille (supposée carrée)

%Recup configuration des bords
global SV_REFLECT_TOP;
global SV_REFLECT_BOTTOM;
global SV_REFLECT_LEFT;
global SV_REFLECT_RIGHT;

global SV_DEBIT_U;
global SV_DEBIT_V;

global SV_FN_U0T;
global SV_FN_PERFORM;

pilierHalfSize = 2;

pu0n = Nu / 2 - pilierHalfSize;
puMn = Nu / 2 + pilierHalfSize;
pv0n = Nv / 2 - pilierHalfSize;
pvMn = Nv / 2 + pilierHalfSize;


[M,NUMElem] = size(U0);

t=0;

% Init u
u = U0;

n = 0;   % l'index initial

while ( t < tmax)
    % Calcul de Ln
    L = 0;
    B = zeros(M,NUMElem);
    
    %Mettre Ã  jour les bords
    v0n = u(:,1:Nu);           % Bord horizontal bas
    vMn = u(:,(Nu*(Nv-1)+1):end); % Bord horizontal haut
    u0n = u(:,1:Nu:end);       % Bord vertical gauche
    uMn = u(:,Nu:Nu:end);       % Bord vertical droit
    
    % Mettre à jour les bords du pilier
    for i = pu0n : puMn
        u(:,i + pv0n*Nu) = u(:,i + (pv0n-1)*Nu);
        u(3,i + pv0n*Nu) = -u(3,i + pv0n*Nu);
        
        u(:,i + pvMn*Nu) = u(:,i + (pvMn+1)*Nu);
        u(3,i + pvMn*Nu) = -u(3,i + pvMn*Nu);
    end
    
    for i = pv0n : pvMn
        u(:, i * Nu + pu0n) = u(:, i * Nu + pu0n - 1);
        u(2, i * Nu + pu0n) = -u(2, i * Nu + pu0n);
        
        u(:, i * Nu + puMn) = u(:, i * Nu + puMn + 1);
        u(2, i * Nu + puMn) = -u(2, i * Nu + puMn);
    end
    
    if SV_FN_PERFORM
        curImpulse = SV_FN_U0T(t+ tinit);
    end
    
    for i =1 : Nv
        if SV_REFLECT_LEFT
            u0n(2,i) = -u0n(2,i);
        else
            if SV_FN_PERFORM
                u0n(2,i) = curImpulse;
            else
                u0n(2,i) = SV_DEBIT_U;
            end
        end
        
        if SV_REFLECT_RIGHT
            uMn(2,i) = -uMn(2,i);
        else
            uMn(2,i) = SV_DEBIT_U;
        end
    end
    
    for i = 1 : Nu
        if SV_REFLECT_BOTTOM
            v0n(3,i) = -v0n(3,i);
        else
            v0n(3,i) = SV_DEBIT_V;
        end
        
        if SV_REFLECT_TOP
            vMn(3,i) = -vMn(3,i);
        else
            vMn(3,i) = SV_DEBIT_V;
        end
    end

    % Boucle sur les interfaces Internes
    for i = 0 : Nv-1
        for j = 1 : Nu
            
            if ~(j > pu0n-1 && j < puMn && i > pv0n-1 && i < pvMn) % gestion du pilier
                % Interface horizontale
                if(j<Nu)
                    k = i*Nu+j;
                    l = i*Nu+j+1;
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
                if(i<Nv-1) 
                    k = i*Nu+j;
                    l = (i+1)*Nu+j;
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
        end
    end;
    
    % Boucle sur les interfaces Externes
    % A gauche
    
    for i = 1 : Nu
        % Bord horizontal bas
        uk = v0n(:,i);
        ul = u(:,i);
        
        [gi, c] = g(uk,ul, 2);
        B(:,i) = B(:,i) - gi;
    end
    
    for i = pu0n : puMn
        % Bord superieur du pilier
        uk = u(:,i + pvMn * Nu);
        ul = u(:,i + (pvMn+1) * Nu);
        
        [gi, c] = g(uk,ul, 2);
        B(:,i + (pvMn+1) * Nu) = B(:,i + (pvMn+1) * Nu) - gi;
    end
        
    
    for i = 1 : Nu
        % Bord horizontal haut
        uk = u(:,Nu*(Nv-1)+i);
        ul = vMn(:,i);
        
        [gi, c] = g(uk,ul, 2);
        B(:,Nu*(Nv-1)+i) = B(:,Nu*(Nv-1)+i) + gi;
    end
    
    for i = pu0n : puMn
        % Bord inferieur du pilier 
        uk = u(:,i + (pv0n-1) * Nu);
        ul = u(:,i + pv0n * Nu);
        
        [gi, c] = g(uk,ul, 2);
        B(:,i + (pv0n-1) * Nu) = B(:,i + (pv0n-1) * Nu) + gi;
    end
    
    for i = 1 : Nv
        % Bord vertical gauche
        uk = u0n(:,i);
        ul = u(:,1+(i-1)*Nu);
        
        [gi, c] = g(uk,ul, 1);
        B(:,1+(i-1)*Nu) = B(:,1+(i-1)*Nu) - gi;
    end
    
    for i = pv0n : pvMn
        % bord droit du pilier
        uk = u(:,puMn + i * Nu);
        ul = u(:,puMn + i * Nu + 1);
        
        [gi, c] = g(uk,ul, 1);
        B(:,puMn + i * Nu + 1) = B(:,puMn + i * Nu + 1) - gi;
    end

    for i = 1 : Nv
        % Bord vertical droit
        uk = u(:,Nu*i);
        ul = uMn(:,i);
        
        [gi, c] = g(uk,ul, 1);
        B(:,Nu*i) = B(:,Nu*i) + gi;
    end
    
    for i = pv0n : pvMn
        % Bord gauche du pilier
        uk = u(:,pu0n + i * Nu - 1);
        ul = u(:,pu0n + i * Nu);
        
        [gi, c] = g(uk,ul, 1);
        B(:,pu0n + i * Nu - 1) = B(:,pu0n + i * Nu - 1) + gi;
    end

    % Calcul de delta t
    dt = alpha * deltax / (2*L);
    dt = min([dt tmax - t]);

    % Boucle sur les mailles
    for i = 1:NUMElem
        u(:,i) = u(:,i) - dt*B(:,i)/deltax;
    end
   

    t = t + dt;
    n = n+1;
    
end;

U = u;
end

