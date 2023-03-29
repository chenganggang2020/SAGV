function chro =Init(map)
global Size M;
n=Size;
chro=zeros(n,2,M);
for t=1:M
    disp(["尝试",num2str(t)]);
    chro(1,1,t)=1;chro(1,2,t)=1;
    chro(n,1,t)=n;chro(n,2,t)=n;
    i=2;
    while i <=n
%         disp(["节点数",i]);
        max=(n-1)/2-abs(i-(n+1)/2);
        possible_x=[];
        possible_y=[];
        
        for m=-max:max
            temp=zeros(Size,Size,i);
            x=chro(1,1,t)+(chro(n,1,t)-chro(1,1,t))*(i-1)/(n-1)+m;
            y=chro(1,2,t)+(chro(n,2,t)-chro(1,2,t))*(i-1)/(n-1)-m;
            cover= calcover([chro(i-1,1,t),chro(i-1,2,t)],[x,y]);
            temp(:,:,i)=cover.*map;
            if temp(:,:,i)==0
                possible_x=[possible_x x];
                possible_y=[possible_y y];
            end
        end
%        disp(size(possible_x,2));
       if size(possible_x,2)==0
%            disp(["问题在",i]);
           i=2;
       else
       index=randi(size(possible_y,2));
       chro(i,1,t)=possible_x(index);
       chro(i,2,t)=possible_y(index);
       i=i+1;
       end
    end
end

end

