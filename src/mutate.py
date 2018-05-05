from random import randint, choice
from world import world
from pprint import pprint
from goldstandard import gold
from pyro.distributions import Categorical
import torch
from sampleLexicon import sampleLexicon

def addWord(lex):
    newLex = dict(lex)
    x = Categorical(probs=torch.tensor(world.mis))
    pair = world.word_object_pairs[int(x.sample())]
    while pair[0] in lex:
            pair = world.word_object_pairs[int(x.sample())]
    newLex[pair[0]] = pair[1]
    return newLex

def deleteWord(lex):
    # Assumes len(lex)>0
    newLex = dict(lex)
    newLex.pop(choice(newLex.keys()))
    return newLex

def swapWord(lex):
    newLex = addWord(lex)
    newLex = deleteWord(newLex)
    return newLex

def mutate(lex):
    # Input: lexicon as dictionary
    # Output: new lexicon after mutation
    if len(lex)==0: return sampleLexicon()
    operations = [addWord, deleteWord]
    operation = operations[randint(0, len(operations)-1)]
    newLex = {}
    for i in range(randint(1, len(lex)/2)):
        newLex = operation(lex)
    return newLex
