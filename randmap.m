function map=randmap(mapSize)
map_value = rand(mapSize-1,mapSize-1);
threshold = 0.3;  % 参数可调，概率值
map_value = double(map_value > threshold) * 255;
map_value = map_value  / 255; 
map = ones(mapSize,mapSize);
map(1:end-1,2:end) = map_value;
map=1-map;
end
