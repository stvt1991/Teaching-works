clear all;
clc;

x= 0.05:0.01:0.3;
y= 0.05:0.01:0.3;

[X,Y] = meshgrid(x,y);

Z = X.*Y.*2*7800;

[X1,Y1] = meshgrid(x,y);
Z1 = (20000*32)./(2.1e11.*X1.*Y1.^3);


y1 = 0:0.01:0.4;
x1 = (400*20000*8)./(2.1e11*y1.^3);
y2 = 0:0.01:0.4;
x2 = (6*20000*2)./(2.1e8*y2.^2);

figure(1);
subplot(1,2,1);
contourf(X,Y,Z);
hold on;
scatter(x1,y1,'g+');
scatter(x2,y2,'y+');
xlim([0,0.3]);
ylim([0,0.3]);

subplot(1,2,2);
contourf(X1,Y1,Z1);
xlim([0.05,0.15]);
ylim([0.05,0.13]);
hold on;
scatter(x2,y2,'y+');



