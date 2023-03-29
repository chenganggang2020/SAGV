function children=select(chro)
global M topindex;
GEN=0;t=1;T0=5000;q=0.9;
while t<=M
    n1=randi(size(chro,3));
    n2=randi(size(chro,3));
    T=T0*q^GEN;
    while n1==n2||any(find(topindex==n1))~=0||any(find(topindex==n2))~=0
        n2=randi(size(chro,3));
        n1=randi(size(chro,3));
    end
    child1_f=calf(chro(:,:,n1));
    child2_f=calf(chro(:,:,n2));
    if child1_f<child2_f
        children(:,:,t)=chro(:,:,n1);
        t=t+1;
        if rand(1)<exp((child1_f-child2_f)/T)
            children(:,:,t)=chro(:,:,n2);
            t=t+1;
        end
    else
        children(:,:,t)=chro(:,:,n2);
        t=t+1;
        if rand(1)<exp((child2_f-child1_f)/T)
            children(:,:,t)=chro(:,:,n1);
            t=t+1;
        end
    end
    GEN=GEN+1;
end 