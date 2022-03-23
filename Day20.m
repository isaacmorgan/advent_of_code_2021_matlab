% Advent of Code Day 20
input = "./input-20-0.txt";
data = fileread(input);
data = split(data);
alg = data{1};
map = char(data(2:end-1));

alg = alg == '#';
map = map == '#';

% Part 1
for i = 1:2
  map = step(map, alg, i);
end

ans_1 = sum(map, 'all')

% Part 2
for i = 3:50
  map = step(map, alg, i);
end

ans_2 = sum(map, 'all')

function next = step(map, alg, i)
  pow2 = permute(2.^(8:-1:0), [1,3,2]);
  if mod(i,2) == 1
    map = padarray(map, [2,2], 0);
  else
    map = padarray(map, [2,2], alg(1));
  end
    
  n = size(map,1) - 2;
  next = zeros([n,n,9]);
  for j = 1:3
    for k = 1:3
      next(:,:,(j-1)*3+k) = map(j:end+j-3, k:end+k-3);
    end
  end
  
  next = next .* pow2;
  next = sum(next, 3);
  next = alg(next + 1);
end
