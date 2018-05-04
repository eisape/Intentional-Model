% add a cache of all intents to the corpus, then multiply by gamma to
% create a cached array for each situation that represents the probability
% of something getting talked about. (see tech report for more details).

function corpus = addCorpusIntentCache(corpus, parameters)

for i = 1:length(corpus)
  %build all possible intent traces
  intents = dec2bin(0:(2^length(corpus(i).objects) -1))=='1';
  corpus(i).intents=intents;

  % store the dimensions
  [corpus(i).n_intents corpus(i).intent_len] = size(intents);

  % number of words in each intent
  corpus(i).intent_size = sum(intents, 2);
  corpus(i).intent_size(1)=1; %special case: empty intent.

  % add the null intent (non-function word) as first place in each intent,
  % put in the cost of being a (non-)function word and choosing a particular
  % intent object
  gamma_intents = intents .* repmat( 1 ./ corpus(i).intent_size, 1, corpus(i).intent_len);
  corpus(i).gamma_intents = ...
    [(1-parameters.gamma).*ones(corpus(i).n_intents, 1) parameters.gamma.*gamma_intents];    
  corpus(i).gamma_intents(1,:) = [1 zeros(1,corpus(i).intent_len)]; %special case: empty intent.
end
