function chro =variation(chro,map,topindex)
% VARIATION 是一个对染色体进行变异操作的函数
% chro =VARIATION(chro)
% 返回值 chro是变异后的染色体
% 输入值 chro是需要操作的染色体
Pm1=0.2;Pm2=0.005;  
Fit=calf(chro);%计算所有染色体的适应函数
Fitavg=sum(Fit)/size(Fit,2);
Fitmin=min(Fit);
Pm=zeros(size(Fit));
[n,~,num]=size(chro);
for t=1:num
    if any(find(topindex==t))~=0
        continue;%将属于精英族群的染色体跳过
    end
    %申请两个临时变量交换染色体
    chrof=chro(:,:,t);
    chrob=chro(:,:,t);
    if Fit(1,t)<=Fitavg%设置自适应变异概率
        Pm(1,t)=Pm1-((Pm1-Pm2)*(Fit(1,t)-Fitavg)/(Fitavg-Fitmin));
    else
        Pm(1,t)=Pm1; 
    end
    p=rand(1);%判断变异概率
    if p<Pm(1,t)%变异过程
        num1=randi(size(chro,1)-2); %随机出第一个和第二个染色体节点位置编号n1,n2
        num2=randi(size(chro,1)-2);
        while num1==num2
            num2=randi(size(chro,1)-2);
        end
        n1=min(num1,num2)+1;
        n2=max(num1,num2)+1;
        % disp(["第",num2str(t),"个染色体的两个变异染色体节点是",num2str(n1),num2str(n2)]);
        i=2;
        while i<=size(chro,1)%遍历一个染色体的所有节点,分段变异生成两个染色体
            if i<n1%r1段染色体变异
                Max=(n-1)/2-abs(i-(n+1)/2);%计算最大偏移位置
                possible1_x=[];%申请两个变量存储坐标
                possible1_y=[];
                for m=-Max:Max
                    temp=zeros(n,n,i);
                    x=chro(1,1,t)+(chro(n,1,t)-chro(1,1,t))*(i-1)/(n-1)+m;
                    y=chro(1,2,t)+(chro(n,2,t)-chro(1,2,t))*(i-1)/(n-1)-m;
                    cover1= calcover([chrof(i-1,1),chrof(i-1,2)],[x,y],map);%当前节点与前一节点连接路径判断是否与地图障碍物碰撞
                    if i==n1-1%判断变异节点n1与前后节点路径是否合理
                        cover2=calcover([chrof(i+1,1),chrof(i+1,2)],[x,y],map);
                    else
                        cover2=0;
                    end
                    temp(:,:,i)=cover1.*map;
                    if any(any(temp(:,:,i)))==0&&any(any(cover2.*map))==0
                        possible1_x=[possible1_x x];
                        possible1_y=[possible1_y y];
                    end
                end
                %判断变异节点是否可用
                if size(possible1_x,2)==0%变异节点不可用
                    i=1;
                else%变异节点可用
                    index=randi(size(possible1_x,2));
                    chrof(i,1,1)=possible1_x(index);
                    chrof(i,2,1)=possible1_y(index);
                end 
            end
             if i>n2
                Max=(n-1)/2-abs(i-(n+1)/2);
                possible2_x=[];
                possible2_y=[];
                for m=-Max:Max
                    temp=zeros(n,n,i);
                    x=chro(1,1,t)+(chro(n,1,t)-chro(1,1,t))*(i-1)/(n-1)+m;
                    y=chro(1,2,t)+(chro(n,2,t)-chro(1,2,t))*(i-1)/(n-1)-m;
                    cover1= calcover([chrob(i-1,1),chrob(i-1,2)],[x,y],map);
                    if i==n2+1%判断变异节点n2与前后节点路径是否合理
                        cover2=calcover([chrob(i-1,1),chrob(i-1,2)],[x,y],map);
                    else
                        cover2=0;
                    end  
                    temp(:,:,i)=cover1.*map;
                    %前后节点都可用
                    if any(any(temp(:,:,i)))==0&&any(any(cover2.*map))==0
                        possible2_x=[possible2_x x];
                        possible2_y=[possible2_y y]; 
                    end
                end
                if size(possible2_x,2)==0%节点不可用
                    i=1;
                else%节点可用
                    index=randi(size(possible2_x));
                    chrob(i,1,1)=possible2_x(index);
                    chrob(i,2,1)=possible2_y(index);
                end
             end
          i=i+1;
        end
    end
    f1=calf(chrof);
    f2=calf(chrob);
    if f1<=f2%选择优质的路径
        chro(:,:,t)=chrof(:,:);
    else
        chro(:,:,t)=chrob(:,:);  
    end
end
    % disp("完成变异")
end