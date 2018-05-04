% the E (expectation) step for the EM algorithm in Yu & Ballard's
% translation model.

function est_c = computeCounts(thetas,corpus)

for i = 1:length(corpus)
  for j = 1:length(corpus(i).objects)
    for k = 1:length(corpus(i).words)
      % estimated counts for each sentence based on p(obj|word)
      object = corpus(i).objects(j);
      word = corpus(i).words(k);
      
      % normalize here by the objects in this situation      
      est_c{i}(j,k) = thetas(object,word) / sum(thetas(object,corpus(i).words));
      
      % now weight this by how many times the object and word occur in the
      % situation
      est_c{i}(j,k) = est_c{i}(j,k) * sum(corpus(i).objects==object) * ...
        sum(corpus(i).words==word);
    end
  end
end