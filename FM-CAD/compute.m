function Param = compute(x,Param,type)
%% CETTE FONCTION "Param" CALCULE "La section transversale (S)" , "Le moment quadratique (I)" 
%% ET "La position de l'axe neutre (v) "
% ENTREE(S)  : x        - Valeurs initiales
%            : Param    - La structure avec les paramètres du matèriau
%            : type     - Choix du profil effectué par l'utilisateur

% SORTIE(S)  : Param    - On met les résultats dans la même structure

%%
    if(strcmp(type,'CARRE')==1)
        
        Param.Opt.S = x*x;
        Param.Opt.I = x^4/12;
        Param.Opt.v = x/2;
        
    elseif(strcmp(type,'CIRCULAIRE')==1)
        
        Param.Opt.S = pi*x^2/4;
        Param.Opt.I = pi*x^4/64;
        Param.Opt.v = x/2;
        
    elseif(strcmp(type,'RECTANGULAIRE')==1)
        
        Param.Opt.S = x(1)*x(2);
        Param.Opt.I = (x(1)* x(2)^3)/12;
        Param.Opt.v = x(2)/2;
    
    elseif(strcmp(type,'CREUX CIRCULAIRE')==1)
        
        Param.Opt.S = pi*(x(2)^2-x(1)^2)/4;
        Param.Opt.I = pi*(x(2)^4-x(1)^4)/64;
        Param.Opt.v = x(2)/2;
        
    elseif(strcmp(type,'PLUS')==1)
        
        Param.Opt.S = (x(1)*x(2)) + (x(1)*(x(2)-x(1)));
        Param.Opt.I = ((x(1)*(x(2)-x(1))^3)/48) + ((x(2)*x(1)^3)/12);
        Param.Opt.v = x(2)/2;
        
    elseif(strcmp(type,'TUBE CARRE')==1)
        
        Param.Opt.S = x(2)^2 - x(1)^2;
        Param.Opt.I = (x(2)^4 - x(1)^4)/12;
        Param.Opt.v = x(2)/2;  
        
    elseif(strcmp(type,'CREUX RECTANGULAIRE')==1)
        
        Param.Opt.S = (x(2)*x(1))-(x(4)*x(3));
        Param.Opt.I = ((x(1)*x(2)^3)-(x(3)*x(4)^3))/12;
        Param.Opt.v = x(2)/2;  
        
    elseif(strcmp(type,'I')==1)
        
        Param.Opt.S = (x(1)*(x(2)-x(4))) + (x(3)*x(4));
        Param.Opt.I = ((x(1)*(x(2)-x(4))^3)/48) + ((x(3)*x(4)^3)/12);
        Param.Opt.v = x(2)/2;  
        
    end
    
end
    