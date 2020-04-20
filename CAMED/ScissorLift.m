%% SOLUTION FOR THE SCISSOR LIFT MECHANISM DS-1 CAMED %%
% Copyrights: Swaminath VENKATESWARAN, LS2N, Centrale Nantes, 15.03.2020

clear all;
clc;

% INTIALIZATION OF STROKE LENGHTS %
rho= [10:1:30 30:-1:10 10:0.5:20 20:-0.5:10 10:0.75:25 25:-0.75:10 10:1:30 30:-1:10];

% QUESTION DIALOG BOX: USER TO DECIDE WHICH TASK %
reponse = questdlg('Select the desired Task', ...
	'Task selection',...
    'Task-1','Task-2','Task-3','Task-1');

% IF TASK-3 IS CHOSEN USER CAN DECIDE ONLY 3D VIEW OR ALL VIEWS %
if(strcmp(reponse,'Task-3')==1)
    reponse2 = questdlg('Select an option', ...
               'Rendering',...
                '3D-View','All views','All views');
end

% INITIALIZATION OF STRUCTURE kine WHICH CONTAINS INFORMATION ABOUT ALL
% POINTS AND ARRAYS REQUIRED FOR THE PROGRAM %
kine=struct();

%INITIALIZATION OF LENGTHS AND ORIGIN%
kine.L1=20;kine.L2=20;kine.L3=20;kine.L4=20;
kine.o= [0,0];

for i = 1:length(rho)
    
    % Calculation of positions of passive revolute joints by calling "kinematics" %
    kine = kinematics(rho,i,kine);
    
    % Calculation of rigid platform position by calling "rects" %
    angle = 0; size= [15,10];
    [kine.A(i,:),kine.B(i,:),kine.C(i,:),kine.D(i,:)] = rects(angle,kine.h(i,:),size);
    
    % SWITCH-CASE based on user-response %
    
    switch reponse
        
        case 'Task-1'       
            % Task-1- Calling the function "DeuxD" %
            figure(1); %Setting a figure number is ideal 
            DeuxD(kine,i,'-',2,reponse);
            F(i)=getframe(gcf); %Frames for video
            
        case 'Task-2' 
            % Task-2- Calling the function "DeuxD" %
            figure(1); %Setting a figure number is ideal 
            DeuxD(kine,i,'--',1.5,reponse);            
            F(i)=getframe(gcf); %Frames for video %
            
        case 'Task-3'
                                
            % SWITCH-CASE based on user-response for Task-3 %
            switch reponse2
        
            case '3D-View'
               
                % Task-3- Calling the function "TroisD" to plot 3D view %
                figure(1);
                TroisD(kine,i,reponse,[550,550]);
                F(i)=getframe(gcf); %Frames for video %
                
            case 'All views'
                
                % Task-3- Calling the function "TroisD" to plot views in Third-angle projection %
                figure(1); 
                subplot(2,2,1)
                TroisD(kine,i,'Top view',[850,550]);
                view(0,90);
                subplot(2,2,2);
                TroisD(kine,i,'Isometric view',[850,550]);
                subplot(2,2,3)
                TroisD(kine,i,'Front view',[850,550]);
                view(0,0);
                subplot(2,2,4);
                TroisD(kine,i,'Right side view',[850,550]);
                view(90,0);
                F(i)=getframe(gcf); %Frames for video %
            end
    end

end

% VIDEO FILE CREATION: ASSIGNING NAMES FOR FILES BASED ON USER-RESPONSE %
% RUN EACH TASK ONE BY ONE TO GENERATE ALL VIDEO FILES IN W.DIRECTORY %
if(strcmp(reponse,'Task-1')==1 || strcmp(reponse,'Task-2')==1)
    video = VideoWriter(reponse,'MPEG-4');
elseif(strcmp(reponse,'Task-3')==1)
    nom = [reponse '-' reponse2];
    video = VideoWriter(nom,'MPEG-4');
