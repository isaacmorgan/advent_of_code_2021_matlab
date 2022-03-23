% Advent of Code Day 2
input = "./input-02-0.txt";
cmd = readtable(input);
cmd.Properties.VariableNames = {'dir', 'val'};

% Part 1
horizontal = 0;
depth = 0;

[dir, ~, row] = unique(cmd.dir);
for i = 1:numel(dir)
  s = sum(cmd.val(row == i));
  
  switch dir{i}
    case 'forward'
      horizontal = horizontal + s;
    case 'down'
      depth = depth + s;
    case 'up'
      depth = depth - s;
  end
end

ans_1 = horizontal * depth;
fprintf('ans_1: %i\n', ans_1);

% Part 2
horizontal = 0;
depth = 0;
aim = 0;

for i = 1:size(cmd, 1)
  s = cmd.val(i);
  
  switch cmd.dir{i}
    case 'forward'
      horizontal = horizontal + s;
      depth = depth + aim*s;
    case 'down'
      aim = aim + s;
    case 'up'
      aim = aim - s;
  end
end

ans_2 = horizontal * depth;
fprintf('ans_2: %i\n', ans_2);
