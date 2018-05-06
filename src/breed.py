from random import choice
from scoreLexicon import posteriorScore
from world import corpus

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

    wordA = choice(lexA.keys())
    objA = lexA[wordA]
    wordB = choice(lexB.keys())
    objB = lexB[wordB]

    lexA.pop(wordA)
    lexB.pop(wordB)
    lexA[wordB] = objB
    lexB[wordA] = objA

    scores[a] = posteriorScore(lexA, corpus)
    scores[b] = posteriorScore(lexB, corpus)
    return None

def swapWords(a, b, lexs, scores):
    #NB: this might decrease the size of the lexicons by 1
    lexA = lexs[a]
    lexB = lexs[b]

    wordA = choice(lexA.keys())
    objA = lexA[wordA]
    wordB = choice(lexB.keys())
    objB = lexB[wordB]

    lexA.pop(wordA)
    lexB.pop(wordB)
    lexA[wordB] = objA
    lexB[wordA] = objB

    scores[a] = posteriorScore(lexA, corpus)
    scores[b] = posteriorScore(lexB, corpus)
    return None

def swapObjects(a, b, lexs, scores):
    lexA = lexs[a]
    lexB = lexs[b]

    wordA = choice(lexA.keys())
    objA = lexA[wordA]
    wordB = choice(lexB.keys())
    objB = lexB[wordB]

    lexA[wordA] = objB
    lexB[wordB] = objA

    scores[a] = posteriorScore(lexA, corpus)
    scores[b] = posteriorScore(lexB, corpus)
    return None

def breed(a, b, lexs, scores):
    # Input: a!=b as ints, list of lexs, list of scores
    # Mutates the objects passed in!
    operations = [swapLexs, swapPair, swapWords, swapObjects]
    operation = choice(operations)
    if len(lexs[a])==0 or len(lexs[b])==0: return None
    return operation(a, b, lexs, scores)
