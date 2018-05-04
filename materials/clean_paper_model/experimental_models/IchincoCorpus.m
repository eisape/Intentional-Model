% make corpus for ichinco, frank, & saxe paper.
% condition is 1 or 2 for words or pictures confounded.

function corpus = IchincoSims(condition)

conditions = {'4 words','4 pictures'};
condition = conditions{condition};

% set up constants
num_blocks = 2;
num_words = [24 24];
num_occurrences = [6 6];
total_words = num_words .* num_occurrences;
num_trials = total_words ./ 3;

%% now make the corpus
c = 1;

for b = 1:num_blocks
  items = ones(1,num_words(b)) .* num_occurrences(b);
  
  for i = 1:num_trials(b) % for each trial
    for j = 1:3 % for each word/object pairing in the trial
      
      % switch depending on block
      if b == 1
        item_probs = items ./ total_words(b);
      elseif b == 2 % confounded blocks
        if j == 1        
          item_probs = items(1:8) ./ sum(items(1:8));
        elseif j > 1
          item_probs = [zeros(1,8) items(9:24) ./ sum(items(9:24))];
        end
      end
      
      corpus(c).words(j) = find(multirnd(item_probs)) + (b-1)*24;                   

      % avoid repeats
      d = 1;
      while sum(corpus(c).words(j) == corpus(c).words) > 1
        corpus(c).words(j) = find(multirnd(item_probs)) + (b-1)*24;
        d = d + 1;
        if d > 1000, error('failed to generate corpus, run me again!'); end;       
      end

      corpus(c).objects(j) = corpus(c).words(j);
      corpus(c).block = b;

      % deincrement the item counts
      items(corpus(c).words(j) - (b-1)*24) = items(corpus(c).words(j)  - (b-1)*24) - 1;
      total_words(b) = total_words(b) - 1;
    end
    
    if b == 2 % if it's the second block
      switch condition
        case '4 words'
          corpus(c).words(end+1) = corpus(c).words(1) - 24;
        case '4 pictures'
          corpus(c).objects(end+1) = corpus(c).objects(1) - 24;
      end        
    end
        
    c = c + 1;
  end
end