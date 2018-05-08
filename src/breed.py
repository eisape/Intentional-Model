from random import choice
from scoreLexicon import posteriorScore
from world import corpus
from lexicon import Lexicon

def swapLexs(a, b, lexs, scores):
    tempLex = lexs[a]
    lexs[a] = lexs[b]
    lexs[b] = tempLex

    tempScore = scores[a]
    scores[a] = scores[b]
    scores[b] = tempScore
    return None

def swapPair(a, b, lexs, scores):
    lexA = lexs[a]
    lexB = lexs[b]

    swapA = choice(lexA.getEntries())
    swapB = choice(lexB.getEntries())
    pairA = lexA.getPairByIdx(swapA)
    pairB = lexB.getPairByIdx(swapB)

    lexA.deleteByIdx(swapA)
    lexA.addPair(pairB[0], pairB[1])
    lexB.deleteByIdx(swapB)
    lexB.addPair(pairA[0], pairA[1])

    scores[a] = posteriorScore(lexA, corpus)
    scores[b] = posteriorScore(lexB, corpus)

    lexA.clearDuplicates()
    lexB.clearDuplicates()
    return None

def swapWords(a, b, lexs, scores):
    lexA = lexs[a]
    lexB = lexs[b]

    swapA = choice(lexA.getEntries())
    swapB = choice(lexB.getEntries())
    wordA = lexA.words[swapA]
    wordB = lexB.words[swapB]

    lexA.words[swapA] = wordB
    lexB.words[swapB] = wordA

    scores[a] = posteriorScore(lexA, corpus)
    scores[b] = posteriorScore(lexB, corpus)

    lexA.clearDuplicates()
    lexB.clearDuplicates()
    return None

def swapObjects(a, b, lexs, scores):
    lexA = lexs[a]
    lexB = lexs[b]

    swapA = choice(lexA.getEntries())
    swapB = choice(lexB.getEntries())
    objA = lexA.objects[swapA]
    objB = lexB.objects[swapB]

    lexA.objects[swapA] = objB
    lexB.objects[swapB] = objA

    scores[a] = posteriorScore(lexA, corpus)
    scores[b] = posteriorScore(lexB, corpus)
    lexA.clearDuplicates()
    lexB.clearDuplicates()
    return None

def breed(a, b, lexs, scores):
    # Input: a!=b as ints, list of lexs, list of scores
    # Mutates the objects passed in!
    operations = [swapLexs, swapPair, swapWords, swapObjects]
    operation = choice(operations)
    if lexs[a].getLen()==0 or lexs[b].getLen()==0: return None
    return operation(a, b, lexs, scores)
