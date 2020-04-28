function f = obj(x,Param,type,probleme)
%% LA FONCTION OBJECTIF
% ENTREE(S)  : x        - Valeurs initiales
%            : Param    - La structure avec les param�tres du mat�riau
%            : type     - Choix du profil effectu� par l'utilisateur
%            : probl�me - Type de probl�me (soit 'P1' soit 'P2')

% SORTIE(S)  : f        - Sortie de 'P1' ou 'P1' pour "fmincon"
%% 
    
    Param = compute(x,Param,type); % On appelle "compute" pour trouver "S" et "I"
    
    if(strcmp(probleme,'P1')==1)
        
        % Minimisation de la masse pour le probl�me-1
        
        f = Param.Opt.S * Param.L * Param.rho; 
        
    elseif(strcmp(probleme,'P2')==1)
        
        % Minimisation de la fl�che pour le probl�me-2
        
        f = (Param.F*Param.L^3)/(3*Param.E*Param.Opt.I); 
        
    end    
        
end
