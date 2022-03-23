% Advent of Code Day 18
input = "./input-18-0.txt";
data = split(fileread(input));
data = data(1:end-1);
data = cellfun(@sf_parse, data, 'UniformOutput', false);

x = data{1};
for i = 2:numel(data)
  x = sf_add(x, data{i});
  x = sf_reduce(x);
end

ans_1 = sf_mag(x)

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
  ind = (str == '[') - ([0, str(1:end-1) == ']']);
  ind = cumsum(ind);
  val = str - '0';
  val(val < 0 | val > 9) = -1;
  res = [val; ind];
end

function x = sf_reduce(x)
    expl = true;
    splt = true;
    while(expl || splt)
      [x, expl] = sf_explode(x);
      if expl
        continue
      end
      [x, splt] = sf_split(x);
    end
end

function res = sf_add(a, b)
  res = [[-1; 0] a [-1; 0] b [-1; 0]];
  res(2,:) = res(2,:) + 1;
end

function str = sf_str(x)
  str = char(x(1,:) + '0');
  str([1, diff(x(2,:))] == 1) = '[';
  str([diff(x(2,:)), -1] == -1) = ']';
  str(str == '0'-1) = ',';
end

function [x, did_explode] = sf_explode(x)
  i = find(x(2,:) >= 5 & [0, diff(x(2,:)) > 0], 1);
  if isempty(i)
    did_explode = false;
    return
  end
  did_explode = true;
  a = x(1,i+1);
  b = x(1,i+3);
  for j = i:-1:1
    if x(1,j) >= 0
      x(1,j) = x(1,j) + a;
      break;
    end
  end
  for j = i+5:size(x,2)
    if x(1,j) >= 0
      x(1,j) = x(1,j) + b;
      break;
    end
  end
  x = [x(:, 1:i-1), [0; 4], x(:, i+5:end)];
end

function [x, did_split] = sf_split(x)
  i = find(x(1,:) >= 10, 1);
  if isempty(i)
    did_split = false;
    return
  end
  did_split = true;
  l = x(:,1:i-1);
  r = x(:,i+1:size(x,2));
  v = x(1,i);
  ind = x(2,i) + 1;
  c = [[-1, floor(v/2), -1, ceil(v/2), -1]; ...
    ind + [0 0 0 0 0]];
  x = [l, c, r];
end

function mag = sf_mag(x)
  i = x(2,1);
  ind = find(x(2,:) == i);
  if numel(ind) == 3
    a = x(:, ind(1)+1:ind(2)-1);
    b = x(:, ind(2)+1:ind(3)-1);
    a = sf_mag(a);
    b = sf_mag(b);
  else
    a = x(1,2);
    b = x(1,4);
  end
  mag = 3 * a + 2 * b;
end
