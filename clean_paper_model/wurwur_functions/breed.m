% propose a new lexicon by breeding lexicons a and b.

function [new_a move move_num] = breed(a, b, Temp_a, Temp_b)

  moves={'swap', 'site_borrow', 'site_swap', 'word_swap', 'object_swap'};
  move_num = randint(length(moves));
  move = moves{move_num};

  if b.num_mappings==0
    new_a = a;
    varargout{1} = 'noop';
    if nargout>2
    varargout{2}=[];
    end
    return
  else
    switch move
      case 'site_borrow'
        new_a = site_borrow(a, b);
      case 'word_swap'
        new_a = word_swap(a,b);
      case 'object_swap'
        new_a = object_swap(a,b);
      case 'site_swap'
        new_a  = site_swap(a, b);
      case 'gamma swap'
        new_a = gamma_swap(a,b);
      case 'swap'
        %usually only swap down.
        if Temp_a<Temp_b || rand<0.1
          new_a = swap(a, b);
        else
          new_a=a;
          words=[];objects=[];
        end
      case 'social swap'
        new_a = social_swap(a,b)
    end
  end
end

%%%%%%%%%%%%%%%%%% FUNCTIONS FOR BREEDING %%%%%%%%%%%%%%%

% swap lexicon b-->a. usually only swap down.
function lex = swap(a, b)
  lex=b;
end

% add one pair from a to b
function [lex words objects] = site_borrow(a, b)
  lex = a;
  borrow = randint(b.num_mappings);
  lex.num_mappings = lex.num_mappings +1;
  lex.map = [lex.map b.map(:,borrow)];
  words=b.map(1,borrow);
  objects=b.map(2,borrow);
end

% swap one pair from a to b
function [lex words objects] = site_swap(a, b)
  lex = a;
  if a.num_mappings~=0
  swapa = randint(a.num_mappings);
  swapb = randint(b.num_mappings);
  lex.map(:,swapa) = b.map(:,swapb);
  words=[a.map(1,swapa) b.map(1,swapb)];
  objects=[a.map(2,swapa) b.map(2,swapb)];
  else
      words=[]; objects=[];
  end
end

% replace meanings of a word in a with those in b.
function [lex words objects] = word_swap(a, b)
  lex = a;
  wn = randint(a.num_mappings);
  if wn~=0
  word = a.map(1,wn);
  anonentries = a.map(1,:)~=word;
  bentries = b.map(1,:)==word;
  lex.map = a.map(:, anonentries);
  removed_pairs = a.map(:, ~anonentries);
  lex.map = [lex.map b.map(:, bentries)];
  added_pairs = b.map(:, bentries);
  lex.num_mappings=size(lex.map,2);
  words= [added_pairs(1,:) removed_pairs(1,:)];
  objects= [added_pairs(2,:) removed_pairs(2,:)];
  else
      words=[]; objects=[];
  end
end

% replace words for an object in a with those in b.
function [lex words objects] = object_swap(a, b)
  lex = a;
  on = randint(a.num_mappings);
  if on~=0
    obj = a.map(2,on);
    anonentries = a.map(2,:)~=obj;
    bentries = b.map(2,:)==obj;
    lex.map = a.map(:, anonentries);
    removed_pairs = a.map(:, ~anonentries);
    lex.map = [lex.map b.map(:, bentries)];
    added_pairs = b.map(:, bentries);
    lex.num_mappings=size(lex.map,2);
    words= [added_pairs(1,:) removed_pairs(1,:)];
    objects= [added_pairs(2,:) removed_pairs(2,:)];
  else
    words=[]; objects=[];
  end
end




