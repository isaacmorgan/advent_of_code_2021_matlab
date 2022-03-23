% Advent of Code Day 2
input = "./input-02-0.txt";

fid = fopen(input);
l = fscanf(fid, '%c%*s %i\n');
fclose(fid);

cmd = l(1:2:end);
val = l(2:2:end);

ind_f = cmd == 'f';
ind_d = cmd == 'd';
ind_u = cmd == 'u';

% Part 1
h = sum(val(ind_f));
d = sum(val(ind_d)) - sum(val(ind_u));

ans_1 = h * d;
fprintf('ans_1: %i\n', ans_1);

% Part 2
cum_a = val;
cum_a(ind_u) = -cum_a(ind_u);
cum_a(ind_f) = 0;

h = sum(val(ind_f));
a = cumsum(cum_a);
d = sum(a(ind_f) .* val(ind_f));

ans_2 = h * d;
fprintf('ans_2: %i\n', ans_2);
