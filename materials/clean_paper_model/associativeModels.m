% baseline models for wurwur model
%
% described in "Using speakers' referential intentions to model early
% cross-situational word learning." Psych Science (submitted).

clear all
addpath([pwd '/data']);
addpath([pwd '/helper_functions']);
addpath([pwd '/baseline_functions']);
load corpus.mat
load world.mat
load gold_standard.mat

%% compute association probabilities, o by w

assocs = zeros(world.num_words,world.num_objects);

for i = 1:length(corpus)
  for j = 1:length(corpus(i).objects)
    for k = 1:length(corpus(i).words)
      o = corpus(i).objects(j);
      w = corpus(i).words(k);
      assocs(w,o) = assocs(w,o) + 1;
    end
  end
end

[assoc_p,assoc_r,assoc_f,best_a] = consolidateMatrix(assocs,gold_standard,world);

%% do conditional probabilities, first p(object | word)

p_object_given_word = assocs ./ repmat(sum(assocs,2),1,length(world.objects_key));
[pogw_p,pogw_r,pogw_f,best_ogw] = consolidateMatrix(p_object_given_word,gold_standard,world);

%% now p(word | object)

p_word_given_object = assocs ./ repmat(sum(assocs),length(world.words_key),1);
[pwgo_p,pwgo_r,pwgo_f,best_wgo] = consolidateMatrix(p_word_given_object,gold_standard,world);

%% now do mutual information

p_word = (world.words_freq ./ sum(world.words_freq))';
p_object = world.objects_freq ./ sum(world.objects_freq);
p_word_and_object = assocs ./ sum(sum(assocs));

mi = p_word_and_object ./ (repmat(p_word,1,length(world.objects_key)) ...
  .* repmat(p_object,length(world.words_key),1));
[mi_p,mi_r,mi_f,best_mi] = consolidateMatrix(mi,gold_standard,world);

%% show the results figures for each model

figure(1);
evalLexicon(best_a,gold_standard,world)
figure(2);
evalLexicon(best_ogw,gold_standard,world)
figure(3);
evalLexicon(best_wgo,gold_standard,world)
figure(4);
evalLexicon(best_mi,gold_standard,world)