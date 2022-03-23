% Advent of Code Day 1
input = "./input-01-0.txt";
depth = textread(input);

% Part 1
inc = diff(depth) > 0;
ans_1 = sum(inc)

% Part 2
filt_depth = conv(depth, [1,1,1], 'valid');
filt_inc = diff(filt_depth) > 0;
ans_2 = sum(filt_inc)
