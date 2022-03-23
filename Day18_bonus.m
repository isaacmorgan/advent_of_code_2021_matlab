% Advent of Code Day 18
input = "./input-18-0.txt";
data = split(fileread(input));
data = data(1:end-1);
data = cellfun(@sf_parse, data, 'UniformOutput', false);

% Part 1
x = data{1};
for i = 2:numel(data)
  x = sf_add(x, data{i});
  x = sf_reduce(x);
end

ans_1 = sf_mag(x)

% Part 2
max_mag = 0;
for i = 1:numel(data)
  for j = 1:numel(data)
    x = sf_add(data{i}, data{j});
    x = sf_reduce(x);
    max_mag = max(sf_mag(x), max_mag);
  end
end

ans_2 = max_mag

function res = sf_parse(str)
  depth = (str == '[') - ([0, str(1:end-1) == ']']);
  depth = cumsum(depth);
  val = str - '0';
  res = [val; depth];
  res = res(:, val >= 0 & val <= 9);
end

function res = sf_add(a, b)
  res = [a,b] + [0;1];
end

function x = sf_reduce(x)
  splt = true;
  while(splt)
    x = sf_explode(x);
    [x, splt] = sf_split(x);
  end
end

function [x] = sf_explode(x)
  while any(x(2,:) >= 5)
    i = find(x(2,:) >= 5, 1);
    if i > 1
      x(1,i-1) = x(1,i-1) + x(1,i);
    end
    if i + 1 < size(x,2)
      x(1,i+2) = x(1,i+2) + x(1,i+1);
    end
    x(:,i) = [0;4];
    x(:,i+1) = [];
  end
end

function [x, splt] = sf_split(x)
  i = find(x(1,:) >= 10, 1);
  
  if isempty(i)
    splt = false;
  else
    splt = true;
    v = x(1,i);
    depth = x(2,i) + 1;
    c = [floor(v/2) ceil(v/2); depth, depth];
    x = [x(:,1:i-1), c, x(:,i+1:end)];
  end
end

function mag = sf_mag(x)
  while any(x(2,:) > 0)
    depth = max(x(2,:));
    ind = find(x(2,:) == depth);
    mag = 3 * x(1,ind(1:2:end)) + 2 * x(1,ind(2:2:end));
    x(:, ind(1:2:end)) = [mag; depth - 1 + zeros(size(mag))];
    x(2, ind(2:2:end)) = 0;
  end
  mag = x(1,1);
end
