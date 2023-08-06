close all
clear;clc;clf;
global Size;
x = linspace(0,15,16);
y = linspace(0,15,16);
[X,Y] = meshgrid(x,y);
line(X,Y,'color','b');
line(X',Y','color','b');
axis on equal;
axis([0 15 0 15]);
set(gca,'xtick',0:15);
Size=15;

gridindex = reshape(1:15*15,15,15)';
numposx = 0.5*(X(1:end-1,2:end)+X(1:end-1,1:end-1))-0.1;
numposy = 0.5*(Y(2:end,1:end-1)+Y(1:end-1,1:end-1));
for i = 1 : 15
    for j = 1 : 15
        text(numposx(i,j),numposy(i,j),num2str(gridindex(i,j)));
    end
end
P2 = [5,1];
P1 = [5,3];
covermat = calcover(P1,P2);