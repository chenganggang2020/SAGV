clear;clc;clf;
x = linspace(0,10,11);
y = linspace(0,10,11);
[X,Y] = meshgrid(x,y);
line(X,Y,'color','b');
line(X',Y','color','b');
axis equal;
axis([0 10 0 10]);
set(gca,'xtick',0:10);

gridindex = reshape(1:100,10,10)';
numposx = 0.5*(X(1:end-1,2:end)+X(1:end-1,1:end-1))-0.1;
numposy = 0.5*(Y(2:end,1:end-1)+Y(1:end-1,1:end-1));
for i = 1 : 10
    for j = 1 : 10
        text(numposx(i,j),numposy(i,j),num2str(gridindex(i,j)));
    end
end

P2 = [4.5,6.5];
P1 = [7.5,5.5];
segs = calLength(P1,P2);

