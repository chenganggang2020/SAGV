function map=randmap(mapSize,threshold)
%map=RANDMAP(mapSize,threshold)是一个随机生成指定尺寸以及障碍物密度的地图的函数
%mapSize是地图网格数量，也就是地图大小，threshold是障碍物的密度值
map_value = rand(mapSize-1,mapSize-1);
map_value = double(map_value > threshold) * 255;
map_value = map_value  / 255; 
map = ones(mapSize,mapSize);
map(1:end-1,2:end) = map_value;
map=1-map;
end
