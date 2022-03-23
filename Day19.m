% Advent of Code Day 19
input = "./input-19-0.txt";
data = readmatrix(input);

% Parse input
scan_ind = find(isnan(data(:,1)));
scan_ind = [0; scan_ind; size(data,1) + 1];
n = numel(scan_ind)-1;
scans = {};
for i = 1:n
  i0 = scan_ind(i) + 1;
  i1 = scan_ind(i+1) - 1;
  scans{i,1} = data(i0:i1, :);
end

% Store distances between every pair of points in each scan
dscan = {};
for i = 1:n
  a = scans{i,1};
  d = a - permute(a, [3,2,1]);
  dscan{i} = triu(squeeze(sum(d.^2, 2)), 1);
end

% Determine which pairs have overlap between scans
% Store transformation matrix between them
match_map = zeros(n);
tmat = {};
for i = 1:n
  for j = i+1:n
    [is_match, ia, ib] = scan_match(dscan{i}, dscan{j});
    if is_match
      match_map(i,j) = 1;
      match_map(j,i) = 1;
      
      cnt = zeros(max(ia,[],'all'), max(ib,[],'all'));
      for ii = 1:size(ia,1)
        cnt(ia(ii,1),ib(ii,:)) = cnt(ia(ii,1),ib(ii,:)) + 1;
        cnt(ia(ii,2),ib(ii,:)) = cnt(ia(ii,2),ib(ii,:)) + 1;
      end
      
      [cnt_a, loc_b] = max(cnt, [], 2);
      ia = find(cnt_a > 0);
      ib = loc_b(cnt_a > 0);
      
      a = scans{i}(ia,:);
      b = scans{j}(ib,:);
      
      a(:,end+1) = 1;
      b(:,end+1) = 1;
      x = b\a;
      
      tmat{j,i} = x;
      tmat{i,j} = inv(x);
    end
  end
end

% For each scan with overlap of the accumulated scans, transform points to scan0
% reference frame.
% Store transforms from scan x to scan 0
% Store sensor locations
done = zeros(n,1);
scans_r0 = {};
sensors = {};

scans_r0{1} = scans{1};
sensors{1} = [0,0,0];
done(1) = 1;

tmat{1,1} = [1 0 0; 0 1 0; 0 0 1; 0 0 0];

while ~all(done)
  for j = find(any(match_map(done==1,:), 1) & ~done')
    i = find(match_map(:,j) & done,1);
    a = scans{i};
    b = scans{j};
    x = tmat{j,i}*tmat{i,1};
    tmat{j,1} = x;
    scans_r0{j} = [b, ones(size(b,1),1)]*x;
    sensors{j} = x(4,1:3);
    done(j) = 1;
  end
end

scans_final = vertcat(scans_r0{:});
ans_1 = size(unique(round(scans_final), 'rows'), 1)

sensors = round(vertcat(sensors{:}));
ans_2 = max(sum(abs(sensors - permute(sensors, [3,2,1])), 2), [], 'all')

function [is_match, ia, ib] = scan_match(a, b)
  [ind_a, loc_b] = ismember(a, b);
  [ra,ca] = ind2sub(size(a), find(triu(ind_a, 1)));
  [rb,cb] = ind2sub(size(b), loc_b(triu(loc_b, 1) > 0));
  
  ia = [ra, ca];
  ib = [rb, cb];
  is_match = size(ia,1) >= 66;
end
