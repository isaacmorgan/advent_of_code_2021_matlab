% Advent of Code Day 08
input = "./input-09-0.txt";
text = fileread(input);
hmap = textscan(text, '%1d');
n = find(text == newline, 1, 'first');
hmap = double(reshape(hmap{1}, n-1, []));

% Part 1
pad = padarray(hmap, [1,1], 9);
ind_min = islocalmin(pad, 1) & islocalmin(pad, 2);

ans_1 = sum(pad(ind_min) + 1)

% Part 2
basins = watershed(hmap, 4);
basins(hmap == 9) = NaN;
cnt = sort(histcounts(basins, 'BinMethod', 'integers'));

ans_2 = prod(cnt(end-3:end-1))

% Plot
figure;
p = zeros(size(basins));
for i = unique(basins)'
  p(basins == i) = sum(basins == i, 'all');
end
p(hmap == 9) = NaN;
imagesc(p);
