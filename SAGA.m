close all
global Size M n map topindex;
Size=15;%生成地图尺寸
M=10 ;%种群大小M
n=Size;%n为染色体长度
GEN=50;%迭代次数

map=randmap(Size);
rgbmap(:,:,1)=~map-sparse(Size,Size,1,Size,Size);
rgbmap(:,:,2)=~map-sparse(1,1,1,Size,Size);
rgbmap(:,:,3)=~map-sparse(1,1,1,Size,Size)-sparse(Size,Size,1,Size,Size);
% imshow(rgbmap,[],'InitialMagnification','fit'),axis normal;
% axis on xy equal;
% axis([0.5 Size+0.5 0.5 Size+0.5]) ;
% for i = 1 : Size
%     for j = 1 : Size
%         text(i,j,num2str((j-1)*Size+i),'FontSize',6);
%     end
% end 
chro=Init(map);
t=0;reserve=0.2;
topindex=zeros(1,ceil(M*reserve));
while t<GEN
    Fit=calf(chro);
    [f,index]=sort(Fit); 
    topindex(1,1:ceil(M*reserve))=index(1:ceil(M*reserve));
%     chro=select(chro);
    chro=Crossover(chro);
    chro=Variation(chro);
    t=t+1;
end
for t=1:size(chro,3)
    figure(t)
    imshow(rgbmap,[],'InitialMagnification','fit'),axis normal;
    axis on xy equal;
    axis([0.5 Size+0.5 0.5 Size+0.5]) ;
    for i = 1 : Size
        for j = 1 : Size   
            text(i,j,num2str((j-1)*Size+i),'FontSize',6);
        end
    end
    colormap=['r','b','y','m','c','k','g']; 
    line([chro(1:n-1,1,t),chro(2:n,1,t)],[chro(1:n-1,2,t),chro(2:n,2,t)],'color','b');
end
figure('Name','最优路径')
imshow(rgbmap,[],'InitialMagnification','fit'),axis normal;
axis on xy equal;
axis([0.5 Size+0.5 0.5 Size+0.5]) ;
for i = 1 : Size
    for j = 1 : Size   
        text(i,j,num2str((j-1)*Size+i),'FontSize',6);
    end
end
colormap=['r','b','y','m','c','k','g']; 
line([chro(1:n-1,1,topindex(1)),chro(2:n,1,topindex(1))],[chro(1:n-1,2,topindex(1)),chro(2:n,2,topindex(1))],'color','c');
