function type = profil
%% CETTE FONCTION "profil" PERMET DE CHOISIR UN TYPE DE PROFIL %%
% ENTREE(S)  : Null (Rien)

% SORTIE(S)  : type  - La sélection est enregistrée en tant que caractères

%% LES TYPES DE PROFILS %%
% 1. CARRE
% 2. CIRCULAIRE
% 3. RECTANGULAIRE
% 4. CREUX CIRCULAIRE
% 5. PLUS
% 6. TUBE CARRE
% 7. CREUX RECTANGULAIRE
% 8. I
%
%%
    d = dialog('Position',[500 400 500 100],'Name','SELECTION DE PROFIL');

       btn = uicontrol('Parent',d,...
               'Position',[200 20 70 25],...
               'String','Start',...
               'Callback','delete(gcf)');

       txt = uicontrol('Parent',d,...
               'Style','text',...
               'Position',[0 50 215 40],...
               'String','CHOIX: ','FontSize',11);

       popup = uicontrol('Parent',d,...
               'Style','popup',...
               'Position',[200 50 220 40],...
               'String',{'CARRE';'CIRCULAIRE';'RECTANGULAIRE';'CREUX CIRCULAIRE';...
               'PLUS';'TUBE CARRE';'CREUX RECTANGULAIRE';'I'},...
               'Callback',@popup_callback1);
       type= 'CARRE';

       uiwait(d);        
       type= type;

       function popup_callback1(popup,~)
              idx = popup.Value;
              popup_items = popup.String;
              type= char(popup_items(idx,:));
       end
   
end