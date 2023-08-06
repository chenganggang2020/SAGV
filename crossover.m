function chro=crossover(chro,map,topindex)
% chro=CROSSOVER(chro,map,topindex)是一个对染色体簇进行交叉操作的函数
% 输入值chro是染色体簇，返回值是交叉操作后的染色体簇，map是栅格地图数据，
% topindex是用来保留精英族群的索引值元组，其中包含的是染色体簇中质量最好的染色体的索引值
Size=size(map,1);
n=Size;
Pc1=0.9;Pc2=0.6;%两个概率值
n1=randi(size(chro,3));%随机两个不同个体
n2=randi(size(chro,3));%n1,n2是染色体对应索引值
while n1==n2||any(find(topindex==n1))~=0||any(find(topindex==n2))~=0
    n2=randi(size(chro,3)); 
    n1=randi(size(chro,3));
end
Fit=calf(chro);
Fit_=min(Fit(1,n1),Fit(1,n2));
Fitavg=sum(Fit)/size(Fit,2);
Fitmin=min(Fit);
if Fit_<=Fitavg
    Pc=Pc1-((Pc1-Pc2)*(Fit_-Fitavg)/(Fitavg-Fitmin));%自适应交叉概率
else
    Pc=Pc1;
end
c=rand(1);
if c<Pc%概率达到，进行交叉操作
    index=[];
    for i=2: size(chro,1)-1%计算相同节点数
        if chro(i,1,n1)==chro(i,1,n2)&&chro(i,2,n1)==chro(i,2,n2)
            index=[index,i];
        end
    end
    f=false;
    while f==false%交叉重组两个染色体。
        % disp(["交叉两个染色体是",num2str(n1),num2str(n2)]);
        %1、存在相同节点 2、不存在相同节点
        if size(index,2)>0%1、存在相同节点
            % disp("存在相同节点");
            %对两个染色体进行交叉
            n3=index(randi(size(index,2)));% 随机一个节点,n3为节点索引值，作为交叉节点
            % disp(["交叉节点",num2str(n3)]);
            for i =n3+1:size(chro,1)-1
                temp1=chro(i,1,n1);
                temp2=chro(i,2,n1);
                chro(i,1,n1)=chro(i,1,n2);
                chro(i,2,n1)=chro(i,2,n2); 
                chro(i,1,n2)=temp1;
                chro(i,2,n2)=temp2;
            end
            f=true;
        elseif size(index,2)==0%2、不存在相同节点
            % disp("不存在相同节点");
            n3=randi(size(chro,1)-2)+1;% 随机选择一个节点,作为交叉节点
            % disp(["交叉节点",num2str(n3)]);
            cover1= calcover([chro(n3-1,1,n1),chro(n3-1,2,n1)],[chro(n3,1,n2),chro(n3,2,n2)],map);%判断两条染色体n1,n2直接交叉后在n3和n3-1处是否连续
            cover2= calcover([chro(n3-1,1,n2),chro(n3-1,2,n2)],[chro(n3,1,n1),chro(n3,2,n1)],map);%
            %1、直接交叉后可行 2、直接交叉后不可行
            if any(any(cover1.*map))==0||any(any(cover2.*map))==0%1、直接交叉后路径可行
                % disp("直接交叉后路径可行");
                for i=n3:size(chro,1)-1
                    temp1=chro(i,1,n1);
                    temp2=chro(i,2,n1);
                    chro(i,1,n1)=chro(i,1,n2);
                    chro(i,2,n1)=chro(i,2,n2); 
                    chro(i,1,n2)=temp1;
                    chro(i,2,n2)=temp2;
                end
                f=true;   
            else%2、直接交叉后路径不可行，随机当前交叉节点的位置，尝试让路径可行
                % disp("直接交叉后路径不可行");
                Max=(n-1)/2-abs(n3-(n+1)/2);
                possible_x=[];
                possible_y=[];
                for m=-Max:Max 
                    x=chro(1,1,n1)+(chro(n,1,n1)-chro(1,1,n1))*(n3-1)/(n-1)+m;
                    y=chro(1,2,n1)+(chro(n,2,n1)-chro(1,2,n1))*(n3-1)/(n-1)-m;
                    cover1= calcover([chro(n3-1,1,n1),chro(n3-1,2,n1)],[x,y],map);%判断两个染色体前后节点是否连续
                    cover2= calcover([chro(n3+1,1,n1),chro(n3+1,2,n1)],[x,y],map);
                    cover3= calcover([chro(n3-1,1,n2),chro(n3-1,2,n2)],[x,y],map);
                    cover4= calcover([chro(n3+1,1,n2),chro(n3+1,2,n2)],[x,y],map);
                    t1=any(any(cover1.*map));
                    t2=any(any(cover2.*map));
                    t3=any(any(cover3.*map));
                    t4=any(any(cover4.*map));
                    if t1==0&&t2==0&&t3==0&&t4==0
                        possible_x=[possible_x x];
                        possible_y=[possible_y y]; 
                    end
                end
                if size(possible_x,2)>0%随机后交叉节点路径可行
                    % disp("随机后交叉节点路径可行");
                    index=randi(size(possible_x));
                    chro(n3,1,n1)=possible_x(index);
                    chro(n3,1,n2)=possible_x(index);
                    chro(n3,2,n1)=possible_y(index);
                    chro(n3,2,n2)=possible_y(index);
                    for i =n3+1:size(chro,1)-1%交叉两个染色体
                        temp1=chro(i,1,n1);
                        temp2=chro(i,2,n1);
                        chro(i,1,n1)=chro(i,1,n2);
                        chro(i,2,n1)=chro(i,2,n2);
                        chro(i,1,n2)=temp1;
                        chro(i,2,n2)=temp2;
                    end
                    f=true;
                else%交叉节点无可用位置使得路径可行，从头开始，重新选择交叉重组
                    % disp("无节点可用，重新开始");
                    n1=randi(size(chro,3));
                    n2=randi(size(chro,3));
                    index=[];
                    while n1==n2||any(find(topindex==n1))~=0||any(find(topindex==n2))~=0%将精英族群的染色体跳过
                        n2=randi(size(chro,3));
                        n1=randi(size(chro,3));
                    end
                    for i=2: size(chro,1)-1%计算相同节点数
                        if chro(i,1,n1)==chro(i,1,n2)&&chro(i,2,n1)==chro(i,2,n2)
                            index=[index,i];
                        end 
                    end
                end
            
            end
        end
    end
end
% disp("交叉操作完成");
end

