% model xu(2002) object inference from word labels experiments. 
clear all

addpath([pwd '/../helper_functions']);

%% first set up the situations and interpretations
% situations/interpretations are: 2w/2o 2w/1o 1w/2o 1w/1o

cond1_interp1(1).objects = 1;
cond1_interp1(2).objects = 2;
cond1_interp1(1).words = 1;
cond1_interp1(2).words = 2;

cond1_interp2(1).objects = 1;
cond1_interp2(2).objects = 1;
cond1_interp2(1).words = 1;
cond1_interp2(2).words = 2;

cond2_interp1(1).objects = 1;
cond2_interp1(2).objects = 2;
cond2_interp1(1).words = 1;
cond2_interp1(2).words = 1;

cond2_interp2(1).objects = 1;
cond2_interp2(2).objects = 1;
cond2_interp2(1).words = 1;
cond2_interp2(2).words = 1;


sits{1}=[cond1_interp1 cond1_interp1 cond1_interp1 cond1_interp1 cond1_interp1 cond1_interp1 cond1_interp1];
sits{2}=[cond1_interp2 cond1_interp2 cond1_interp2 cond1_interp2 cond1_interp2 cond1_interp2 cond1_interp2];
sits{3}=[cond2_interp1 cond2_interp1 cond2_interp1 cond2_interp1 cond2_interp1 cond2_interp1 cond2_interp1];
sits{4}=[cond2_interp2 cond2_interp2 cond2_interp2 cond2_interp2 cond2_interp2 cond2_interp2 cond2_interp2];

%% now make lexicons and score
num_words = [2 2 1 1];
num_objects = [2 2 2 2];

% loop over all situations and all possible lexicons 
for s = 1:length(sits)
  lexs = getAllLexicons(1:num_words(s), 1:num_objects(s));
  
  for l = 1:length(lexs)
    % parameter values are not essential
    lexs{l}.gamma=0.2;
    lexs{l}.alpha=1;
    lexs{l}.epsilon=0;
    lexs{l}.theta=0;
    lexs{l}.kappa=0.01;

    % number of total words in the world is important because the more
    % words in the world, the lower P_NR is. P_NR must be low for these
    % simulations to succeed (and it certainly is in the real world).
    
    lexs{l}.num_mappings=size(lexs{l}.map,2);
    lexs{l}.num_objects=num_objects(s);
    lexs{l}.num_words=9; 
    lexs{l}.word_freq=ones(1,lexs{l}.num_words);
    
    corpus = addCorpusIntentCache(sits{s}, lexs{l});
    scores{s}(l) = scoreLexicon(lexs{l},corpus);
  end
end



%% finally, show data

% xu data
infants = [8.6 7.3; 5.4 7.8];
i_sems = [5.0 3.1; 2.6 3.5] ./ sqrt(12);

% model data
ps = [mean(exp(scores{1})) mean(exp(scores{2})) ...
  mean(exp(scores{3})) mean(exp(scores{4}))];
relative_probabilities = ...
  [(ps([2 1])./sum(ps(1:2)))' (ps([4 3])./sum(ps(3:4)))'];
surprisals = -log(relative_probabilities);

disp('infant data: ')
disp(infants)
disp('model surprisal: ')
disp(surprisals)
