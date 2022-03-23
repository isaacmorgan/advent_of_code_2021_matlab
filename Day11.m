% Advent of Code Day 11
input = "./input-11-0.txt";
data = textscan(fileread(input), '%1f');
data = reshape(data{1}, [10, 10]);

filter = ones(3);
filter(2,2) = 0;

% Part 1
energy = data;
cnt = zeros(1,100);

for i = 1:100
  energy = energy + 1;
  new_flash = energy > 9;
  old_flash = zeros(10);
  
  while any(new_flash, 'all')
    old_flash = old_flash | new_flash;
    energy = energy + conv2(new_flash, filter, 'same');
    new_flash = energy > 9 & ~old_flash;
  end
  
  energy(old_flash ~= 0) = 0;
  cnt(i) = sum(old_flash, 'all');
end

ans_1 = sum(cnt)

% Part 2
energy = data;
old_flash = zeros(10);
  
i = 0;
while ~all(old_flash, 'all')
  i = i + 1;
  
  energy = energy + 1;
  new_flash = energy > 9;
  old_flash = zeros(10);
  
  while any(new_flash, 'all')
    old_flash = old_flash | new_flash;
    energy = energy + conv2(new_flash, filter, 'same');
    new_flash = energy > 9 & ~old_flash;
  end
  
  energy(old_flash ~= 0) = 0;
end

ans_2 = i
