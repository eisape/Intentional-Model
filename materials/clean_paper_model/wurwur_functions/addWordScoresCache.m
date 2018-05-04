% cache the probability that each word in the lexicon is referring or
% non-referring. needs to be recomputed and cached every time the lexicon 
% changes. (see tech report for more details).

function lex = addWordScoresCache(lex)

% begin with a uniform probability of being a non-referring word
non_refer_prob = ones(1,lex.num_words); 

% modify so that words in lexicon are less likely to be non-refering and
% renormalize
non_refer_prob(lex.map(1,:)) = non_refer_prob(lex.map(1,:)) .* lex.kappa; 
non_refer_prob = non_refer_prob ./ sum(non_refer_prob);
lex.non_refer_prob = non_refer_prob; 

% now build the lexicon word cost trace, an objects x words matrix on the whole 
% domain which has lex.trace(o,w)~=0 if word w maps to object o, and has 
% normalized rows (ie. row sum == 1 or 0).

% this trace represents both the probability of a word being used
% referentially and non-referentially.

lex.word_costs = zeros(lex.num_objects, lex.num_words);
lex.word_costs(sub2ind([lex.num_objects, lex.num_words], lex.map(2,:), lex.map(1,:))) = 1;  
lex.word_costs = [zeros(1,size(lex.word_costs,2)); lex.word_costs]; 

rowsum = sum(lex.word_costs,2); 
nonref = (rowsum==0);
rowsum(nonref)=1;
lex.word_costs = lex.word_costs ./ repmat(rowsum,1, lex.num_words); %normalize non-zero rows.
lex.word_costs(nonref, :)=repmat(lex.non_refer_prob, sum(nonref),1); %non-referring probs.
