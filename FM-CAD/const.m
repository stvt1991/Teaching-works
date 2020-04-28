function [g,geq] = const(x,Param,type,probleme)
%% LA FONCTION CONTRAINTE
% ENTREE(S)  : x        - Valeurs initiales
%            : Param    - La structure avec les paramètres du matèriau
%            : type     - Choix du profil effectué par l'utilisateur
%            : problème - Type de problème (soit 'P1' soit 'P2')

% SORTIE(S)  : g        - Contraintes d'inégalité
%            : geq      - Contraintes d'égalité
%%
    Param = compute(x,Param,type); % On appelle "compute" pour trouver "S" et "I"
    
    % On calcule "Smax" (les contraintes max) de la poutre
    Smax = (Param.F * Param.L * Param.Opt.v) / Param.Opt.I; 
    
    g(1) = Smax - Param.sig0; % Cette contrainte est fixée pour les deux problèmes
    
    if(strcmp(probleme,'P1')==1) % Si le problème - P1
        
        del = obj(x,Param,type,'P2'); % Ici, on calcule la flèche en passant 'P2'à la fonction objectif
        
        g(2) = del - Param.da; % Cette contrainte va assurer la flèche dans les limites
      
    elseif(strcmp(probleme,'P2')==1) % Sinon Si le problème - P2
        
        m = obj(x,Param,type,'P1'); % Ici, on calcule la masse en passant 'P1'à la fonction objectif
        
        g(2) = m - Param.ma; % Cette contrainte va assurer la masse dans les limites
        
    end
        
    geq = []; % Rien
    
end
        


    