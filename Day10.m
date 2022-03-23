% Advent of Code Day 08
input = "./input-10-0.txt";
text = fileread(input);

% Part 1
% Remove all valid chunks
n = 0;
while n ~= numel(text)
  n = numel(text);
  text = regexprep(text, '<>|\[\]|{}|\(\)', '');
end

% Put data into char matrix
text = char(split(text));
text(end,:) = [];

% Replace chars with value
val = text == permute(')]}>', [1 3 2]);
val = sum(val.*permute([3, 57, 1197, 25137], [1 3 2]), 3);

% Find first non-zero value in each row
[~, ind] = max(val ~= 0, [], 2);
val = val(sub2ind(size(val), 1:size(val,1), ind'));

ans_1 = sum(val);
fprintf('ans_1: %.0f\n', ans_1);

% Part 2
% Remove corrupted lines
text = text(val == 0,:);
text = text(:, sum(text ~= ' ') ~= 0);

% Replace chars with value
val = text == permute('([{<', [1 3 2]);
val = sum(val.*permute([1,2,3,4], [1 3 2]), 3);

% Count values in each row and calculate 5.^n for each
n = sum(text ~= ' ', 2);
ex = n - (1:size(text,2));
val = sum(val.*5.^ex, 2);

ans_2 = median(val);
fprintf('ans_2: %.0f\n', ans_2);
