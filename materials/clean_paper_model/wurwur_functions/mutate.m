% propose a new lexicon by mutating the current lexicon.

function [new_lex change corpus move_num changes] = mutate(this_lex,corpus)

% choose from a number of possible moves
changes = {'swap word MI', 'add word MI','delete word'};
move_num = randint(length(changes));
change = changes{move_num};

switch change
  case 'add word MI'
    [new_lex] = addWordByAssoc(this_lex);
  case 'swap word MI'
    [new_lex] = swapaddWordByAssoc(this_lex);
  case 'delete word'
    [new_lex] = deleteWord(this_lex);
end

%%%%%%%%%%%%%%%%%% FUNCTIONS FOR MUTATING %%%%%%%%%%%%%%%

% add a word that occurs in the environment
function [new_lex] = addWordByAssoc(lex) 

new_lex = lex;

[i,j] = find(lex.mis>rand,1);

new_lex.map(1,lex.num_mappings+1) = i;
new_lex.map(2,lex.num_mappings+1) = j;
new_lex.num_mappings = new_lex.num_mappings + 1;

% delete a word from the lexicon
function [new_lex word object] = deleteWord(this_lex)

new_lex = this_lex;

if new_lex.num_mappings > 0
  if nargin > 1
    to_delete = varargin{1};
  else
    to_delete = randint(new_lex.num_mappings);
  end
  
  new_lex.map(:,to_delete) = [];
  new_lex.num_mappings = new_lex.num_mappings - 1;

  word = this_lex.map(1,to_delete);
  object = this_lex.map(2,to_delete);
end 

% add a word-object pair that occurs in the environment
% if the object chosen already has a word, swap for the new one.
function [new_lex] = swapaddWordByAssoc(lex) 

new_lex = lex;

% finds a random word-meaning pairing by mutual information
[i,j] = find(lex.mis>rand,1);

% is this object in lexicon already?
defs = find(lex.map(2,:)==j);

if isempty(defs)
    % no existing def for this object, add at end.
    place = lex.num_mappings+1;
    new_lex.num_mappings = new_lex.num_mappings + 1;
else
    % choose a def to replace at random.
    place = defs(randint(length(defs)));
end

new_lex.map(1,place) = i;
new_lex.map(2,place) = j;
