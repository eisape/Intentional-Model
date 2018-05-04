% compute the F score (harmonic mean of precision of recall) to score
% lexicons relative to the gold standard

function [precision, recall, f] = computeLexiconF(target_lex,gold_lex)

% compute precision, what portion of the target lex is composed of gold
% pairings
p_count = 0;
for i = 1:target_lex.num_mappings
  this_pair = target_lex.map(:,i);
  
  if any(gold_lex.map(2,(gold_lex.map(1,:)==this_pair(1)))==this_pair(2));
    p_count = p_count + 1;
  end
end

% special case: no mappings
if target_lex.num_mappings == 0
  precision = 0;
else
  precision = p_count / target_lex.num_mappings;
end

% compute recall, how many of the total gold pairings are in the target lex
recall = p_count / gold_lex.num_mappings; 

% now F is just the harmonic mean
f = harmmean([precision recall]);
