function chro =Variation(chro)
    global map n topindex;
    Pm1=0.8;Pm2=0.005;
    %选择一个染色体
    n3=randi(size(chro,3));
    while any(find(topindex==n3))~=0
        n3=randi(size(chro,3));
    end
    
    chro1=chro(:,:,n3);
    chro2=chro(:,:,n3);
    Fit=calf(chro);
    Fit_=Fit(1,n3);
    Fitavg=sum(Fit)/size(Fit,2);
    Fitmin=min(Fit);
    if Fit_<=Fitavg
        Pm=Pm1-((Pm1-Pm2)*(Fit_-Fitavg)/(Fitavg-Fitmin));
    else
        Pm=Pm1;
    end
    %判断变异概率
    p=rand(1);
    if p<Pm
        
        num1=randi(size(chro,1));
        num2=randi(size(chro,1));
        while num1==num2
            num2=randi(size(chro,1));
        end
        n1=min(num1,num2);
        n2=max(num1,num2);
        display([num2str(n3),num2str(n1),num2str(n2)]);
        t=0;
        while t<2
            for i=2:size(chro,1)
                %r1段染色体变异
                if i<n1
                    Max=(n-1)/2-abs(i-(n+1)/2);
                    possible1_x=[];
                    possible1_y=[];
                    for m=-Max:Max
                        x=chro(1,1,n3)+(chro(n,1,n3)-chro(1,1,n3))*(i-1)/(n-1)+m;
                        y=chro(1,2,n3)+(chro(n,2,n3)-chro(1,2,n3))*(i-1)/(n-1)-m;
                        cover1= calcover([chro(i-1,1,n3),chro(i-1,2,n3)],[x,y]);
                        if i==n1-1
                            cover2= calcover([chro(i+1,1,n3),chro(i+1,2,n3)],[x,y]);
                        else
                            cover2=0;
                        end
                        if any(any(cover1.*map))==0&&any(any(cover2.*map))==0
                            possible1_x=[possible1_x x]; 
                            possible1_y=[possible1_y y]; 
                        end
                    end
                    %判断变异节点是否可用
                    if size(possible1_x,2)==0
                        i=i-1;
                        continue;
                    else
                        index=randi(size(possible1_x,2));
                        chro1(i,1,1)=possible1_x(index);
                        chro1(i,2,1)=possible1_y(index);
                        t=t+1;
                    end
                else
                    chro1(i,1,1)=chro(i,1,n3);
                    chro1(i,2,1)=chro(i,2,n3);
                end
                if i<=n2
                    chro2(i,1,1)=chro(i,1,n3);
                    chro2(i,2,1)=chro(i,2,n3);
                else
                    Max=(n-1)/2-abs(i-(n+1)/2);
                    possible2_x=[];
                    possible2_y=[];
                    for m=-Max:Max
                        x=chro(1,1,n3)+(chro(n,1,n3)-chro(1,1,n3))*(i-1)/(n-1)+m;
                        y=chro(1,2,n3)+(chro(n,2,n3)-chro(1,2,n3))*(i-1)/(n-1)-m;
                        cover1= calcover([chro(i-1,1,n3),chro(i-1,2,n3)],[x,y]);
                        if any(any(cover1.*map))==0
                            possible2_x=[possible2_x x];
                            possible2_y=[possible2_y y]; 
                        end
                    end
                    if size(possible2_x,2)==0
                        i=i-1;
                        continue;
                    else
                        index=randi(size(possible2_x));
                        chro2(i,1,1)=possible2_x(index);
                        chro2(i,2,1)=possible2_y(index);
                        t=t+1;
                    end
                end
            end
        end
    end
    f1=calf(chro1);
    f2=calf(chro2);
    if f1<=f2
        chro(:,:,n3)=chro1(:,:,1);
    else
        chro(:,:,n3)=chro2(:,:,1);
    end
end