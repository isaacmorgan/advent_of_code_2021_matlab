% Advent of Code Day 7
input = "./input-07-0.txt";
data = csvread(input);

i = min(data):max(data);
dx = abs(data' - i);

% Part 1
fuel = sum(dx);
ans_1 = min(fuel)

% Part 2
fuel = 0.5 * sum(dx.^2 + dx);
ans_2 = min(fuel)
