% Advent of Code Day 15
input = "./input-15-0.txt";
data = split(fileread(input));
data = vertcat(data{:}) - '0';

% Part 1
ans_1 = shortest_path(data)

% Part 2
data2 = [data, 1 + data, 2 + data, 3 + data, 4 + data];
data2 = [data2; 1 + data2; 2 + data2; 3 + data2; 4 + data2];
data2 = mod(data2 - 1, 9) + 1;

ans_2 = shortest_path(data2)

function ans = shortest_path(scan)
  [sx, sy] = size(scan);
  
  [iy, ix] = meshgrid(1:sx, 1:sy);
  ix = ix(:) + [-1, 1, 0, 0];
  iy = iy(:) + [0, 0, -1, 1];
  ind = ix >= 1 & ix <= sx & iy >= 1 & iy <= sy;
  
  start = (iy(:) - 1) * sx + ix(:);
  dest = repmat((1:sx*sy)', 4, 1);
  weight = repmat(scan(:), 4, 1);
  
  graph = digraph(sparse(start(ind), dest(ind), weight(ind)));
  ans = sum(scan(shortestpath(graph, 1, sx*sy))) - scan(1,1);
end
