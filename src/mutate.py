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
    newLex = dict(lex)
    word2replace = choice(newLex.keys())
    obj = newLex[word2replace]
    words = []
    mis = []
    for i in range(len(world.word_object_pairs)):
        pair = world.word_object_pairs[i]
        if pair[1] == obj:
            words.append(pair[0])
            mis.append(world.mis[i])
    x = Categorical(probs=torch.tensor(mis))
    newWord = words[int(x.sample())]
    newLex[newWord] = obj
    if len(newLex) > len(lex):
        newLex.pop(word2replace)
    return newLex

def oldSwapWord(lex):
    newLex = addWord(lex)
    newLex = deleteWord(newLex)
    return newLex

def mutate(lex):
    # Input: lexicon as dictionary, temp as flat such that 0<temp<=1
    # Output: new lexicon after mutation
    if len(lex)==0: return sampleLexicon()
    operations = [addWord, deleteWord, swapWord]
    operation = operations[randint(0, len(operations)-1)]
    newLex = operation(lex)
    if len(newLex)==0: newLex = sampleLexicon()
    return newLex
