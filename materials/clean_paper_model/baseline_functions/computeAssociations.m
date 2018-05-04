% the M (maximization) step for the EM algorithm in Yu & Ballard's
% translation model.

function thetas = computeAssociations(estimated_counts,corpus,lex)

counts = zeros(lex.num_objects,lex.num_words);

for i = 1:length(estimated_counts) % sentences
  for j = 1:size(estimated_counts{i},1) % objects per sentence
    for k = 1:size(estimated_counts{i},2) % words per sentence
      object = corpus(i).objects(j);
      word = corpus(i).words(k);
      counts(object,word) = counts(object,word) + estimated_counts{i}(j,k);
    end
  end
end

% now normalize by *objects*
thetas = counts ./ repmat(sum(counts),lex.num_objects,1);