close all
Size=15;%生成地图尺寸
M=50;%种群大小M
n=Size;%n为染色体长度
GEN=500;%迭代次数
reserve=0.2;%精英策略保留的染色体比例
% map=randmap(Size,0.4);
load('map1.mat')%指定地图信息，记得更改地图尺寸
rgbmap=zeros(Size,Size,3);
rgbmap(:,:,1)=~map-sparse(Size,Size,1,Size,Size);
rgbmap(:,:,2)=~map-sparse(1,1,1,Size,Size);
rgbmap(:,:,3)=~map-sparse(1,1,1,Size,Size)-sparse(Size,Size,1,Size,Size); 
imshow(rgbmap,[],'InitialMagnification','fit'),axis normal;
title('原始地图')
axis on xy equal;
axis([0.5 Size+0.5 0.5 Size+0.5]) ;
for i = 1 : Size
    for j = 1 : Size
        text(i,j,num2str((j-1)*Size+i),'FontSize',4);
    end
end 
chro=Init_path(map,M);%初始化随机地图
% show_path(chro,map);
t=0;
topindex=zeros(1,ceil(M*reserve));
while t<GEN %对种群进行次数为GEN的迭代更新
    Fit=calf(chro);
    [f,index]=sort(Fit); 
    topindex(1,1:ceil(M*reserve))=index(1:ceil(M*reserve));%保留精英种群
    % chro=select(chro,topindex);
    chro=crossover(chro,map,topindex);
    chro=variation(chro,map,topindex);
    t=t+1;
end
% show_path(chro,map);
show_path(chro(:,:,topindex(1)),map);
title(['迭代次数为',num2str(GEN),'的最佳路径,适应度函数为：',num2str(Fit(1,topindex(1)))])

