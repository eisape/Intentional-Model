% script to do comparison of best lexicons on their inferred intentions

clear all;

% load state
load coded_intents.mat
load corpus.mat

% load models
load assoc_best_lex.mat
load yu_best_lex.mat
load yu_reversed_best_lex.mat
load ww_best_lex.mat
load ww_empirical_bayes_lex.mat

lexs(1) = best_a;
lexs(2) = best_ogw;
lexs(3) = best_wgo;
lexs(4) = best_mi;
lexs(5) = yu_best_lex;
lexs(6) = yu_reversed_best_lex;
lexs(7) = ww_best_lex;
lexs(8).map = emp_bayes_lex.map;
lexs(8).num_mappings = emp_bayes_lex.num_mappings;

%% compute precision/recall/F for inferred intentions

for l = 1:length(lexs)
  hits(l) = 0;
  misses(l) = 0;
  false_alarms(l) = 0;

  for i = 1:length(corpus)
    % this getIntentFromLexicon function is the same as finding the maximum
    % likelihood intent in the wurwur model (but it works for the 
    % associative model as well).
    model_intent{l}{i} = getIntentFromLexicon(corpus(i),lexs(l));
    hits(l) = hits(l) + length(intersect(model_intent{l}{i},intents{i}));
    misses(l) = misses(l) + length(setdiff(intents{i},model_intent{l}{i}));
    false_alarms(l) = false_alarms(l) + length(setdiff(model_intent{l}{i},intents{i}));
  end
end

p = hits ./ (hits + false_alarms);
r = hits ./ (hits + misses);
f = harmmean([p; r]);

disp([p' r' f']) % shows the comparison given in the paper. 