end
open(video)
for i = 1:length(F)    
        writeVideo(video,F(i));
end
close(video)


%% FUNCTIONS FOR THE ALGORITHM %%

function kine = kinematics(rho,i,kine) % PUBLIC FUNCTION ACCESSED BY ALL THREE TASKS %
%% This function "kinematics" stores the positions of the passive revolute joints of the scissor mechanism for every stroke %%
% INPUTS  : rho   : The prismatic stroke of mechanism
%         : i     : Index position of array
%         : kine  : Structure is passed as input in order to extract output
% OUTPUTS : kine  : The output of kine will have the positions of passive revolute joints for every stroke (Saved as arrays)

        % Calculation of position of passive revolute joints for each index
        % of rho
        
        kine.a(i,1)= rho(i); kine.a(i,2)=0;
        kine.b(i,1)= rho(i)/2; kine.b(i,2)= sqrt(kine.L1^2-rho(i)^2/4);
        kine.c(i,1)= rho(i); kine.c(i,2)= sqrt((kine.L1+kine.L2)^2-rho(i)^2);
        kine.d(i,1)= 0; kine.d(i,2)= kine.c(i,2);
        kine.e(i,1)= kine.b(i,1); kine.e(i,2)= 3*kine.b(i,2);
        kine.f(i,1)= 0; kine.f(i,2) = kine.c(i,2) + sqrt((kine.L3+kine.L4)^2-rho(i)^2);
        kine.g(i,1)= rho(i); kine.g(i,2) = kine.f(i,2);
        kine.h(i,1)= 15;kine.h(i,2)=kine.f(i,2)+10;
        
end

function [A,B,C,D] = rects(angle,coord,size) % PUBLIC FUNCTION ACCESSED BY ALL THREE TASKS %
%% This function "rects" is used to calculate the positions of four corners of rectangle about its centroid subject to rotation
% INPUTS  : angle : The rotation angle of rectangle
%         : coord : The centroid position of rectangle from origin
%         : size  : The length and width of rectangle (The one-half values)
% OUTPUTS : A..D  : The four corners of the rectangles (2x1 array)

        Rotz= [cos(angle),-sin(angle);sin(angle),cos(angle)]; %The rot-z matrix in planar kinematics (2x2 Matrix)
        
        % Extraction of each corners (Rotz x size) plus the centroid
        % position from reference/origin
        
        A(1,1:2) = Rotz*[-size(1);-size(2)]; A(1,1) = A(1,1) + coord(1); A(1,2) = A(1,2) + coord(2);
        B(1,1:2) = Rotz*[-size(1);size(2)]; B(1,1) = B(1,1) + coord(1); B(1,2) = B(1,2) + coord(2);
        C(1,1:2) = Rotz*[size(1);-size(2)]; C(1,1) = C(1,1) + coord(1); C(1,2) = C(1,2) + coord(2);
        D(1,1:2) = Rotz*[size(1);size(2)]; D(1,1) = D(1,1) + coord(1); D(1,2) = D(1,2) + coord(2);
        
end

