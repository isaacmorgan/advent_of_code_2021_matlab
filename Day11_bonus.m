% Advent of Code Day 11
input = "./input-11-0.txt";
data = textscan(fileread(input), '%1f');
data = reshape(data{1}, [10, 10]);

filter = ones(3);
filter(2,2) = 0;

energy = data;
old_flash = zeros(10);
  
hist_energy = zeros(10);
for i = 1:500
  energy = energy + 1;
  new_flash = energy > 9;
  old_flash = zeros(10);
  
  while any(new_flash, 'all')
    old_flash = old_flash | new_flash;
    energy = energy + conv2(new_flash, filter, 'same');
    new_flash = energy > 9 & ~old_flash;
  end
  
  energy(old_flash ~= 0) = 0;
  hist_energy(:,:,end+1) = energy;
end

%%
fig = figure; ax = gca(fig);
colormap('gray');
clear('F');
hist_energy(hist_energy == 0) = -10;
for i = 1:size(hist_energy, 3)
  imagesc(10 - hist_energy(:,:,i), [1,20]);
  F(i) = getframe(ax);
end

movie(F, 1, 10)
