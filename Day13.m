% Advent of Code Day 13
input = "./input-13-0.txt";
text = fileread(input);
data = textscan(text, '%d%d', 'Delimiter', ',');
dots = double([data{1}, data{2}]) + 1;
folds = regexp(text, 'fold along ([xy])=(\d+)', 'tokens');

paper = sparse(zeros(2000));
for i = 1:size(dots, 1)
  paper(dots(i,1), dots(i,2)) = 1;
end

x = 0;
y = 0;
for i = 1:numel(folds)
  n = str2double(folds{i}{2});
  switch folds{i}{1}
    case 'x'
      paper(1:n,:) = paper(1:n, :) | flipud(paper(n+2:n+n+1, :));
      paper(n+1:end,:) = 0;
      x = n;
    case 'y'
      paper(:,1:n) = paper(:,1:n) | fliplr(paper(:, n+2:n+n+1));
      paper(:,n+1:end) = 0;
      y = n;
  end
  if i == 1
    ans_1 = full(sum(paper, 'all'))
  end
end

figure; 
imshow(full(paper(1:x, 1:y))' < 1);
img = repmat(' ', x, y);
img(full(paper(1:x, 1:y)) >= 1) = '#';
img'
