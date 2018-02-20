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
    
    
    
    for i =1 : Nv
        if SV_REFLECT_LEFT
            u0n(2,i) = -u0n(2,i);
        else
            %u0n(1,i) = 1;
            u0n(2,i) = SV_DEBIT_U;
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
    
    for i = 1 : Nu
        % Bord horizontal haut
        uk = u(:,Nu*(Nv-1)+i);
        ul = vMn(:,i);
        
        [gi, c] = g(uk,ul, 2);
        B(:,Nu*(Nv-1)+i) = B(:,Nu*(Nv-1)+i) + gi;
    end
    
    for i = 1 : Nv
        % Bord vertical gauche
        uk = u0n(:,i);
        ul = u(:,1+(i-1)*Nu);
        
        [gi, c] = g(uk,ul, 1);
        B(:,1+(i-1)*Nu) = B(:,1+(i-1)*Nu) - gi;
    end

    for i = 1 : Nv
        % Bord vertical droit
        uk = u(:,Nu*i);
        ul = uMn(:,i);
        
        [gi, c] = g(uk,ul, 1);
        B(:,Nu*i) = B(:,Nu*i) + gi;
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

