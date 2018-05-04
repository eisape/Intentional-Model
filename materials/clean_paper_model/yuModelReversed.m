% comparison implementation of Yu & Ballard (2008) 
% translation model from Brown et al. (1994), "IBM Model I"
%
% described in "Using speakers' referential intentions to model early
% cross-situational word learning." Psych Science (submitted).
%
% note: this implementation optimizes P(words | objects). For
% P(objects | words), see yuModel.m

clear all
addpath([pwd '/data']);
addpath([pwd '/helper_functions']);
addpath([pwd '/baseline_functions']);
load corpus.mat
load world.mat
load gold_standard.mat

num_iter = 20; % number of EM steps

%% add a null to the list of objects in each situation
% we still add null to objects even though they are "words" for the purpose
% of this simulation

world.num_objects = world.num_objects + 1;
world.objects_key{end+1} = 'NULL';
null_obj = world.num_objects;

for i = 1:length(corpus)
  corpus(i).objects(end+1) = null_obj;
end

%% flip objects and words in the corpus

for i = 1:length(corpus)
  temp = corpus(i).words;
  corpus(i).words = corpus(i).objects;
  corpus(i).objects = temp;
end

temp = world.num_words;
world.num_words = world.num_objects;
world.num_objects = temp;

%% run the EM algorithm
% BPPM (1994) start with uniform intial thetas, this is justified because 
% there is only one maximum for IBM model 1 (even though Yu starts with 
% association frequencies as initial thetas).

thetas{1} = ones(world.num_objects,world.num_words) ./ world.num_words;

fprintf('*** running EM ***\niter\tchange\n');
for i = 2:num_iter
  estimated_counts{i} = computeCounts(thetas{i-1},corpus);
  thetas{i} = computeAssociations(estimated_counts{i},corpus,world);
  fprintf('%d\t%2.2f\n',i-1,nansum(nansum(abs(thetas{i}-thetas{i-1}))));
end

%% now evaluate the results

yu_model_thetas = thetas{end}(:,1:end-1); % remove nulls
[p,r,f,yu_lex] = consolidateMatrix(yu_model_thetas,gold_standard,world);
evalLexicon(yu_lex,gold_standard,world);
