% Advent of Code Day 24
input = "./input-24-0.txt";
data = char(readlines(input));
prog = data(1:end-1,:);

A = str2double(string(prog((0:13)*18 + 5, 7:end)));
B = str2double(string(prog((0:13)*18 + 6, 7:end)));
C = str2double(string(prog((0:13)*18 + 16, 7:end)));

ans_1 = find_best(9:-1:1, A, B, C);
fprintf('ans_1: %s\n', sprintf('%d', ans_1));

ans_2 = find_best(1:9, A, B, C);
fprintf('ans_2: %s\n', sprintf('%d', ans_2));

function best_seq = find_best(vals, A, B, C)
  % x = rem(z,26) + B ~= INP
  % z = floor(z/A)*(25 * x + 1) + (INP + C) * x
  input = vals(:); % column vector
  best_seq = zeros(1,14);
  hist_z{1} = 0;
  for j = 1:14
    z0 = hist_z{j};
    for guess = input'
      z = z0;
      % Initialize with guess of jth number
      x = rem(z,26) + B(j) ~= guess;
      z = floor(z/A(j)).*(25*x + 1) + (guess + C(j)).*x;
      z = unique(z)';
      hist_z{j+1} = z;
      % Iterate through all end values, do any paths lead to z = 0?
      for i = j+1:14
        x = rem(z,26) + B(i) ~= input;
        z = floor(z/A(i)).*(25*x + 1) + (input + C(i)).*x;
        z = unique(z)';
      end
      if any(z == 0, 'all')
        best_seq(j) = guess;
        break
      end
    end
  end
end
