% Advent of Code Day 21
input = "./input-21-0.txt";
data = fileread(input);
data = split(data, {':',newline});

% Part 1
pos = [str2double(data{2}), str2double(data{4})];
score = [0, 0];
d = 1;
turn = 2;
roll_cnt = 0;

while all(score < 1000)
  roll_cnt = roll_cnt + 3;
  turn = 3 - turn;
  
  move = sum([d d+1 d+2]);
  move = move - 10 * floor(move/10);
  d = d + 3;
  d = d - 100 * (d > 100);
  
  pos(turn) = pos(turn) + sum(move);
  pos(turn) = pos(turn) - 10 * (pos(turn) > 10);
  score(turn) = score(turn) + pos(turn);
end

ans_1 = min(score) * roll_cnt;
fprintf('ans_1: %.0f\n', ans_1);

% Part 2
pos = [str2double(data{2}), str2double(data{4})];
state_cube = zeros([10,10,21,21]);
state_cube(pos(1),pos(2),1,1) = 1;

x = (1:3) + (1:3)' + permute(1:3,[1,3,2]);
[d, ~, ic] = unique(x);
p = accumarray(ic, 1);
wins = [0, 0];
turn = 2;

while any(state_cube ~= 0, 'all')
  turn = 3 - turn;
  
  % Move
  next = zeros(size(state_cube));
  for j = 1:numel(p)
    next = next + p(j) * circshift(state_cube, d(j), turn);
  end
  
  % Count Wins and Increase Score
  if turn == 2
    next = permute(next, [2,1,4,3]);
  end
  
  for j = 1:10
    wins(turn) = wins(turn) + sum(next(j,:,end-j+1:end,:), 'all');
    next(j,:,1+j:end,:) = next(j,:,1:end-j,:);
    next(j,:,1:j,:) = 0;
  end
    
  if turn == 2
    next = permute(next, [2,1,4,3]);
  end
  
  state_cube = next;
end

ans_2 = max(wins);
fprintf('ans_2: %.0f\n', ans_2);
