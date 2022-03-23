% Advent of Code Day 14
input = "./input-14-0.txt";
text = fileread(input);
lines = split(text);
poly = lines{1};

pairs = unique(lines(2:3:end-2));
phead = [pairs{:}];
phead = phead(1:2:end);

u = unique(text);
u = u(u >= 'A');

tmat = sparse(numel(pairs), numel(pairs));
for i = 2:3:numel(lines)-2
  ind_in = strcmp(pairs, lines{i});
  a = [lines{i}(1) lines{i+2}];
  b = [lines{i+2} lines{i}(2)];
  ind_out = strcmp(pairs, a) + strcmp(pairs, b);
  tmat(ind_in, :) = ind_out;
end

% Part 1
pair_count = zeros(1, numel(pairs));
for i = 1:numel(poly)-1
  pair_count = pair_count + strcmp(pairs, poly(i:i+1))';
end

for i = 1:10
  pair_count = pair_count * tmat;
end

u_cnt = zeros(size(u));
for i = 1:numel(u)
  u_cnt(i) = sum(pair_count(phead == u(i)));
end
ind_last = u == poly(end);
u_cnt(ind_last) = u_cnt(ind_last) + 1;

ans_1 = max(u_cnt) - min(u_cnt);
fprintf('ans_1: %.0f\n', ans_1);

% Part 2
pair_count = zeros(1, numel(pairs));
for i = 1:numel(poly)-1
  pair_count = pair_count + strcmp(pairs, poly(i:i+1))';
end

for i = 1:40
  pair_count = pair_count * tmat;
end

u_cnt = zeros(size(u));
for i = 1:numel(u)
  u_cnt(i) = sum(pair_count(phead == u(i)));
end
ind_last = u == poly(end);
u_cnt(ind_last) = u_cnt(ind_last) + 1;

ans_2 = max(u_cnt) - min(u_cnt);
fprintf('ans_2: %.0f\n', ans_2);
