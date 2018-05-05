from pprint import pprint
import numpy as np
from world import world, corpus
from scoreLexicon import posteriorScore
import scoreLexicon
from goldstandard import gold
import random
from random import randint

# # Tests construction of the world
# print world.words_key
# print world.num_words
# print world.words
# print world.words_freq
# print
# print world.objects_key
# print world.num_objects
# print world.objects
# print world.objects_freq
#
# Tests construction of the corpus
# for s in corpus:
#     print s.objects




randomLexicon = {}
for i in range(2):
    randomLexicon[randint(0, world.num_words-1)] = randint(0, world.num_objects-1)
print "Random lexicon score:"
prand = posteriorScore(randomLexicon, corpus)
print prand
print
mapto2 = {}
for word in gold.keys():
    mapto2[word] = 2
print "ALL WORDS MAP TO 2 score:"
pto2 = posteriorScore(mapto2, corpus)
print pto2
print
print "Gold score:"
pgold = posteriorScore(gold, corpus)
print pgold
