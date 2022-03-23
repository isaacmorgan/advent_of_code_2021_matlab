% Advent of Code Day 08
input = "./input-08-0.txt";
data = textscan(fileread(input), '%s%s%s%s%s%s%s%s%s%s | %s%s%s%s');

signals = cellfun(@sort, [data{1:10}], 'UniformOutput', false);
outputs = cellfun(@sort, [data{11:14}], 'UniformOutput', false);
n = size(signals, 1);

% Part 1
% out_cnt = cellfun(@numel, outputs);
out_cnt = reshape(sum(char(outputs(:)) >= 'a', 2), size(outputs));

ans_1 = sum(out_cnt == reshape([2,3,4,7], [1,1,4]), 'all')

% Part 2
% sig_cnt = cellfun(@numel, signals);
sig_cnt = reshape(sum(char(signals(:)) >= 'a', 2), size(signals));

alph = 'abcdefg';
val = zeros(1,n);

for i = 1:n
  sig_words = signals(i,:);
  sig_mat = char(sig_words')';
  out_words = outputs(i,:);
  len = sig_cnt(i,:);
  freq = sum(alph == [sig_words{:}]');
  
  seg2alph = char(zeros(1,7));
  seg2alph(2) = alph(freq == 6);
  seg2alph(5) = alph(freq == 4);
  seg2alph(6) = alph(freq == 9);
  
  word2num = zeros(1,10) - 1;
  word2num(len == 2) = 1;
  word2num(len == 3) = 7;
  word2num(len == 4) = 4;
  word2num(len == 7) = 8;
  word2num(len == 5 & any(sig_mat == seg2alph(2))) = 5;
  word2num(len == 5 & any(sig_mat == seg2alph(5))) = 2;
  word2num(len == 5 & ~any(sig_mat == seg2alph(2)) & ~any(sig_mat == seg2alph(5))) = 3;
  word2num(len == 6 & ~any(sig_mat == seg2alph(5))) = 9;
  
  seg2alph(4) = alph(freq == 7 & any(alph == sig_words{word2num == 4}'));
  
  word2num(len == 6 & any(sig_mat == seg2alph(5)) & any(sig_mat == seg2alph(4))) = 6;
  word2num(len == 6 & any(sig_mat == seg2alph(5)) & ~any(sig_mat == seg2alph(4))) = 0;
  
  [ind, ~] = find(string(out_words) == string(sig_words)');
  val(i) = [1000,100,10,1] * word2num(ind)';
end

ans_2 = sum(val)
