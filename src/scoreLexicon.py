import numpy as np
import world
import pprint

def posteriorScore(lex, corp):
    # Input: Lexicon as dictionary, corpus as array of situations
    # returns its posterior score
    return 0;

def lexiconPrior(lex, alpha):
    # Input:
    power = -alpha * len(lex)
    return np.exp(power)

def wordScoresCache(lex):
    # Input: Lexicon as dictionary
    # Output: Word scores cache as 2D dictionary

    nonref_unknown = 0.0026 # Probability a word not in the lexicon is used nonreferentially
    nonref_known = 0.0001 # Probability a word in the lexicon is used nonreferentially

    num_repetitions = {}
    for word in lex:
        meaning = lex[word]
        if meaning in num_repetitions:
            num_repetitions[meaning] += 1
        else:
            num_repetitions[meaning] = 1

    word_scores = {}

    for word in world.words:
        word_scores[word] = {}
        word_scores[word][-1] = nonref_known
        for obj in world.objects:
            if lex[word] == obj:
                word_scores[word][obj] = 1.0 / num_repetitions[obj]
            else:
                word_scores[word][obj] = 0
    return word_scores

pprint.pprint(wordScoresCache({0: 0, 1: 3, 2: 0}))
