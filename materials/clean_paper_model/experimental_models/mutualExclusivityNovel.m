% script to do Mutual Exclusivity simulations 
% this is the novel item-controlled ME situation

clear all

addpath([pwd '/../data']);
addpath([pwd '/../helper_functions']);
addpath([pwd '/../wurwur_functions']);

%% first start out by loading the old corpus and adding on the mutual
% exclusivity experimental scenario

load corpus.mat
load world.mat
load ww_best_lex.mat

new_obj1 = 23; % DAX
new_obj2 = 24; % TOMA

new_word1 = 420; % dax
new_word2 = 421; % dax

new_sit(1).objects = [new_obj1];
new_sit(1).words = [new_word1];

new_sit(2).objects = [new_obj1 new_obj2];
new_sit(2).words = [new_word2];

%% now run the wurwur model on this
parameters.alpha = 7; % lexicon size prior parameter
parameters.gamma = .1; % probability that a word refers to an intended object.
parameters.kappa = .01; % penalty for a non-refering use of a word

corpus = addCorpusIntentCache(corpus, parameters);
new_sit = addCorpusIntentCache(new_sit, parameters); 

lex = sampleLexicon(world,parameters);
normal_lex = lex;
normal_lex.map = ww_best_lex.map;
normal_lex.num_mappings = ww_best_lex.num_mappings;

normal_lex.num_words = normal_lex.num_words + 2;
normal_lex.num_objects = normal_lex.num_objects + 2;
normal_lex.word_freq = [normal_lex.word_freq 1 1];

% create the different lexicons we evaluate
n1_lex = normal_lex;
n1_lex.map = [n1_lex.map [new_word1; new_obj1]];
n1_lex.num_mappings = n1_lex.num_mappings + 1;
n2_lex = normal_lex;
n2_lex.map = [n2_lex.map [new_word2; new_obj2]];
n2_lex.num_mappings = n2_lex.num_mappings + 1;
n1n2_lex = normal_lex;
n1n2_lex.map = [n1n2_lex.map [new_word1; new_obj1] [new_word2; new_obj2]];
n1n2_lex.num_mappings = n1n2_lex.num_mappings + 2;
n1n2flip_lex = normal_lex;
n1n2flip_lex.map = [n1n2flip_lex.map [new_word1; new_obj2] [new_word2; new_obj1]];
n1n2flip_lex.num_mappings = n1n2flip_lex.num_mappings + 2;


%% now calculate 
name = {'learn nothing','just N1','just N2','both correct','both flipped'};
lexs = {'normal_lex','n1_lex','n2_lex','n1n2_lex','n1n2flip_lex'};

fprintf('\nbayesian model results:\n');
for i = 1:length(name)
  lex = eval(lexs{i});
  [a prior ll] = scoreLexicon(lex,corpus);
  [a b new_ll] = scoreLexicon(lex,new_sit);
  post = sum(ll) + sum(new_ll) + prior;
  fprintf(['%s:\tcorpus=%2.1f\tME sit(s)=' ...
    '%2.1f\tprior=%2.1f\tpost=%2.1f\n'],...
    name{i},sum(ll),sum(new_ll),prior,sum(post));
end

%% now manipulate how strong word1 is
fprintf('\nnow evaluating correct lexicon as the first word is learned better.\n');

% add 10 copies of word 1 to a new corpus
for j = 1:10 
  n1sit(j).objects = [new_obj1];
  n1sit(j).words = [new_word1];
end
n1sit = addCorpusIntentCache(n1sit, parameters); 
  
% now run on 1:10 copies to see what happens
clear ll
lln1 = nan(10,5,10);
for i = 1:10
  
  % now evaluate
  name = {'learn nothing','just N1','just N2','both correct','both flipped'};
  lexs = {'normal_lex','n1_lex','n2_lex','n1n2_lex','n1n2flip_lex'};

  fprintf('\nbayesian model results with %d examples of n1:\n',i);
  for j = 1:length(name)
    lex = eval(lexs{j});
    [a prior(i,j) ll(i,j,:)] = scoreLexicon(lex,corpus);
    [a b lln1(i,j,1:i)] = scoreLexicon(lex,n1sit(1:i));  
    [a b lln2(i,j)] = scoreLexicon(lex,new_sit(2));
    post(i,j) = sum(ll(i,j,:)) + nansum(lln1(i,j,:)) + sum(lln2(i,j)) + prior(i,j);
    
    fprintf(['%s:\tcorpus=%2.1f\tN1 sit(s)=%2.2f\tME sit(s)=' ...
      '%2.1f\tprior=%2.1f\tpost=%2.1f\n'],...
      name{j},sum(ll(i,j,:)),sum(lln1(i,j,:)),sum(lln2(i,j)),prior(i,j),post(i,j));
  end
end

%% now plot
subplot(2,3,1)
set(gca,'FontSize',16)
plot(prior)
xlabel('instances of N1')
ylabel('log probability')
legend(name)
title('prior')

subplot(2,3,2)
set(gca,'FontSize',16)
plot(nansum(ll,3))
title('corpus likelihood')

subplot(2,3,3)
set(gca,'FontSize',16)
plot(nansum(lln1,3))
title('N1 likelihood')

subplot(2,3,4)
set(gca,'FontSize',16)
plot(nansum(lln2,3))
title('ME likelihood')

subplot(2,3,5)
set(gca,'FontSize',16)
plot(post)
title('posterior probability')




