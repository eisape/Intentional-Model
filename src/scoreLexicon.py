import numpy as np
import fakeworld as world
from pprint import pprint

np.set_printoptions(suppress=True)

def posteriorScore(lex, corpus):
    # Input: Lexicon as dictionary, corpus as array of situations
    # returns its posterior score
    scores_cache = wordScoresCache(lex)
    pprint(scores_cache)

    situation_scores = [] # value of Eq. 2 in technical appendix for each situation
    for s in corpus:
        word_cost = []

        nonref_entry = []
        for word in s.words:
            nonref_entry.append(scores_cache[word][-1])
        word_cost.append(nonref_entry)
        for o in s.objects:
            obj = o if o in lex.values() else -1
            entry = []
            for word in s.words:
                entry.append(scores_cache[word][obj])
            word_cost.append(entry)

        word_cost = np.matrix(word_cost) #Change of type!
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
        for obj in world.objects:
            word_scores[word][obj] = 0
            if word in lex:
                word_scores[word][-1] = nonref_known
                if lex[word] == obj:
                    word_scores[word][obj] = 1.0 / num_repetitions[obj]
            else:
                word_scores[word][-1] = nonref_unknown
    return word_scores

fakelex = {0: 0, 1: 3, 2: 0, 8: 1}
# pprint(wordScoresCache(fakelex))
posteriorScore(fakelex, world.corpus)
