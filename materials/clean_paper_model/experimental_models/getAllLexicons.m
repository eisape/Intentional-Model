% build the set of all possible lexicons. helper function for the
% objectIndividuation simulations.

function lexs = get_all_lexicons(words, objects)

% first build list of all pairs (this is the maximal lexicon):
max_lex=[];
for o=1:length(objects)
  for w=1:length(words)
    max_lex=[max_lex [words(w); objects(o)]];
  end
end

lexs={};

% now take subsets of this maximal lexicon
poss = str2mat(num2str(dec2bin(0:2^(size(max_lex,2))-1)));

for i = 1:length(poss)
  for j = 1:length(poss(i,:))
    this_poss(j) = logical(str2num(poss(i,j)));
  end
  lexs{i}.map = max_lex(:, this_poss);
end


