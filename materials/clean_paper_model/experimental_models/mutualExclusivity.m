% script to do Mutual Exclusivity simulations 

clear all

addpath([pwd '/../data']);
addpath([pwd '/../helper_functions']);

%% first start out by loading the old corpus and adding on the mutual
% exclusivity experimental scenario

load corpus.mat
load world.mat
load ww_best_lex.mat

new_obj = 23; % DAX
old_obj = 3; % BIRD
new_word = 420; % dax

new_sit(1).objects = [new_obj old_obj];
new_sit(1).words = [new_word];

%% now run the wurwur model on this
parameters.alpha = 1; % lexicon size prior parameter
parameters.gamma = .1; % probability that a word refers to an intended object.
parameters.kappa = .9; % penalty for a non-refering use of a word

corpus = addCorpusIntentCache(corpus, parameters);
new_sit = addCorpusIntentCache(new_sit, parameters); 

lex = sampleLexicon(world,parameters);
normal_lex = lex;
normal_lex.map = ww_best_lex.map;
normal_lex.num_mappings = ww_best_lex.num_mappings;

normal_lex.num_words = normal_lex.num_words + 1;
normal_lex.num_objects = normal_lex.num_objects + 1;
normal_lex.word_freq = [normal_lex.word_freq 1];

% create the different lexicons we evaluate
dax_lex = normal_lex;
dax_lex.map = [dax_lex.map [new_word; new_obj]];
dax_lex.num_mappings = dax_lex.num_mappings + 1;
bird_lex = normal_lex;
bird_lex.map = [bird_lex.map [new_word; old_obj]];
bird_lex.num_mappings = bird_lex.num_mappings + 1;
both_lex = normal_lex;
both_lex.map = [both_lex.map [new_word; old_obj] [new_word; new_obj]];
both_lex.num_mappings = both_lex.num_mappings + 2;

%% now calculate 
name = {'original','DAX-"dax"','BIRD-"dax"','both mappings'};
lexs = {'normal_lex','dax_lex','bird_lex','both_lex'};

fprintf('\nbayesian model results:\n');
for i = 1:4
  lex = eval(lexs{i});
  [a prior ll] = scoreLexicon(lex,corpus);
  [a b new_ll] = scoreLexicon(lex,new_sit);
  post = sum(ll) + sum(new_ll) + prior;
  fprintf(['%s:\tcorpus=%2.2f\tME sit=' ...
    '%2.2f\tprior=%2.2f\tpost=%2.2f\n'],...
    name{i},sum(ll),sum(new_ll),prior,sum(post));
    
  data(i,:) =  [sum(ll),sum(new_ll),prior,sum(post)];
end

%% normalized values
sdata = exp(data - repmat(logsumexp(data),4,1));

for i = 1:4
  fprintf('sdata[%d,] = c(%2.4f,%2.4f,%2.4f,%2.4f)\n',i,sdata(i,:));
end


