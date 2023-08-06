function show_path(chro,map)
% SHOW_PATH 是一个将染色体簇包含的路径信息在规定的图上显示出来的函数
% SHOW_PATH(chro,map),chro变量是染色体簇数据，map是栅格数据地图
Size=size(map,1);
[n,~,num]=size(chro);
rgbmap=zeros(Size,Size,3);
rgbmap(:,:,1)=~map-sparse(Size,Size,1,Size,Size);
rgbmap(:,:,2)=~map-sparse(1,1,1,Size,Size);
rgbmap(:,:,3)=~map-sparse(1,1,1,Size,Size)-sparse(Size,Size,1,Size,Size);
for t=1:num
    figure;
    imshow(rgbmap,[],'InitialMagnification','fit'),axis normal;
    axis on xy equal;
    axis([0.5 Size+0.5 0.5 Size+0.5]);
    for i = 1 : Size
        for j = 1 : Size
            text(i,j,num2str((j-1)*Size+i),'FontSize',6);
        end
    end
    colormap=['r','b','y','m','c','k','g']; 
    line([chro(1:n-1,1,t),chro(2:n,1,t)],[chro(1:n-1,2,t),chro(2:n,2,t)],'color','b');
end
disp("显示路线完成!")
end