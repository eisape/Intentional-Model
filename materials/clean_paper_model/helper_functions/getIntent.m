% get the most likely intent from an utterance given a lexicon (this is
% used for scoring guesses about intents from each model). intent for this
% purpose is every word-object pair from the lexicon where the word is
% spoken in this situation.

function intent = getIntent(utt,lex)

intent = [];
for i = 1:length(utt.words)
  for j = 1:length(utt.objects)
    if sum(lex.map(2,lex.map(1,:)==utt.words(i))==utt.objects(j))>0
      intent = [intent j];
    end
  end
end

intent = unique(intent);