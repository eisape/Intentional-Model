from world import world, corpus
from random import choice
from scoreLexicon import posteriorScore
from mutate import mutate
from params import num_iterations
import params
from pprint import pprint
from pyro.distributions import Bernoulli
import utils
from goldstandard import gold
from sampleLexicon import sampleLexicon
import sys
from multiprocessing import Pool

def runModel():
    lexs = [sampleLexicon(), sampleLexicon()]
    scores = [posteriorScore(lexs[0], corpus)]*2
    temps = [1, 10]
    names = ['low temp', 'high temp']

    print "alpha:", params.alpha
    print "gamma:", params.gamma
    print "kappa:", params.kappa
    print "num_iterations:", num_iterations
    print "temps:", temps

    print "Initial score:", scores[0]
    print "Initial lexicon:"
    utils.printLex(lexs[0])

    bestLex = lexs[0]
    bestScore = scores[0]

    for i in range(num_iterations):
        if i%100==0:
            lexs[0] = bestLex
            scores[0] = bestScore

        if i%500==0:
            print "Reached iteration\t", i, "\tlow temp score:", scores[0], "\thigh temp score:\t", scores[1]
            if i%1000==0:
                print "Current best lexicon:"
                utils.printLex(bestLex)

        for j in range(len(lexs)):
            lex = lexs[j]
            score = scores[j]
            temp = temps[j]

            newLex = mutate(lex, temp)
            newScore = posteriorScore(lex, corpus)

            prob = min(newScore/score, 1)
            if bool(Bernoulli(probs=prob).sample()):
                lexs[j] = newLex
                scores[j] = newScore
                if newScore > bestScore:
                    diff = newScore-bestScore
                    bestLex = newLex
                    bestScore = newScore
                    print "New high score!\t", bestScore, "\tdiscovered by:\t", names[j], "\tdiff\t", diff
                    if j != 0:
                        lexs[0] = bestLex
                        scores[0] = bestScore

    return (bestLex, bestScore)

def runOvernight(i):
    try:
        sys.stdout = open('model%d.log'%i, 'w+')
        lex, score = runModel()
        print "All finished!"
        print "Score:", score
        utils.printLex(lex)
    except Exception as e :
        print e
        return

if __name__=='__main__':
    f = runOvernight
    Pool(10).map(f, range(10))

# lex, score = runModel()
# print
# print "All finished!"
# print "Score:", score
# utils.printLex(lex)
