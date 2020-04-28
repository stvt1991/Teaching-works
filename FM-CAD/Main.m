%% DEMARAGE %%

clear all;
clc;

global type;

type = profil; % On appelle "profil" qui va enregistrer le type du profil comme les caractères

%% INITIALISATION %%

% On initialise un structure 'Param'. On peut simplement envoyer une seule
% structure aux fonctions
Param = struct(); 

Param.E = 2.1e11; %Module d'élasticité (Pa)
Param.rho = 7800; %Densité (kg/cu.m)
Param.sig0 = 2.1e8; %Limite d'élasticité (Pa)
Param.L = 2; %Longueur de la poutre (m)
Param.F = 20000; %Charge (N)
Param.da = 0.01; %Flèche max. (m)
Param.ma = 300; %Masse admissible (kg)

%% VECTEUR DES VALEURS INITIALES SELON LE CHOIX %%

% On définit également des BOUNDS pour un type de section %
% On utilise "strcmp" pour décider du vecteur initiales %

if(strcmp(type,'CARRE')==1 || strcmp(type,'CIRCULAIRE')==1)
    
    % x0 signifie "a" pour la section Carrée
    % x0 signifie "d" pour la section Circulaire
    
    x0 = 0.9; 
    lb = 0.001; ub = 1;
    
elseif(strcmp(type,'CREUX RECTANGULAIRE')==1 || strcmp(type,'I')==1)

    % x0(1) signifie "B" ,x0(2) signifie "H", x0(3) signifie "b", x0(4)
    % signifie "h"
    
    x0 = [0.01,0.4,0.005,0.1]; 
    lb = [0.01,0.4,0.005,0.1]; ub = [2,2,2,2];
    
else
    % x0(1) signifie "b" ,x0(2) signifie "h" pour la section Rectangulaire
    % x0(1) signifie "d" ,x0(2) signifie "D" pour la section Creux circulaire
    % x0(1) signifie "e" ,x0(2) signifie "h" pour la section Plus
    % x0(1) signifie "a" ,x0(2) signifie "A" pour la section Tube Carré

    x0 = [0.01,0.15];
    lb = [0.005,0.13]; ub = [1,1];
    
end

%% DES VERIFICATIONS (Si nécessaires) %%
 
[g1,geq1] = const(x0,Param,type,'P1');
[g2,geq2] = const(x0,Param,type,'P2');
    
%% OPTIMISATION %%

options=optimset('Algorithm','sqp','Display','iter','Tolx',1e-8,'Tolfun',...
                1e-8,'MaxIter',200000,'MaxFunEvals',800000);

% P1- Problème-1
[P1,P1Val] = fmincon(@(x)obj(x,Param,type,'P1'),x0,[],[],[],[],lb,ub,...
             @(x)const(x,Param,type,'P1'),options);

% P2- Problème-2
[P2,P2Val] = fmincon(@(x)obj(x,Param,type,'P2'),x0,[],[],[],[],lb,ub,...
             @(x)const(x,Param,type,'P2'),options);     
         

%% AFFICHAGE DES RESULTATS %%

if(strcmp(type,'CARRE')==1)
    O1= sprintf('Voici les résultats pour la section Carrée\n');
    O2= sprintf('Problème-1: a = %.4f m\n', P1);
    O3= sprintf('Problème-2: a = %.4f m\n', P2);
    h = msgbox({O1,O2,O3},'Résultats');  
    set(h, 'position', [100 200 700 170]); 
    ah = get( h, 'CurrentAxes' );
    ch = get( ah, 'Children' );
    set( ch, 'FontSize', 18 ); 
    
elseif(strcmp(type,'CIRCULAIRE')==1)
    O1= sprintf('Voici les résultats pour la section Circulaire\n');
    O2= sprintf('Problème-1: d = %.4f m\n', P1);
    O3= sprintf('Problème-2: d = %.4f m\n', P2);
    h = msgbox({O1,O2,O3},'Résultats');  
    set(h, 'position', [100 200 700 170]); 
    ah = get( h, 'CurrentAxes' );
    ch = get( ah, 'Children' );
    set( ch, 'FontSize', 18 ); 
    
