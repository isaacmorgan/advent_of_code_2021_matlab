% Advent of Code Day 22
input = "./input-22-0.txt";
data = fileread(input);
data(data == '.') = ' ';
data = textscan(data, '%s x=%d%d,y=%d%d,z=%d%d');

light = strcmp(data{1}, 'on');
x = sort([data{2}, data{3}], 2);
y = sort([data{4}, data{5}], 2);
z = sort([data{6}, data{7}], 2);
cubes = [light, x, y, z];

% Part 1
n = size(cubes,1);
cube = zeros(101,101,101);
offset = 51;
for i = 1:n
  c = cubes(i,:);
  if any(c < -50 | c > 50)
    continue;
  end
  cube(offset + (c(2):c(3)), offset + (c(4):c(5)),  offset + (c(6):c(7))) = c(1);
end

ans_1 = sum(cube, 'all')

%% Part 2
cube_set = [];
for i = 1:n
  b = cubes(i,:);
  new_cubes = [];
  if b(1) == 1
    new_cubes = b;
  end
  for j = 1:size(cube_set, 1)
    a = cube_set(j,:);
    [match, c] = overlap(a,b);
    if match
      c(1) = -a(1);
      new_cubes = [new_cubes; c];
    end
  end
  cube_set = [cube_set; new_cubes];
end
%%
ans_2 = cube_prod(cube_set);
fprintf('ans_2: %.0f\n', ans_2)

function [match, c] = overlap(a, b)
  match = false;
  c = [];
  xyz0 = max([a([2,4,6]); b([2,4,6])]);
  xyz1 = min([a([3,5,7]); b([3,5,7])]);
  if all(xyz0 <= xyz1, 'all')
    match = true;
    c = [b(1) xyz0(1), xyz1(1), xyz0(2), xyz1(2), xyz0(3), xyz1(3)];
  end
end

function [cubes] = cube_split(a,b)
  xyz0 = max([a([2,4,6]); b([2,4,6])]);
  xyz1 = min([a([3,5,7]); b([3,5,7])]);
	c = [b(1) xyz0(1), xyz1(1), xyz0(2), xyz1(2), xyz0(3), xyz1(3)];
 
  a1 = a; a2 = a; a3 = a; a4 = a; a5 = c; a6 = c;
  a1(3) = c(2) - 1;
  a2(2) = c(3) + 1;
  a3(2) = c(2); a3(3) = c(3); a3(5) = c(4) - 1;
  a4(2) = c(2); a4(3) = c(3); a4(4) = c(5) + 1;
  a5(1) = a(1); a5(6) = a(6); a5(7) = c(6) - 1;
  a6(1) = a(1); a6(7) = a(7); a6(6) = c(7) + 1;
  
  cubes_a = [a1; a2; a3; a4; a5; a6];
  valid_a = cubes_a(:,2) <= cubes_a(:,3) & cubes_a(:,4) <= cubes_a(:,5) & cubes_a(:,6) <= cubes_a(:,7);
  cubes = cubes_a(valid_a,:);
end

function p = cube_prod(a)
  p = sum(double(a(:,1)) .* prod(a(:,3:2:end) - a(:,2:2:end) + 1, 2));
end

function plot_cube(ax, a)
  for i = 1:size(a,1)
    px = [a(2) a(2) a(3) a(3) a(2) a(2) a(2) a(3) a(3) a(2) a(2) a(2) a(3) a(3) a(3) a(3)];
    py = [a(5) a(4) a(4) a(5) a(5) a(5) a(4) a(4) a(5) a(5) a(4) a(4) a(4) a(4) a(5) a(5)];
    pz = [a(6) a(6) a(6) a(6) a(6) a(7) a(7) a(7) a(7) a(7) a(7) a(6) a(6) a(7) a(7) a(6)];
    plot3(ax, px, py, pz, 'o-');
  end
end
