% this function compares the best lexicons from each of the models we
% evaluated on their guesses about the speaker's referential intent in each
% situation of the corpus. 

%% first part just loads up all of the best lexicons found by the models

clear all
load corpus.mat
load world.mat
load gold_standard.mat

load assoc_best_lex.mat
load yu_best_lex.mat
load yu_reversed_best_lex.mat
load ww_best_lex.mat

load intents.mat

lexs(1) = best_a;
lexs(2) = best_ogw;
lexs(3) = best_wgo;
lexs(4) = best_mi;
lexs(5) = yu_best_lex;
lexs(6) = yu_reversed_best_lex;
lexs(7) = ww_best_lex;

parameters.gamma = best_gamma;
corpus = addCorpusIntentCache(corpus, parameters);


%% the second part computes precision/recall/f-score for each of these
% lexicons

for l = 1:length(lexs)
  hits(l) = 0;
  misses(l) = 0;
  false_alarms(l) = 0;

  for i = 1:length(corpus)
    model_intent{l}{i} = getIntent(corpus(i),lexs(l));
    hits(l) = hits(l) + length(intersect(model_intent{l}{i},intents{i}));
    misses(l) = misses(l) + length(setdiff(intents{i},model_intent{l}{i}));
    false_alarms(l) = false_alarms(l) + length(setdiff(model_intent{l}{i},intents{i}));
  end
end

p = hits ./ (hits + false_alarms);
r = hits ./ (hits + misses);
f = harmmean([p; r]);

% print them all in nice columnar format
disp([p' r' f'])
