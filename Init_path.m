function chro =Init_path(map,M)
%INIT_PATH是一个给染色体簇初始化的函数，可以生成M条可行路径数据(M条染色体),作为染色体簇的初始数据
% chro=INIT_PATH(map,M)，返回值chro,是大小为n*2*M的染色体簇矩阵，其中n为节点个数，在此函数中设为n=Size
% M是指定的染色体数量
Size=size(map,1);
n=Size;
chro=zeros(n,2,M);
for t=1:M
    chro(1,1,t)=1;chro(1,2,t)=1;%设置起始点
    chro(n,1,t)=n;chro(n,2,t)=n;
    i=2;%从第二个节点开始初始化可行路径
    while i<=n
        max=(n-1)/2-abs(i-(n+1)/2);
        possible_x=[];
        possible_y=[];
        for m=-max:max
            temp=zeros(Size,Size,i);
            x=chro(1,1,t)+(chro(n,1,t)-chro(1,1,t))*(i-1)/(n-1)+m;
            y=chro(1,2,t)+(chro(n,2,t)-chro(1,2,t))*(i-1)/(n-1)-m;
            cover= calcover([chro(i-1,1,t),chro(i-1,2,t)],[x,y],map);
            temp(:,:,i)=cover.*map;
            if temp(:,:,i)==0
                possible_x=[possible_x x];
                possible_y=[possible_y y];
            end
        end
       if size(possible_x,2)==0
          i=2;
       else
       index=randi(size(possible_y,2));
       chro(i,1,t)=possible_x(index);
       chro(i,2,t)=possible_y(index);
       i=i+1;
       end
    end
end
% disp("初始化地图完成")
end

