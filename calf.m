function f=calf(chro)
M=size(chro,3);
f=zeros(1,M);
a1=0.5;a2=0.3;a3=0.2;
for t=1:M
    f1=0.0000;f2=0.0000;f3=0.0000;angle=0.0000;
%     disp(["大小",size(chro,1)]);
    for i =1:size(chro,1)-1
        tem=sqrt(double((chro(i,1,t)-chro(i+1,1,t)))^2+(double(chro(i,2,t)-chro(i+1,2,t)))^2);
%         disp(["结果",num2str(tem)]);
        f1=f1+tem;
    end
    for i =1:size(chro,2)-2
        x21=double(chro(i+1,1,t)-chro(i,1,t));
        y21=double(chro(i+1,2,t)-chro(i,2,t));
        x32=double(chro(i+2,1,t)-chro(i+1,1,t));
        y32=double(chro(i+2,2,t)-chro(i+1,2,t));
        a=sqrt(x21^2+y21^2);
        b=sqrt(x32^2+y32^2);
        angle=abs(acos((x21*x32+y21*y32)/(a*b)));
        f2=f2+angle;
        if angle~=0
            f3=f3+1;
        end
    end
    f(1,t)=a1*f1+a2*f2*pi/180+a3*f3;
end
% disp("ok")
end