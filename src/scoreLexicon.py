import numpy as np
from pprint import pprint
from params import alpha, kappa
# import fakeworld as world
from world import world

np.set_printoptions(suppress=True, precision=5)

def posteriorScore(lex, corpus):
    # Input: Lexicon, corpus as array of situations
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
            obj = o if o in lex.objects else -1 # Satan's math
            obj = o
            entry = []
            for word in s.words:
                entry.append(scores_cache[word][obj])
            word_cost.append(entry)

        word_cost = np.matrix(word_cost) #Change of type!
        gamma_intents = s.gamma_intents

        word_scores = np.matmul(gamma_intents, word_cost)

        scores = []
        for i in word_scores:
            scores.append(np.prod(i))
        y = np.log(sum(scores)) - np.log(word_scores.shape[0])
        log_likelihoods.append(y)
    return np.sum(log_likelihoods) + log_prior

def logPrior(lex, alpha):
    # Input: lexicon as Lexicon object, parameter alpha
    pair_count_sum = 0
    word_count_sum = 0
    obj_count_sum = 0
    for i in lex.getEntries():
        word = lex.words[i]
        obj = lex.objects[i]
        word_count_sum += world.word_counts[word]
        obj_count_sum += world.object_counts[obj]
        pair_count_sum += world.word_object_counts[(word, obj)]
    f = float(pair_count_sum)/(word_count_sum*obj_count_sum)
    return -alpha * lex.getLen()

def wordScoresCache(lex):
    # Input: Lexicon
    # Output: Word scores cache as 2D dictionary

    nonref_unknown = 1.0 / world.num_words # Probability a word not in the lexicon is used nonreferentially
    nonref_known = nonref_unknown * kappa # Probability a word in the lexicon is used nonreferentially

    total = 0
    for word in world.words:
        if word in lex.words: total += nonref_known
        else: total += nonref_unknown
    nonref_unknown /= total
    nonref_known /= total

    num_repetitions = {}
    for i in lex.getEntries():
        word = lex.words[i]
        meaning = lex.objects[i]
        if meaning in num_repetitions:
            num_repetitions[meaning] += 1
        else:
            num_repetitions[meaning] = 1

    word_scores = {}

    for word in world.words:
        word_scores[word] = {}
        for obj in world.objects:
            word_scores[word][obj] = 0
            if word in lex.words:
                word_scores[word][-1] = nonref_known
                if lex.wordMapsToObj(word, obj):
                    word_scores[word][obj] = 1.0 / num_repetitions[obj]
            else:
                word_scores[word][-1] = nonref_unknown
    return word_scores

# fakelex = {0: 0, 1: 3, 2: 0, 8: 1}
# pprint(wordScoresCache(fakelex))
# print posteriorScore(fakelex, world.corpus)
