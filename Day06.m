% Advent of Code Day 6
input = "./input-06-0.txt";
data = csvread(input);

% Part 1
fish = data;
for i = 1:80
  fish = fish - 1;
  n = sum(fish == -1);
  fish(fish == -1) = 6;
  fish = [fish, 8*ones(1,n)];
end

ans_1 = numel(fish);
fprintf('ans_1: %d\n', ans_1);

% Part 2
fish = histcounts(data, 0:9);

for i = 1:256
  fish = circshift(fish, -1);
  fish(7) = fish(7) + fish(end);
end

ans_2 = sum(fish);
fprintf('ans_2: %d\n', ans_2);
