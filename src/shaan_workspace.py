from pprint import pprint
import numpy as np
from world import world, corpus
from scoreLexicon import posteriorScore
import scoreLexicon
from goldstandard import gold
import random
from random import randint
from utils import printLex, fScore
from mutate import mutate
from sampleLexicon import sampleLexicon
from lexicon import Lexicon
from breed import breed

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


randomLexicon = sampleLexicon()
print "Random lexicon score:"
prand = posteriorScore(randomLexicon, corpus)
print prand
print

mapto2 = Lexicon(gold.words, [2]*gold.getLen())
print "ALL WORDS MAP TO 2 score:"
pto2 = posteriorScore(mapto2, corpus)
print pto2
print

print "Gold score:"
pgold = posteriorScore(gold, corpus)
print pgold


print
print "Breeded score:"
# breed(0, 1, [gold, mapto2], [0]*2)
print posteriorScore(gold, corpus)

print fScore(mapto2)
