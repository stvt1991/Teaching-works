function [g,geq] = const(x,Param,type,probleme)
%% LA FONCTION CONTRAINTE
% ENTREE(S)  : x        - Valeurs initiales
%            : Param    - La structure avec les param�tres du mat�riau
%            : type     - Choix du profil effectu� par l'utilisateur
%            : probl�me - Type de probl�me (soit 'P1' soit 'P2')

% SORTIE(S)  : g        - Contraintes d'in�galit�
%            : geq      - Contraintes d'�galit�
%%
    Param = compute(x,Param,type); % On appelle "compute" pour trouver "S" et "I"
    
    % On calcule "Smax" (les contraintes max) de la poutre
    Smax = (Param.F * Param.L * Param.Opt.v) / Param.Opt.I; 
    
    g(1) = Smax - Param.sig0; % Cette contrainte est fix�e pour les deux probl�mes
    
    if(strcmp(probleme,'P1')==1) % Si le probl�me - P1
        
        del = obj(x,Param,type,'P2'); % Ici, on calcule la fl�che en passant 'P2'� la fonction objectif
        
        g(2) = del - Param.da; % Cette contrainte va assurer la fl�che dans les limites
      
    elseif(strcmp(probleme,'P2')==1) % Sinon Si le probl�me - P2
        
        m = obj(x,Param,type,'P1'); % Ici, on calcule la masse en passant 'P1'� la fonction objectif
        
        g(2) = m - Param.ma; % Cette contrainte va assurer la masse dans les limites
        
    end
        
    geq = []; % Rien
    
end
        


    