function f = obj(x,Param,type,probleme)
%% LA FONCTION OBJECTIF
% ENTREE(S)  : x        - Valeurs initiales
%            : Param    - La structure avec les paramètres du matèriau
%            : type     - Choix du profil effectué par l'utilisateur
%            : problème - Type de problème (soit 'P1' soit 'P2')

% SORTIE(S)  : f        - Sortie de 'P1' ou 'P1' pour "fmincon"
%% 
    
    Param = compute(x,Param,type); % On appelle "compute" pour trouver "S" et "I"
    
    if(strcmp(probleme,'P1')==1)
        
        % Minimisation de la masse pour le problème-1
        
        f = Param.Opt.S * Param.L * Param.rho; 
        
    elseif(strcmp(probleme,'P2')==1)
        
        % Minimisation de la flèche pour le problème-2
        
        f = (Param.F*Param.L^3)/(3*Param.E*Param.Opt.I); 
        
    end    
        
end
