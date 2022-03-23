% Advent of Code Day 4
input = "./input-04-0.txt";

fid = fopen(input);
board = sscanf(fgetl(fid), '%i,');
cards = fscanf(fid, '%f', [5,500]);
fclose(fid);

cards = reshape(cards, 5, 5, []);
cards = permute(cards, [3, 1, 2]);

% Part 1
stamps = zeros(size(cards));

for ball = board'
  stamps(cards == ball) = 1;
  
  results = any(sum(stamps, 2) == size(stamps, 2), 3) ...
    | any(sum(stamps, 3) == size(stamps, 3), 2);
  if any(results)
    winner = find(results);
    bingo = ball * sum(cards(winner, :, :).*~stamps(winner, :, :), 'all');
    break;
  end
end

ans_1 = bingo

% Part 2
stamps = zeros(size(cards));
for ball = board'
  stamps(cards == ball) = 1;

  results = any(sum(stamps, 2) == size(stamps, 2), 3) ...
    | any(sum(stamps, 3) == size(stamps, 3), 2);
  
  if all(results)
    break
  end
  
  stamps(results,:,:) = [];
  cards(results,:,:) = [];
end

bingo = ball * sum(cards.*~stamps, 'all');
ans_2 = bingo
