from world import world, corpus
from random import choice
from scoreLexicon import posteriorScore
from mutate import mutate
from params import num_iterations
from pprint import pprint
from pyro.distributions import Bernoulli
import utils
from goldstandard import gold
from sampleLexicon import sampleLexicon

def runModel():
    lex = sampleLexicon()
    score = posteriorScore(lex, corpus)

    print "Initial score:", score
    print "Initial lexicon:"
    utils.printLex(lex)

    bestLex = lex
    bestScore = score

    for i in range(num_iterations):
        if i%100==0:
            print "Reached iteration", i
            if i%1000==0:
                print "Current best score:", bestScore
                print "Current best lexicon:"
                utils.printLex(bestLex)
        newLex = mutate(lex)
        newScore = posteriorScore(lex, corpus)

        prob = min(newScore/score, 1)
        if bool(Bernoulli(probs=prob).sample()):
            lex = newLex
            score = newScore
            if score > bestScore:
                bestLex = lex
                bestScore = score

    return (bestLex, bestScore)

lex, score = runModel()
print
print "All finished!"
print "Score:", score
utils.printLex(lex)
