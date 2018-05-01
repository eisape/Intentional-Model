% this is a uniform guess at pairings, no constraints. the main purpose of 
% this function is to provide seed lexicons for search that include all the
% necessary fields.

function lex = sampleLexicon(world,parameters)

% transfer all parameters to lexicon
params = fieldnames(parameters);
for i = 1:length(params)
  lex.(params{i}) = parameters.(params{i});
end

num_mappings = randint(10);

lex.num_mappings = 0;
lex.map = [];

for i = 1:num_mappings
  lex = addWord(lex,world);
end

lex.word_freq= world.words_freq;
lex.num_words = world.num_words;
lex.num_objects = world.num_objects;

if isfield(world,'mis')
  lex.mis = world.mis;
end

function new_lex = addWord(this_lex,world)

new_lex = this_lex;
new_lex.map(1,this_lex.num_mappings+1) = ... 
  world.words(randint(world.num_words));
new_lex.map(2,this_lex.num_mappings+1) = ...
  world.objects(randint(world.num_objects));
new_lex.num_mappings = new_lex.num_mappings + 1;
