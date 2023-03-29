function covermat = calcover(P1,P2)
global Size;
esp=0.0000001;
covermat=zeros(Size,Size);
cover.length = [];
cover.index_x = [];
cover.index_y = [];

P1_x = P1(1)-0.5;
P1_y = P1(2)-0.5;
P2_x = P2(1)-0.5;
P2_y = P2(2)-0.5;

xmin = min(P1_x,P2_x);
xmax = max(P1_x,P2_x);
ymin = min(P1_y,P2_y);
ymax = max(P1_y,P2_y);

if (P1_x == P2_x) && (round(P1_x) == P1_x)|| (P1_y == P2_y) && (round(P1_y) == P1_y)
    return;
end

if (P1_x == P2_x) && (round(P1_x) ~= P1_x)
    SP = unique([ymin,ymax,ceil(ymin):floor(ymax)]);
    indexn = [];
    for i = 1 : size(SP,1)-1
        if sqrt((SP(i+1,1) - SP(i,1)).^2 + (SP(i+1,2) - SP(i,2)).^2) < 10000*eps(1)
            indexn = [indexn i];
        end
    end
    for s=1:size(indexn,1)
        SP(indexn(s),:) = [];
    end
    for t = 1 : size(SP,2)-1
        cover(t).length = SP(t+1)-SP(t);
        cover(t).index_x = ceil(P1_x-esp);
        cover(t).index_y = max(ceil(SP(t+1)-esp),ceil(SP(t)-esp));
    end
end

if (P1_x ~= P2_x)
    K=(P2_y-P1_y)/(P2_x-P1_x);
    B=-K*P1_x+P1_y;
    xpx = []; xpy = [];
    for i = ceil(xmin):floor(xmax)
        xpx(i-ceil(xmin)+1) = i;
        xpy(i-ceil(xmin)+1) = (K*i+B);
    end
    ypx = []; ypy = [];
    for j = ceil(ymin):floor(ymax)
        ypy(j-ceil(ymin)+1) = j;
        ypx(j-ceil(ymin)+1) = (j-B)/K;
    end

    SP = unique([P1_x,P2_x,xpx,ypx;P1_y,P2_y,xpy,ypy]','rows');
    indexn = [];
    for i = 1 : size(SP,1)-1
        if sqrt((SP(i+1,1) - SP(i,1)).^2 + (SP(i+1,2) - SP(i,2)).^2) < 10000*eps(1)
            indexn = [indexn i];
        end
    end
    for s=1:size(indexn,1)
        SP(indexn(s),:) = [];
    end
    for t = 1 : size(SP,1)-1
%         disp([num2str(SP(t,2)),' ',num2str(ceil(SP(t,2)))]);
        cover(t).length = sqrt((SP(t+1,1) - SP(t,1)).^2 + (SP(t+1,2) - SP(t,2)).^2);
        cover(t).index_x = max(ceil(SP(t+1,1)-esp),ceil(SP(t,1)-esp));
        cover(t).index_y = max(ceil(SP(t+1,2)-esp),ceil(SP(t,2)-esp));
    end
end
if size(cover,2)~=0
    for i=1 : size(cover,2)
        covermat(cover(i).index_y,cover(i).index_x)=1;
    end
end
% imshow(~covermat,[],'InitialMagnification','fit'),axis normal;
% axis on xy equal;
% axis([0.5 Size+0.5 0.5 Size+0.5]) ;
% grid minor;
% for i = 1 : Size
%     for j = 1 : Size
%         text(i,j,num2str((j-1)*Size+i),'FontSize',6);
%     end
% end
% line([P1(1),P2(1)],[P1(2),P2(2)],'color','r');
% disp("ok")
end