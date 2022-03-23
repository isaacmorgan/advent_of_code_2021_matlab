% Advent of Code Day 3
input = "./input-03-0.txt";
report = fileread(input);

n = regexp(report, newline, 'once');
report = reshape(report, n, [])';
report(:, end) = [];

% Part 1
cnt = sum(report == '1');
n_row = size(report, 1);

bin = int2str(cnt > n_row/2);
bin(bin == ' ') = [];

g = bin2dec(bin);
e = 2^numel(bin) - 1 - g;

pwr = g*e;
ans_1 = pwr

% Part 2
rep_ox = report;
rep_co2 = report;

for i = 1:size(report, 2)
  n_row_ox = size(rep_ox, 1);
  
  if n_row_ox == 1; break; end
  
  cnt_ox = sum(rep_ox(:,i) == '1');
  
  mcv_ox = int2str(cnt_ox >= n_row_ox/2);

  ind_ox = rep_ox(:,i) == mcv_ox;
  rep_ox = rep_ox(ind_ox,:);
end

for i = 1:size(report, 2)
  n_row_co2 = size(rep_co2, 1);
  
  if n_row_co2 == 1; break; end
  
  cnt_co2 = sum(rep_co2(:,i) == '1');
  
  lcv_co2 = int2str(cnt_co2 < n_row_co2/2);
  
  ind_co2 = rep_co2(:,i) == lcv_co2;
  rep_co2 = rep_co2(ind_co2,:);
end

pwr_ox = bin2dec(rep_ox);
pwr_co2 = bin2dec(rep_co2);
pwr_life =  pwr_ox * pwr_co2;

ans_2 = pwr_life