function DeuxD(kine,i,linetype,linesize,reponse) % FUNCTION DEDICATED FOR TASKS-1 & 2 %
%% This function "DeuxD" plots the results of Task-1 or 2 (based on user-choice) for each value of rho %%
% INPUTS  : kine      : The positions of passive joints and platform from structure is used
%         : i         : Index position of array
%         : linetype  : Dashed or continuous lines based on Task
%         : linesize  : Size of plot line based on Task
%         : reponse   : Provides title to task that is traced (user-decision)
% OUTPUTS : NIL (Plots passed to main)

            % Initialization of plot %
            links(kine.o,kine.a(i,:),[0,0,0],1.5,'--','l');
            hold on;
            grid on;
            grid minor;
            set(gca,'FontSize',20,'FontName','Times New Roman','FontWeight','Bold');
            x0 = 100; y0 = 100; % Origin for the plot screen
            largeur =550; % Length of plot screen from origin
            hauteur =550; % Width of plot screen from origin
            set(gcf,'units','points','position',[ x0, y0, largeur, hauteur])
            xlabel('x','FontSize',20,'FontName','Times New Roman','FontWeight','Bold');
            ylabel('y','FontSize',20,'FontName','Times New Roman','FontWeight','Bold');
            title(reponse);
            
            % Plot of links %
            links(kine.o,kine.c(i,:),[0.49,0.18,0.56],linesize,linetype,'l');
            links(kine.a(i,:),kine.d(i,:),[1.00,0.00,0.00],linesize,linetype,'l');
            links(kine.a(i,:),kine.d(i,:),[0.68,0.59,0.39],linesize,linetype,'l');
            links(kine.g(i,:),kine.d(i,:),[0.47,0.67,0.19],linesize,linetype,'l');
            links(kine.f(i,:),kine.c(i,:),[0.30,0.75,0.93],linesize,linetype,'l');
            
            % Plot of passive revolute joints %
            links(kine.o,kine.o,'k',4,'-','j');
            links(kine.a(i,:),kine.o,'k',4,'-','j');
            links(kine.b(i,:),kine.o,'k',4,'-','j');
            links(kine.c(i,:),kine.o,'k',4,'-','j');
            links(kine.d(i,:),kine.o,'k',4,'-','j');
            links(kine.e(i,:),kine.o,'k',4,'-','j');
            links(kine.f(i,:),kine.o,'k',4,'-','j');
            links(kine.g(i,:),kine.o,'k',4,'-','j');
            links(kine.h(i,:),kine.o,'k',2,'-','j');
            
            % Plot of rigid platform %
            links(kine.A(i,:),kine.B(i,:),[0.22,0.27,0.77],2.5,'-','l');
            links(kine.A(i,:),kine.C(i,:),[0.22,0.27,0.77],2.5,'-','l');
            links(kine.D(i,:),kine.C(i,:),[0.22,0.27,0.77],2.5,'-','l');
            links(kine.B(i,:),kine.C(i,:),[0,0,0],1,'--','l');
            links(kine.D(i,:),kine.A(i,:),[0,0,0],1,'--','l');
 
            % Labeling the joints with positions for each value of rho %
            links(kine.a(i,1)+1,kine.a(i,2),['A: [' (num2str(round(kine.a(i,1),2))) ' , ' (num2str(round(kine.a(i,2),2))) ']'],12,0,'t'); 
            links(kine.b(i,1)+3,kine.b(i,2),['B: [' (num2str(round(kine.b(i,1),2))) ' , ' (num2str(round(kine.b(i,2),2))) ']'],12,0,'t'); 
            links(kine.c(i,1)+1,kine.c(i,2),['C: [' (num2str(round(kine.c(i,1),2))) ' , ' (num2str(round(kine.c(i,2),2))) ']'],12,0,'t'); 
            links(kine.e(i,1)+3,kine.e(i,2),['E: [' (num2str(round(kine.e(i,1),2))) ' , ' (num2str(round(kine.e(i,2),2))) ']'],12,0,'t'); 
            links(kine.g(i,1)+1,kine.g(i,2)-2.5,['G: [' (num2str(round(kine.g(i,1),2))) ' , ' (num2str(round(kine.g(i,2),2))) ']'],12,0,'t'); 
            links(-10.5,0,['O: [' (num2str(0)) ' , ' (num2str(0)) ']'],12,0,'t'); 
            links(-13.5,kine.d(i,2),['D: [' (num2str(round(kine.d(i,1),2))) ' , ' (num2str(round(kine.d(i,2),2))) ']'],12,0,'t'); 
            links(-13.5,kine.f(i,2)-2.5,['F: [' (num2str(round(kine.f(i,1),2))) ' , ' (num2str(round(kine.f(i,2),2))) ']'],12,0,'t'); 
            
            % Dedicated for Task-2 to trace rectangular sections for links %
            if(strcmp(reponse,'Task-2')==1)
                
                angle= atan(kine.b(i,2)/kine.b(i,1)); %Estimation of rotation angle of links
                
                % Function "rects" called to extract corners of rectangle of the links %
                [kine.A1(i,:),kine.B1(i,:),kine.C1(i,:),kine.D1(i,:)] = rects(angle,[kine.b(i,1),kine.b(i,2)],[kine.L1,1]);
                [kine.A2(i,:),kine.B2(i,:),kine.C2(i,:),kine.D2(i,:)] = rects(pi-angle,[kine.b(i,1),kine.b(i,2)],[kine.L2,1]);
                [kine.A3(i,:),kine.B3(i,:),kine.C3(i,:),kine.D3(i,:)] = rects(angle,[kine.e(i,1),kine.e(i,2)],[kine.L3,1]);
                [kine.A4(i,:),kine.B4(i,:),kine.C4(i,:),kine.D4(i,:)] = rects(pi-angle,[kine.e(i,1),kine.e(i,2)],[kine.L4,1]);
                
                % Plotting the rectangular cross-sections%
                
                links(kine.A1(i,:),kine.C1(i,:),[0.49,0.18,0.56],2,'-','l');
                links(kine.D1(i,:),kine.B1(i,:),[0.49,0.18,0.56],2,'-','l');

                links(kine.A2(i,:),kine.C2(i,:),[1.00,0.00,0.00],2,'-','l');
                links(kine.D2(i,:),kine.B2(i,:),[1.00,0.00,0.00],2,'-','l');

                links(kine.A3(i,:),kine.C3(i,:),[0.47,0.67,0.19],2,'-','l');
                links(kine.D3(i,:),kine.B3(i,:),[0.47,0.67,0.19],2,'-','l');

                links(kine.A4(i,:),kine.C4(i,:),[0.30,0.75,0.93],2,'-','l');
                links(kine.D4(i,:),kine.B4(i,:),[0.30,0.75,0.93],2,'-','l');
                
            end
            
            % Limits for plot %
            xlim ([ -20 , 60]);
            ylim ([ -5 , 120]);
            drawnow();
            pause(0.01);
            hold off;
                        
 %% DEDICATED SUB-FUNCTION FOR TASKS-1 & 2 %%      
 
            function links(X,Y,couleur,size,style,conn)
