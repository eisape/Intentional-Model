% normalize the associative statistic matrix (mi/cp/association freq) 
% then slide the threshold to see what gives you the best performance

function [p,r,f,best] = consolidateMatrix(m,good_lex,world)

m = m./max(max(m));

% for parameter values from .01 to .99
for i = 1:99
  thresh_lex(i) = makeThresholdLex(m,i/100);
  [p(i),r(i),f(i)] = computeLexiconF(thresh_lex(i),good_lex);
end

% now find the best one
max_val = find(f==max(f),1);
best = thresh_lex(max_val);

% helper function to do thresholding

function thresh_lex = makeThresholdLex(m,thresh)

[i,j] = find(m>thresh);
thresh_lex.map = [i';j'];
thresh_lex.num_mappings = size(thresh_lex.map,2);
