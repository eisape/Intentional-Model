from random import randint, choice
from world import world
from pprint import pprint
from goldstandard import gold
from pyro.distributions import Categorical
import torch
from sampleLexicon import sampleLexicon
from lexicon import Lexicon

def addWord(lex):
    newLex = lex.duplicate()
    x = Categorical(probs=torch.tensor(world.mis))
    pair = world.word_object_pairs[int(x.sample())]
    newLex.addPair(pair[0], pair[1])
    return newLex

def deleteWord(lex):
    # Assumes len(lex)>0
    newLex = lex.duplicate()
    i = choice(newLex.getEntries())
    newLex.deleteByIdx(i)
    return newLex
    
def swapWord(lex):
    newLex = addWord(lex)
    newLex = deleteWord(newLex)
    return newLex

def mutate(lex):
    # Input: lexicon, temp as flat such that 0<temp<=1
    # Output: new lexicon after mutation
    if lex.getLen()==0: return sampleLexicon()
    operations = [addWord, deleteWord, swapWord]
    operation = choice(operations)
    newLex = operation(lex)
    if newLex.getLen()==0: newLex = sampleLexicon()
    newLex.clearDuplicates()
    return newLex
