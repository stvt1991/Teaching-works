%% A FUNCTION "crank" TO PLOT AND ANIMATE A SLIDER-CRANK MECHANISM
% Copyrights: Swaminath VENKATESWARAN, LS2N, Centrale Nantes, 01.03.2020

function crank
% INPUTS  : nil
% OUTPUTS : nil (Trace)
    %% INITIALIZATION %%

    R= 24; %Radius of crank wheel
    L= 100; %Length of connecting rod

    theta= 0:pi/60:6*pi; %Discretization of angle from 0 to 360 degrees


    %% FORWARD KINEMATICS
    X = R.*cos(theta) + sqrt((R^2.*(cos(theta).^2) - R^2 + L^2));
    
    %Comment line 16 and uncomment lines 20-25 to use the for loop
    
%     X = zeros();
%     for k = 1 : length(theta)
%         
%         X(k) =  R*cos(theta(k)) + sqrt(L^2 - R^2*sin(theta(k))^2);
%         
%     end
    
    %% PLOTTING THE MECHANISM %%
    % A loop to trace the mechanism for all discretized points of theta
    
    for i = 1 : length(theta)

        figure(1); %Setting a figure number is ideal 
        set(gca,'FontSize',20,'FontName','Times New Roman','FontWeight','Bold')

        % Plotting screen size setting
        
        X0=50;Y0=40; %Origin for the plot screen
        largeur=1250; %Length of plot screen from origin
        hauteur=450; %Width of plot screen from origin
        set(gcf,'units','points','position',[X0,Y0,largeur,hauteur])

        % Plotting the mechanism  
        
        th = 0:pi/50:2*pi;
        [x0,y0] = positions(th,[0,0],1); % A sub-function "position" is called to draw a circle
        [x1,y1] = positions(th,[0,0],R); 
        
        h1 = fill(x1, y1,[0.06,1.00,1.00]); % The crank plot
        hold on; %Important to plot multiple traces in a single window
        h2 = fill(x0, y0,[1.00,0.41,0.16]); % The central orange pin
        
        %Plot of CRod/Crank pin
        
        [px,py] = positions(theta(i),[0,0],R-1); %Extract the centre for crank pin
        [x2,y2] = positions(th,[px,py],1); %Using line 54 as centre, extract crank pin circle coordinates
        h3 = fill(x2,y2,[1.00,0.41,0.16]); % The crank/CRod orange pin

        %Plot of connecting rod
        
        h4= plot([0,px],[0,py],'k--','Linewidth',1); % Reference line in dot 
        h5= plot([px,X(i)],[py,0],'k--','Linewidth',1); % Reference line in dot (CRod)
              
        %Plot of slider block
        
        angle = 0; %Slider block remains horizontal at all positions
        coord = [X(i),0]; %Centroid position of slider block from origin
        size = [5,1]; %Size of rectangle with respect to centroid
        [A,B,C,D] = rects(angle,coord,size); % A sub-function "rects" is called to extract four corners of slider block
        h6 = fill([A(1,1),B(1,1),D(1,1),C(1,1)],[A(1,2),B(1,2),D(1,2),C(1,2)],...
                [0.07,0.30,0.15]); % Tracing the slider
            
        %Plot of slider pin
        
        [x3,y3] = positions(th,[X(i),0],1); %Extract the circle coordinates for slider pin
        h7 = fill(x3,y3,[0.00,0.45,0.74]); % Tracing the slider pin    
        
        %Plotting the rectangular cross-section inside Crank 
        
        coord = [(R-1)*cos(theta(i))/2, (R-1)*sin(theta(i))/2]; %Centroid extraction
        size = [(R-1)/2,1]; %Size of CRod
        [A1,B1,C1,D1] = rects(theta(i),coord,size); %Extract four corners of the rectangle using "rects"        
        h8=plot([A1(1,1),B1(1,1)],[A1(1,2),B1(1,2)],'color',[1.00,0.41,0.16],'LineWidth',2);
        h9=plot([A1(1,1),C1(1,1)],[A1(1,2),C1(1,2)],'color',[1.00,0.41,0.16],'LineWidth',2);
        h10=plot([D1(1,1),B1(1,1)],[D1(1,2),B1(1,2)],'color',[1.00,0.41,0.16],'LineWidth',2);
        
        %Plotting the rectangular cross-section of CRod
        angle = pi -asin((R-1)*sin(theta(i))/(L+1)); %Estimation of rotation angle
        coord = [(R-1)*cos(theta(i))+(sqrt((L+1)^2-(R-1)^2*(sin(theta(i)))^2))/2,...
                (R-1)*sin(theta(i))/2]; %Centroid position
        size = [(L+1)/2,1]; % Size of block
        [A2,B2,C2,D2] = rects(angle,coord,size);%Extract four corners of the rectangle using "rects"             
        h11=plot([A2(1,1),C2(1,1)],[A2(1,2),C2(1,2)],'color',[0.00,0.45,0.74],'LineWidth',2);
        h12=plot([D2(1,1),B2(1,1)],[D2(1,2),B2(1,2)],'color',[0.00,0.45,0.74],'LineWidth',2);        
        
        %Setting x & y limits for the plot area
        xlim([-50,140]);
        ylim([-30,30]);
        grid on;

        %Commands to generate animation and frame extraction
        drawnow;
        F(i)= getframe(gcf);
        pause(0.01)

        %Deleting instances for each iteration of loop
        % This IF condition ensures that the fontsize and setting of plot is retained
        
        if i < length(theta)
            delete(h1);
            delete(h2);
            delete(h3);
            delete(h4);
            delete(h5);
            delete(h6);
            delete(h7);
            delete(h8);
            delete(h9);
            delete(h10);
            delete(h11);
            delete(h12);
        end

    end

    % Generate video of simulation %
    
    video = VideoWriter('Slider-Crank','MPEG-4');
    open(video)
    for i = 1:length(F)    
            writeVideo(video,F(i));
    end
    close(video)
	
    %% SUB-FUNCTIONS %%
    
    function [x,y] = positions(theta,centre,R)
%% This function "position" is used to estimate x-y coordinates for tracing a circle
% INPUTS  : theta : Usually from 0 to 2*pi 
%           centre: The circle centre, array of size 1x2 
%           R     : The radius of circle
% OUTPUTS : x     : The x-coordinate for a given angle theta
%           y     : The y-coordinate for a given angle theta
    
        x = centre(1) + R.*cos(theta);
        y = centre(2) + R.*sin(theta);
    
    end

    function [A,B,C,D] = rects(angle,coord,size)
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

end
