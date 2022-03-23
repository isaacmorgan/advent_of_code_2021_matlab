% Advent of Code Day 5
input = "./input-05-0.txt";

fid = fopen(input);
data = textscan(fid, '%f,%f -> %f,%f', 'CollectOutput', true);
fclose(fid);
data = data{1} + 1;

m = max(data, [], 'all');
count = zeros(m);

x0 = data(:,1);
y0 = data(:,2);
x1 = data(:,3);
y1 = data(:,4);

ind_dx = x0 <= x1;
ind_dy = y0 <= y1;

dx = ones(size(ind_dx));
dy = ones(size(ind_dy));

dx(~ind_dx) = -1;
dy(~ind_dy) = -1;

% Part 1
ind_str = x0 == x1 | y0 == y1;
for i = find(ind_str)'
  count(x0(i):dx(i):x1(i), y0(i):dy(i):y1(i)) = ...
    count(x0(i):dx(i):x1(i), y0(i):dy(i):y1(i)) + 1;
end

ans_1 = sum(count >= 2, 'all')

% Part 2
for i = find(~ind_str)'
  x = x0(i):dx(i):x1(i);
  y = y0(i):dy(i):y1(i);
  for j = 1:numel(x)
    count(x(j), y(j)) = count(x(j), y(j)) + 1;
  end
end

ans_2 = sum(count >= 2, 'all')
