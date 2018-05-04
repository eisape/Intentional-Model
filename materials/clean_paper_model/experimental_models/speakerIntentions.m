% script to do Baldwin (1993) simulations 

clear all

%% first start out by loading the old corpus and adding on the mutual
% exclusivity experimental scenario

load corpus.mat
load world.mat
load ww_best_lex.mat

new1 = 23; % modi
new2 = 24; % other thing
new_word = 420; % modi

new_sit(1).objects = [new1 new2];
new_sit(1).words = [new_word];

%% 
parameters.alpha = 7; % lexicon size prior parameter
parameters.gamma = .1; % probability that a word refers to an intended object.
parameters.kappa = .01; % penalty for a non-refering use of a word

corpus = addCorpusIntentCache(corpus, parameters);
new_sit = addCorpusIntentCache(new_sit, parameters); 

lex = sampleLexicon(world,parameters);
normal_lex = lex;
normal_lex.map = ww_best_lex.map;
normal_lex.num_mappings = ww_best_lex.num_mappings;

normal_lex.num_words = normal_lex.num_words + 1;
normal_lex.num_objects = normal_lex.num_objects + 2;
normal_lex.word_freq = [normal_lex.word_freq 1];

% create the different lexicons we evaluate
corr_lex = normal_lex;
corr_lex.map = [corr_lex.map [new_word; new1]];
corr_lex.num_mappings = corr_lex.num_mappings + 1;

other_lex = normal_lex;
other_lex.map = [other_lex.map [new_word; new2]];
other_lex.num_mappings = other_lex.num_mappings + 1;


%% now calculate 
name = {'original','correct','incorrect'};
lexs = {'normal_lex','corr_lex','other_lex'};

fprintf('\nbayesian model results:\n');
for i = 1:3
  lex = eval(lexs{i});
  [a prior ll] = scoreLexicon(lex,corpus);
  [a b new_ll] = scoreBaldwin(lex,new_sit);
  post = sum(ll) + sum(new_ll) + prior;
  fprintf(['%s:\tcorpus=%2.2f\tBaldwin sit=' ...
    '%2.2f\tprior=%2.2f\tpost=%2.2f\n'],...
    name{i},sum(ll),sum(new_ll),prior,sum(post));
end