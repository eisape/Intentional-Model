% simulations for the Yu & Smith (2007) cross-situational word learning
% paper.

clear all

addpath([pwd '/../data']);
addpath([pwd '/../helper_functions']);
addpath([pwd '/../baseline_functions']);

% first get the corpus, using the 4x4 condition.
corpus = crossSituationalCorpus(4);
gold_standard.map = [1:18; 1:18];
gold_standard.num_mappings = 18;

% now just a proof-of-concept that any associative model gets this result
assocs = zeros(18);
for i = 1:length(corpus)
  for j = 1:length(corpus(i).words)
    assocs(corpus(i).words(j),corpus(i).objects) = ... 
      assocs(corpus(i).words(j),corpus(i).objects) + 1;
  end
end

% the max F score is 1.
[p,r,f,lex] = consolidateMatrix(assocs,gold_standard);

%% now run the bayesian model on this corpus
% converge
num_samps = 10000;
parameters.alpha = 1; % lexicon size prior parameter
parameters.gamma = 1; % probability that a word refers to an intended object.
parameters.kappa = .5; % penalty for a non-refering use of a word

world.words = 1:18;
world.objects = 1:18;
world.num_words = 18; 
world.num_objects = 18;
world.mis = reshape(cumsum(ones(1,18^2)),[18 18])./(18.^2);
world.words_freq = ones(1,18).*6;
world.words_key = cellfun(@(x) num2str(x), num2cell(1:18),'UniformOutput',0);
world.objects_key = world.words_key;

lex = sampleLexicon(world,parameters);
corpus = addCorpusIntentCache(corpus, parameters);

score = scoreLexicon(lex,corpus);
for t = 1:num_samps
  [new_lex search_move new_corpus move_num moves] = mutate(lex,corpus);
  new_score = scoreLexicon(new_lex,corpus);

  % use a greedy search to save time, works fine
  if new_score > score 
    lex = new_lex;
    score = new_score;       
  end

  % give updates
  disp([num2str(t) ': accept mutation -' search_move]);
  if rem(t,50)==0, evalLexicon(lex,gold_standard,world); WaitSecs(2); drawnow; end;

end