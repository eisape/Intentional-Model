% Make corpus for Yu & Smith (2007) rapid cross-situational word learning
% experiment. Corpus format is the same as for our CHILDES corpus: a struct
% with word and object fields.
%
% condition is 2, 3, or 4, referring to the 2x2, 3x3, or 4x4 word learning
% conditions in the paper.

function corpus = makeYu(condition)

% set up constants
num_words = 18;
num_occurrences = 6;
total_words = num_words * num_occurrences;
num_trials = total_words / condition;
items = ones(1,num_words) .* num_occurrences;

%% now make the corpus
% note that since order doesn't matter in any of the models we are
% evaluating, we can just make words and objects the same. the models don't
% know that word 1 is the same as object 1: this is what they have to
% learn. 
for i = 1:num_trials % for each trial
  for j = 1:condition % for each word/object pairing in the trial
    item_probs = items ./ total_words;
    
    corpus(i).words(j) = find(multirnd(item_probs));
    
    % avoid repeats
    c = 1;
    while sum(corpus(i).words(j) == corpus(i).words) > 1
      corpus(i).words(j) = find(multirnd(item_probs));
      c = c + 1;
      if c > 1000, error('failed to generate corpus, run me again!'); end;       
    end

    corpus(i).objects(j) = corpus(i).words(j);

    % deincrement the item counts
    items(corpus(i).words(j)) = items(corpus(i).words(j)) - 1;
    total_words = total_words - 1;
  end
end
