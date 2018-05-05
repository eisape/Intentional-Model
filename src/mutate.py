from random import randint, choice
from world import world
from pprint import pprint
from goldstandard import gold
from pyro.distributions import Categorical
import torch

def addWord(lex):
    newLex = dict(lex)
    x = Categorical(probs=torch.tensor(world.mis)).sample()
    pair = world.word_object_pairs[int(x)]
    newLex[pair[0]] = pair[1]
    return newLex

def deleteWord(lex):
    newLex = dict(lex)
    newLex.pop(choice(newLex.keys()))
    return newLex

def mutate(lex):
    # Input: lexicon as dictionary
    # Output: new lexicon after mutation
    operations = [addWord, deleteWord, swapWord]
    operation = operations[randint(0, len(operations)-1)]
    operation = deleteWord
    return operation(lex)

print(len(gold))
print(len(mutate(gold)))

first_dict = gold
second_dict = mutate(gold)
value = { k : first_dict[k] for k in set(first_dict) - set(second_dict) }
print value
