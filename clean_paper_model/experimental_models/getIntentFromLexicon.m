% function gets the inferred intent for a particular utterance given a
% lexicon. helper for scoreIntents.

function intent = getIntentFromLexicon(utt,lex)

% intent is every word-object pair from the lexicon that is instantiated in
% the situation

intent = [];
for i = 1:length(utt.words)
  for j = 1:length(utt.objects)
    if sum(lex.map(2,lex.map(1,:)==utt.words(i))==utt.objects(j))>0
      intent = [intent j];
    end
  end
end

intent = unique(intent);