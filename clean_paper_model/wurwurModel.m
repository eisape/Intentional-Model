% wurwur model
%
% a Bayesian model of cross-situational word learning that represents
% referential intentions
%
% Mike Frank, Noah Goodman, and Josh Tenenbaum
%
% described in " Using speakers' referential intentions to model early
% cross-situational word learning." Psych Science (submitted).

clear all; 
rand('twister', sum(100*clock)); % make sure that runs are independent
addpath([pwd '/data']);
addpath([pwd '/helper_functions']);
addpath([pwd '/wurwur_functions']);

%% parameters

verbose=1; % show information 
temp = [0.0001 1 10 100 1000]; % the temperature ladder for our stochastic-
                               % search version of parallel-tempered MCMC
num_samps = 50000; % number of search moves to try (20,000 converges often)

parameters.alpha = 7; % lexicon size prior parameter
parameters.gamma = .1; % probability that a word refers to an intended object.
parameters.kappa = .05; % penalty for a non-refering use of a word

%% set up the world and corpus

load corpus.mat
load world.mat
load gold_standard.mat

% cache intents for the corpus 
corpus = addCorpusIntentCache(corpus, parameters);
  
%% initialize chains for search at different temperatures

for i = 1:length(temp)
  lexs(i) = sampleLexicon(world,parameters);
  score(i) = scoreLexicon(lexs(i),corpus);
end

%% now do stochastic search on each of the chains

for t = 1:num_samps
  % update each chain separately and make a proposal for changing it:
  for T=1:length(temp)
    [new_lex search_move new_corpus move_num moves] = mutate(lexs(T),corpus);
    new_score = scoreLexicon(new_lex,corpus);
        
    % metropolis step. not fully kosher, hence this is stochastic search
    % rather than true MCMC.
    if rand < exp((new_score - score(T))./temp(T)) 
      lexs(T) = new_lex;
      score(T) = new_score;       
    end

    if verbose==1 % display info on what just happened
      disp([num2str(t) ': accept mutation -' search_move '- on chain ' num2str(T)]);
    end
  end

  % every now and then choose two chains and consider breeding them:
  if rem(t,5)==0
    a=randint(length(temp)); b=randint(length(temp));
    if a~=b
      [new_a move move_num] = breed(lexs(a), lexs(b), temp(a), temp(b));
      [new_score] = scoreLexicon(new_a,corpus);

      if rand < exp((new_score - score(a))./temp(a))
        lexs(a) = new_a;
        score(a) = new_score;
      end
      
      if verbose==1 % display info on what just happened
        disp([num2str(t) ': accept breeding -' move '- on chains ' ...
          num2str(a) '<--' num2str(b)]);
      end
    end   
  end
  
  % give graphical updates every once in a while
  if verbose==1 && rem(t,100)==0
    evalLexicon(lexs,gold_standard,world);
  end  
end