%% This sub-function "links" is used to call the plot function to trace Task-1 or 2 based on user choice %%
% INPUTS  : X         : X coordinates for plot
%         : Y         : Y coordinates for plot
%         : couleur   : Color of line
%         : size      : Size of plot line based on Task
%         : style     : Linestyle of plot either dashed or continuous 
% OUTPUTS : NIL (Plots passed to function "DeuxD")

                if(strcmp(conn,'l')==1) % For line plot %
                    plot([X(1,1),Y(1,1)],[X(1,2),Y(1,2)],'color',couleur,'Linewidth',size,'Linestyle',style);
                elseif(strcmp(conn,'j')==1) %For scatter points (Passive joints) %
                    scatter(X(1),X(2),'MarkerEdgeColor',couleur,'MarkerFaceColor',couleur,'Linewidth',size);
                elseif(strcmp(conn,'t')==1) % Text labels %
                    text(X(1,1),Y(1,1),couleur,'FontSize',size,'FontName','Times New Roman','FontWeight','Bold');
                end

            end
            
end

 %% DEDICATED FUNCTION FOR TASK-3 %% 
function TroisD(kine,i,name,ecran)
 %% This function "TroisD" plots the results of Task-3 with only 3D or all views for each value of rho based on user-choice %%
% INPUTS  : kine      : The positions of passive joints and rigid platform from structure is used
%         : i         : Index position of array
%         : name      : Based on user-choice from reponse2, Title is assigned for Task-3 plots
%         : ecran     : Size of plot screen for either 3D or all views
% OUTPUTS : NIL (Plots passed to main)

            %Initialization of 3D plot screen window%
            plot3([0,kine.a(i,1)],[0,0],[0,kine.a(i,2)],'k--','LineWidth',1.5);
            hold on;
            grid on;
            grid minor;
            set(gca,'FontSize',20,'FontName','Times New Roman','FontWeight','Bold');
            x0 = 100; y0 = 100; % Origin for the plot screen
            largeur =ecran(1); % Length of plot screen from origin
            hauteur =ecran(2); % Width of plot screen from origin
            set(gcf,'units','points','position',[ x0, y0, largeur, hauteur])
            title(name);
            plot3([0,kine.a(i,1)],[5,5],[0,kine.a(i,2)],'k--','LineWidth',1.5);
            
            %Estimation of rectangular cross-sections for links (similar to Task-2%
            angle= atan(kine.b(i,2)/kine.b(i,1));
            
            [kine.A1(i,:),kine.B1(i,:),kine.C1(i,:),kine.D1(i,:)] = rects(angle,[kine.b(i,1),kine.b(i,2)],[kine.L1,1]);
            [kine.A2(i,:),kine.B2(i,:),kine.C2(i,:),kine.D2(i,:)] = rects(pi-angle,[kine.b(i,1),kine.b(i,2)],[kine.L2,1]);
            [kine.A3(i,:),kine.B3(i,:),kine.C3(i,:),kine.D3(i,:)] = rects(angle,[kine.e(i,1),kine.e(i,2)],[kine.L3,1]);
            [kine.A4(i,:),kine.B4(i,:),kine.C4(i,:),kine.D4(i,:)] = rects(pi-angle,[kine.e(i,1),kine.e(i,2)],[kine.L4,1]);
            
            % Sub-function "piece" called to create filled structures for each rectangular links %
            piece(kine.A1(i,:),kine.B1(i,:),kine.C1(i,:),kine.D1(i,:),[0,-0.5],[0.49,0.18,0.56]);
            piece(kine.A2(i,:),kine.B2(i,:),kine.C2(i,:),kine.D2(i,:),[0,0.5],[1.00,0.00,0.00]);
            piece(kine.A3(i,:),kine.B3(i,:),kine.C3(i,:),kine.D3(i,:),[0,-0.5],[0.47,0.67,0.19]);
            piece(kine.A4(i,:),kine.B4(i,:),kine.C4(i,:),kine.D4(i,:),[0,0.5],[0.30,0.75,0.93]);
            
            piece(kine.A1(i,:),kine.B1(i,:),kine.C1(i,:),kine.D1(i,:),[5,4.5],[0.49,0.18,0.56]);
            piece(kine.A2(i,:),kine.B2(i,:),kine.C2(i,:),kine.D2(i,:),[5,5.5],[1.00,0.00,0.00]);
            piece(kine.A3(i,:),kine.B3(i,:),kine.C3(i,:),kine.D3(i,:),[5,4.5],[0.47,0.67,0.19]);
            piece(kine.A4(i,:),kine.B4(i,:),kine.C4(i,:),kine.D4(i,:),[5,5.5],[0.30,0.75,0.93]);
            
            % Creation of cylinder for passive revolute joints by calling sub-function "Liaison" %
            R=0.7; %Radius changed to 0.7 from 1 against the Q.Paper
            h=5.5;
            
            % Trace of cylinders %
            Liaison(R,6,[0,-0.5,0],[0,0,0]);
            Liaison(R,6,[kine.a(i,1),-0.5,kine.a(i,2)],[0,0,0]);
            Liaison(R,h,[kine.b(i,1),-0.5,kine.b(i,2)],[0,0,0]); 
            Liaison(R,h,[kine.c(i,1),-0.5,kine.c(i,2)],[0,0,0]); 
            Liaison(R,h,[kine.d(i,1),-0.5,kine.d(i,2)],[0,0,0]); 
            Liaison(R,h,[kine.e(i,1),-0.5,kine.e(i,2)],[0,0,0]); 
            Liaison(R,h,[kine.f(i,1),-0.5,kine.f(i,2)],[0,0,0]); 
            Liaison(R,h,[kine.g(i,1),-0.5,kine.g(i,2)],[0,0,0]); 
            
            % Creation of fill3 for the rigid platform by calling "piece" %
            piece(kine.A(i,:),kine.A(i,:),kine.B(i,:),kine.B(i,:),[-0.5,5.5],[0,1,0]);
            piece(kine.A(i,:),kine.A(i,:),kine.C(i,:),kine.C(i,:),[-0.5,5.5],[0,1,0]);
            piece(kine.C(i,:),kine.C(i,:),kine.D(i,:),kine.D(i,:),[-0.5,5.5],[0,1,0]);
            piece(kine.A(i,:),kine.B(i,:),kine.C(i,:),kine.D(i,:),[-0.5,-0.5],[0,1,0]);
            piece(kine.A(i,:),kine.B(i,:),kine.C(i,:),kine.D(i,:),[5.5,5.5],[0,1,0]);
            
            % A correction factor %
            
            Bug(1,:)= kine.A(i,:); Bug(2,:)= kine.C(i,:);
            Bug(1,2)= Bug(1,2)+ 2.5; Bug(2,2)= Bug(2,2)+ 2.5; 
            piece(Bug(1,:),Bug(1,:),Bug(2,:),Bug(2,:),[-0.5,5.5],[0,1,0]);
      
            xlim([-15,60]);ylim([-1,7]);zlim([-20,110]);            
            hold off;
%% DEDICATED SUB-FUNCTIONS FOR TASK-3 %%      

            function piece(A,B,C,D,ep,couleur)
%% This sub-function "piece" is called to create fill3 for rectangular cross-sections %%
% INPUTS  : A..D      : The four corner of a rectangle to create fill3
%         : ep        : Extrusion thickness for rectangular cross-section
%         : couleur   : Color for fill3
% OUTPUTS : NIL (Plots passed to function "TroisD")

            %Sub-function closed called to create fill-3 %
            
            closed(A,B,D,C,[ep(1),ep(1),ep(1),ep(1)],couleur);
            closed(A,B,D,C,[ep(2),ep(2),ep(2),ep(2)],couleur);
            closed(C,C,D,D,[ep(1),ep(2),ep(2),ep(1)],couleur);
            closed(A,A,B,B,[ep(1),ep(2),ep(2),ep(1)],couleur);
            closed(B,B,D,D,[ep(1),ep(2),ep(2),ep(1)],couleur);
            closed(C,C,A,A,[ep(1),ep(2),ep(2),ep(1)],couleur);

%% SUB-SUB LEVEL FUNCTION CALLED BY "piece" FOR TASK-3 %%

                function closed(A,B,C,D,extrusion,couleur)
 %% This sub-sub function "closed" is called by "piece" to create fill3 %%
% INPUTS  : A..D      : Passed from "piece"
%         : extrusion : An array created from 'ep'
%         : couleur   : Passed from "piece"
% OUTPUTS : NIL (Plots passed to sub-function "piece")

                        X = [A(1,1),B(1,1),C(1,1),D(1,1)];
                        Z = [A(1,2),B(1,2),C(1,2),D(1,2)];
                        fill3(X,extrusion,Z,couleur);

                end

            end

            function Liaison(R,h,O,couleur)
%% This sub-function "Liaison" is called to create cylinder for the passive revolute joint %%
% INPUTS  : R         : Radius of cylinder
%         : h         : Height of cylinder
%         : couleur   : Color for cylinder
% OUTPUTS : NIL (Plots passed to function "TroisD")

                        [x,z,y]= cylinder(R);
                        x=x+O(1);
                        y=y*h+O(2);
                        z=z+O(3);
                        H1=surf(x,y,z);
                        set(H1,'edgecolor',couleur,'facecolor',couleur)          

            end
            
end

%% END OF PROGRAM %%




