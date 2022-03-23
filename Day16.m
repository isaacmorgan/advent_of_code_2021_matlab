% Advent of Code Day 16
input = "./input-16-0.txt";
data = textscan(fileread(input), '%1x');
data = fliplr(cell2mat(arrayfun(@(x) dec2binvec(x, 4), double(data{:}), 'UniformOutput', false)))';

% Part 1

i = 1;
values = [];
while any(data(i:end) ~= 0)
  % scan packets
  v = binvec2dec(data(i+2:-1:i));
  id = binvec2dec(data(i+5:-1:i+3));
  i = i + 6;
  switch id
    case 4
      while data(i) == 1
        i = i + 5;
      end
      i = i + 5;
    otherwise
      if data(i) == 1
        i = i + 1 + 11;
      else
        i = i + 1 + 15;
      end
  end
  values(end+1) = v;
end

ans_1 = sum(values);
fprintf('ans_1: %.0f\n', ans_1);

% Part 2

ans_2 = decode_packet(data);
fprintf('ans_2: %.0f\n', ans_2);

function [value, tail] = decode_packet(data)
  % scan next packet
  value = binvec2dec(data(3:-1:1));
  id = binvec2dec(data(6:-1:4));
  
  tail = data(7:end);
  switch id
    case 0
      [value_array, tail] = collect_subpackets(tail);
      value = sum(value_array);
    case 1
      [value_array, tail] = collect_subpackets(tail);
      value = prod(value_array);
    case 2
      [value_array, tail] = collect_subpackets(tail);
      value = min(value_array);
    case 3
      [value_array, tail] = collect_subpackets(tail);
      value = max(value_array);
    case 4
      [value, tail] = decode_literal(tail);
    case 5
      [value_array, tail] = collect_subpackets(tail);
      value = value_array(1) > value_array(2);
    case 6
      [value_array, tail] = collect_subpackets(tail);
      value = value_array(1) < value_array(2);
    case 7
      [value_array, tail] = collect_subpackets(tail);
      value = value_array(1) == value_array(2);
  end
end

function [value, tail] = decode_literal(data)
  n = find(data(1:5:end) == 0, 1, 'first');
  binvec = data(1:5*n);
  tail = data(5*n+1:end);
  binvec(1:5:end) = [];
  value = binvec2dec(fliplr(binvec));
end

function [value_array, tail] = collect_subpackets(data)
  length_type = data(1);
  value_array = [];
  if length_type == 0
    value = binvec2dec(fliplr(data(2:16)));
    tail = data(17:17+value-1);
    while any(tail ~= 0)
      [value_array(end+1), tail] = decode_packet(tail);
    end
    tail = data(17+value:end);
  else
    value = binvec2dec(data(12:-1:2));
    tail = data(13:end);
    for i = 1:value
      [value_array(i), tail] = decode_packet(tail);
    end
  end
end