elseif(strcmp(type,'RECTANGULAIRE')==1)
    O1= sprintf('Voici les résultats pour la section Rectangulaire\n');
    O2= sprintf('Problème-1: b = %.4f m , h = %.4f m\n', P1(1),P1(2));
    O3= sprintf('Problème-2: b = %.4f m , h = %.4f m\n', P2(1),P2(2));
    h = msgbox({O1,O2,O3},'Résultats');  
    set(h, 'position', [100 200 700 170]); 
    ah = get( h, 'CurrentAxes' );
    ch = get( ah, 'Children' );
    set( ch, 'FontSize', 18 ); 
    
elseif(strcmp(type,'CREUX CIRCULAIRE')==1)
    O1= sprintf('Voici les résultats pour la section Creux circulaire\n');
    O2= sprintf('Problème-1: d = %.4f m , D = %.4f m\n', P1(1),P1(2));
    O3= sprintf('Problème-2: d = %.4f m , D = %.4f m\n', P2(1),P2(2));
    h = msgbox({O1,O2,O3},'Résultats');  
    set(h, 'position', [100 200 700 170]); 
    ah = get( h, 'CurrentAxes' );
    ch = get( ah, 'Children' );
    set( ch, 'FontSize', 18 );
    
elseif(strcmp(type,'PLUS')==1)
    O1= sprintf('Voici les résultats pour la section Plus\n');
    O2= sprintf('Problème-1: e = %.4f m , H = %.4f m\n', P1(1),P1(2));
    O3= sprintf('Problème-2: e = %.4f m , H = %.4f m\n', P2(1),P2(2));
    h = msgbox({O1,O2,O3},'Résultats');  
    set(h, 'position', [100 200 700 170]); 
    ah = get( h, 'CurrentAxes' );
    ch = get( ah, 'Children' );
    set( ch, 'FontSize', 18 ); 
    
elseif(strcmp(type,'TUBE CARRE')==1)
    O1= sprintf('Voici les résultats pour la section Tube carré\n');
    O2= sprintf('Problème-1: a = %.4f m , A = %.4f m\n', P1(1),P1(2));
    O3= sprintf('Problème-2: a = %.4f m , A = %.4f m\n', P2(1),P2(2));
    h = msgbox({O1,O2,O3},'Résultats');  
    set(h, 'position', [100 200 700 170]); 
    ah = get( h, 'CurrentAxes' );
    ch = get( ah, 'Children' );
    set( ch, 'FontSize', 18 );
    
elseif(strcmp(type,'CREUX RECTANGULAIRE')==1)
    O1= sprintf('Voici les résultats pour la section Creux rectangulaire\n');
    O2= sprintf('Problème-1: B = %.4f m , H = %.4f m, b = %.4f m, h = %.4f m\n',...
        P1(1),P1(2),P1(3),P1(4));
    O3= sprintf('Problème-2: B = %.4f m , H = %.4f m, b = %.4f m, h = %.4f m\n',...
        P2(1),P2(2),P2(3),P2(4));
    h = msgbox({O1,O2,O3},'Résultats');  
    set(h, 'position', [100 200 700 170]); 
    ah = get( h, 'CurrentAxes' );
    ch = get( ah, 'Children' );
    set( ch, 'FontSize', 18 );
    
elseif(strcmp(type,'I')==1)
    O1= sprintf('Voici les résultats pour la section I\n');
    O2= sprintf('Problème-1: B = %.4f m , H = %.4f m, b = %.4f m, h = %.4f m\n',...
        P1(1),P1(2),P1(3),P1(4));
    O3= sprintf('Problème-2: B = %.4f m , H = %.4f m, b = %.4f m, h = %.4f m\n',...
        P2(1),P2(2),P2(3),P2(4));
    h = msgbox({O1,O2,O3},'Résultats');  
    set(h, 'position', [100 200 700 170]); 
    ah = get( h, 'CurrentAxes' );
    ch = get( ah, 'Children' );
    set( ch, 'FontSize', 18 );
end

%% FIN DU PROGRAMME %%