import numpy as np
from pprint import pprint
from params import alpha, kappa
# import fakeworld as world
from world import world

np.set_printoptions(suppress=True, precision=5)

def posteriorScore(lex, corpus):
    # Input: Lexicon as dictionary, corpus as array of situations
    # returns its posterior score
    scores_cache = wordScoresCache(lex)

    log_prior = logPrior(lex, alpha)

    log_likelihoods = [] # value of Eq. 2 in technical appendix for each situation
    x = 0
    for s in corpus:
        if len(s.objects)==0: continue # Skip situations with no objects
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
        gamma_intents = s.gamma_intents
        # Code to compare with example in technical appendix
        # if x==0:
        #     w = world
        #     print scores_cache[w.words_key.index('books')][w.objects_key.index('book')]
        #     print [world.words_key[m] for m in s.words]
        #     print [world.objects_key[m] for m in s.objects]
        #     print word_cost
        #     print gamma_intents
        #     x += 1

        word_scores = np.matmul(gamma_intents, word_cost)

        scores = []
        for i in word_scores:
            scores.append(np.prod(i))
        y = np.log(sum(scores)) - np.log(word_scores.shape[0])
        log_likelihoods.append(y)
    return np.sum(log_likelihoods) + log_prior

def logPrior(lex, alpha):
    # Input: lexicon as dictionary, parameter alpha
    return -alpha * len(lex)

def wordScoresCache(lex):
    # Input: Lexicon as dictionary
    # Output: Word scores cache as 2D dictionary

    nonref_unknown = 1.0 / world.num_words # Probability a word not in the lexicon is used nonreferentially
    nonref_known = nonref_unknown * kappa # Probability a word in the lexicon is used nonreferentially

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

# fakelex = {0: 0, 1: 3, 2: 0, 8: 1}
# pprint(wordScoresCache(fakelex))
# print posteriorScore(fakelex, world.corpus)
