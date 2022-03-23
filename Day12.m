% Advent of Code Day 12
input = "./input-12-0.txt";
data = textscan(fileread(input), '%s%s', 'Delimiter', '-');

% Represent caves by numbers
% 1: start
% 2: end
% low: small caves
% high: large caves
caves = unique([data{1}; data{2}]);
cave_num = zeros(size(caves));
cave_num(strcmp(caves, 'start')) = 1;
cave_num(strcmp(caves, 'end')) = 2;
ind_big = strcmp(upper(caves), caves);
cave_num(cave_num == 0 & ~ind_big) = 3:sum(~ind_big);
i_big = sum(~ind_big) + 1;
cave_num(ind_big) = i_big:numel(caves);

n_c = numel(caves);
n_v = 2^(i_big-3);

% Create matrix describing valid cave transitions
map = zeros(n_c);
for i = 1:numel(data{1})
  a = cave_num(strcmp(caves, data{1}{i}));
  b = cave_num(strcmp(caves, data{2}{i}));
  map(a,b) = 1;
  map(b,a) = 1;
end
map(:,1) = 0;
map(2,:) = 0;
map(2,2) = 1;

%% Part 1
% Create a state transition matrix for traversing the caves
% State: current cave, visited small caves

% Precomupte the mapping from (current cave, visited small caves) -> state index
calc_ind = (0:n_c-1)'*n_v + (0:n_v-1) + 1;

% Store transition matrix as sparse values
tmat_vals = zeros(n_c*n_c*n_v, 2);
m = 0;

for i = 1:n_c
  for j = 1:n_v
    ind_from = calc_ind(i,j);
    for k = 1:n_c
      if map(i, k) == 0
        % Ignore cases where caves are not connected
        continue
      end
      if k >= i_big
        % If going to a big cave, visited small cave state is unchanged
        ind_to = calc_ind(k, j);
      elseif k < 3
        % If going to end (or start), set visited state to default value of 1
        ind_to = calc_ind(k, 1);
      elseif mod((j-1)/2^(k-3), 2) < 1
        % If destination cave is small and is not in the visited cave state,
        % update the visited cave state
        v = j + 2^(k-3);
        ind_to = calc_ind(k, v);
      else
        % Otherwise, do nothing
        continue
      end
      m = m + 1;
      tmat_vals(m,1) = ind_from;
      tmat_vals(m,2) = ind_to;
    end
  end
end

tmat = sparse(tmat_vals(1:m,1), tmat_vals(1:m,2), ones(m,1), n_c*n_v, n_c*n_v);

state = zeros(1, size(tmat, 1));
prev = state;
state(1,1) = 1;
while ~all(state == prev)
  prev = state;
  state = state*tmat;
end

ans_1 = sum(next)

%% Part 2
% Create a state transition matrix for traversing the caves
% State: current cave, visited small caves

% Precomupte the mapping from (current cave, visited small caves, visited freebie) -> state index
calc_ind = [];
calc_ind(:,:,1) = (0:n_c-1)'*n_v + (0:n_v-1) + 1;
calc_ind(:,:,2) = n_c*n_v + (0:n_c-1)'*n_v + (0:n_v-1) + 1;

% Store transition matrix as sparse values
tmat_vals = zeros(2*n_c*n_c*n_v, 2);
m = 0;
for i = 1:n_c
  for j = 1:n_v
    for b = 1:2
      ind_from = calc_ind(i, j, b);
      for k = 1:n_c
        if map(i, k) == 0
          % Ignore cases where caves are not connected
          continue
        end
        if k >= i_big
          % If going to a big cave, visited small cave state is unchanged
          ind_to = calc_ind(k, j, b);
        elseif k < 3
          % If going to end (or start), set visited state to default value of 1
          ind_to = calc_ind(k, 1, 1);
        elseif mod((j-1)/2^(k-3), 2) < 1
          % If destination cave is small and is not in the visited cave state,
          % update the visited cave state
          v = j + 2^(k-3);
          ind_to = calc_ind(k, v, b);
        elseif b == 1
          % If the freebie revisit has not been used yet, use it
          ind_to = calc_ind(k, j, 1+1);
        else
          % Otherwise, do nothing
          continue;
        end
        m = m + 1;
        tmat_vals(m,1) = ind_from;
        tmat_vals(m,2) = ind_to;
      end
    end
  end
end

tmat = sparse(tmat_vals(1:m,1), tmat_vals(1:m,2), ones(m,1), 2*n_c*n_v, 2*n_c*n_v);

state = zeros(1, size(tmat, 1));
prev = state;
state(1,1) = 1;
while ~all(state == prev)
  prev = state;
  state = state*tmat;
end

ans_2 = sum(state)
