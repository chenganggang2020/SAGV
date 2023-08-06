function children=select(chro,topindex)
% children=SELECT(chro,topindex)是一个根据模拟退火算法选择染色体的函数
% children是选择后的染色体，topindex是精英染色体索引值
m=1;T0=5000;q=0.9;
GEN=0;
Fit=calf(chro);
children=zeros(size(chro));
while m<=size(chro,3)
    n1=randi(size(chro,3));
    n2=randi(size(chro,3));
    T=T0*q^GEN;
    while n1==n2||any(find(topindex==n1))~=0||any(find(topindex==n2))~=0
        n2=randi(size(chro,3));
        n1=randi(size(chro,3));
    end
    if Fit(1,n1)>Fit(1,n2)
        children(:,:,m)=chro(:,:,n2);
        m=m+1;
        if rand(1)<exp((Fit(1,n2)-Fit(1,n1))/T)
            children(:,:,m)=chro(:,:,n1);
            m=m+1;
        end
    else
        children(:,:,m)=chro(:,:,n1);
        m=m+1;
        if rand(1)<exp((Fit(1,n1)-Fit(1,n2))/T)
            children(:,:,m)=chro(:,:,n2);
            m=m+1;
        end
    end
    GEN=GEN+1;
end 