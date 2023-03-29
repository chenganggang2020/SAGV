function  chro =Crossover(chro)
    global map Size topindex;
    n=Size;
    Pc1=0.9;Pc2=0.6;
    %随机不同个体，n1,n2是染色体对应索引值
    n1=randi(size(chro,3));
    n2=randi(size(chro,3));
    while n1==n2||any(find(topindex==n1))~=0||any(find(topindex==n2))~=0
        n2=randi(size(chro,3));
        n1=randi(size(chro,3));
    end
    %自适应交叉概率
    Fit=calf(chro);
    Fit_=min(Fit(1,n1),Fit(1,n2));
    Fitavg=sum(Fit)/size(Fit,2);
    Fitmin=min(Fit);
    if Fit_<=Fitavg
        Pc=Pc1-((Pc1-Pc2)*(Fit_-Fitavg)/(Fitavg-Fitmin));
    else
        Pc=Pc1;
    end
    count=0;
    c=rand(1);
    if c<Pc
        disp([num2str(n1),num2str(n2)]);
        t=0;index=[];
        %计算相同节点数
        for i=2: size(chro,1)-1
            if chro(i,1,n1)==chro(i,1,n2)&&chro(i,2,n1)==chro(i,2,n2)
                count=count+1;
                index=[index,i];
            end
        end
        %交叉两个染色体
        while t<2
            %不存在相同节点
            if count==0
                % 随机一个节点n3,n3为节点索引值
                n3=randi(size(chro,1)-2)+1;
                disp(n3);
                %分别计算两条染色体n1,n2交叉后在n3和n3-1处是否连续
                cover1= calcover([chro(n3-1,1,n1),chro(n3-1,2,n1)],[chro(n3,1,n2),chro(n3,2,n2)]);
                cover2= calcover([chro(n3-1,1,n2),chro(n3-1,2,n2)],[chro(n3,1,n1),chro(n3,2,n1)]);
                %如果交叉后节点路径不通,随机生成新的节点进行替换
                if any(any(cover1.*map))~=0||any(any(cover2.*map))~=0
                    Max=(n-1)/2-abs(n3-(n+1)/2);
                    possible_x=[];
                    possible_y=[];
                    for m=-Max:Max
                        x=chro(1,1,n1)+(chro(n,1,n1)-chro(1,1,n1))*(n3-1)/(n-1)+m;
                        y=chro(1,2,n1)+(chro(n,2,n1)-chro(1,2,n1))*(n3-1)/(n-1)-m;
                        %判断两个染色体前后节点是否连续
                        cover1= calcover([chro(n3-1,1,n1),chro(n3-1,2,n1)],[x,y]);
                        cover2= calcover([chro(n3+1,1,n1),chro(n3+1,2,n1)],[x,y]);
                        cover3= calcover([chro(n3-1,1,n2),chro(n3-1,2,n2)],[x,y]);
                        cover4= calcover([chro(n3+1,1,n2),chro(n3+1,2,n2)],[x,y]);
                        t1=any(any(cover1.*map));
                        t2=any(any(cover2.*map));
                        t3=any(any(cover3.*map));
                        t4=any(any(cover4.*map));
                        if t1==0&&t2==0&&t3==0&&t4==0
                            possible_x=[possible_x x];
                            possible_y=[possible_y y]; 
                        end
                    end
                    if size(possible_x,2)>0
                        index=randi(size(possible_x));
                        chro(n3,1,n1)=possible_x(index);
                        chro(n3,1,n2)=possible_x(index);
                        chro(n3,2,n1)=possible_y(index);
                        chro(n3,2,n2)=possible_y(index);
                        %交叉两个染色体
                        for i =n3+1:size(chro,1)-1
                            temp1=chro(i,1,n1);
                            temp2=chro(i,2,n1);
                            chro(i,1,n1)=chro(i,1,n2);
                            chro(i,2,n1)=chro(i,2,n2);
                            chro(i,1,n2)=temp1;
                            chro(i,2,n2)=temp2;
                        end
                        t=t+1;
                    else
                        disp("error")
                        n1=randi(size(chro,3));
                        n2=randi(size(chro,3));
                        while n1==n2||any(find(topindex==n1))~=0||any(find(topindex==n2))~=0
                            n2=randi(size(chro,3));
                            n1=randi(size(chro,3));
                        end
                        index=[];
                        %计算相同节点数
                        for i=2: size(chro,1)-1
                            if chro(i,1,n1)==chro(i,1,n2)&&chro(i,2,n1)==chro(i,2,n2)
                                count=count+1;
                                index=[index,i];
                            end
                        end
                        continue;
                    end
                end
                %有相同节点
            elseif count>0
                %对两个染色体进行交叉
                n3=index(randi(size(index)));
                for i =n3+1:size(chro,1)-1
                    temp1=chro(i,1,n1);
                    temp2=chro(i,2,n1);
                    chro(i,1,n1)=chro(i,1,n2);
                    chro(i,2,n1)=chro(i,2,n2); 
                    chro(i,1,n2)=temp1;
                    chro(i,2,n2)=temp2;
                end
                t=t+1;
            end
        end
    end
%     for t=1:size(chro,3)
%     figure(t)
%     imshow(~map,[],'InitialMagnification','fit'),axis normal;
%     axis on xy equal;
%     axis([0.5 Size+0.5 0.5 Size+0.5]) ;
%     for i = 1 : Size
%         for j = 1 : Size
%             text(i,j,num2str((j-1)*Size+i),'FontSize',6);
%         end
%     end
%     colormap=['r','b','y','m','c','k','g'];
%     line([chro(1:n-1,1,t),chro(2:n,1,t)],[chro(1:n-1,2,t),chro(2:n,2,t)],'color',colormap(t));
%     end
%     disp("ok");
end