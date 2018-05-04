% compute posterior score. this is the heart of the model, explained fully
% in the tech report. 

function [score log_prior log_likelihood] = scoreLexicon(lex, corpus)

% compute prior
log_prior = scorePrior(lex);

% add caching 
lex = addWordScoresCache(lex);

% seed likelihood then compute for each sentence
log_likelihood = zeros(1, length(corpus));

for i = 1:length(corpus)
  word_cost = lex.word_costs([1 corpus(i).objects+1], corpus(i).words);
  word_scores = corpus(i).gamma_intents * word_cost;
  scores = prod(word_scores, 2);
  log_likelihood(i) = log(sum(scores)) - log(length(scores));
end  

% take product over sentences and combine with prior
score = log_prior + sum(log_likelihood);

% geometric prior (calculated in log space)
function lp = scorePrior(lex)
lp = (-lex.alpha.*lex.num_mappings);
