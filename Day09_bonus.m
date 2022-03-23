% Advent of Code Day 08
input = "./input-09-0.txt";
text = fileread(input);
hmap = textscan(text, '%1d');
n = find(text == newline, 1, 'first');
hmap = reshape(hmap{1}, n-1, []);

% Part 1
ans_1 = sum(hmap(imregionalmin(hmap, 4)) + 1)

% Part 2
cnt = sort(histcounts(bwlabel(hmap < 9, 4), 'BinMethod', 'integers'), 'descend');
ans_2 = prod(cnt(2:4))
