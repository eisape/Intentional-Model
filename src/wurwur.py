from world import world, corpus
from random import choice
from scoreLexicon import posteriorScore
from mutate import mutate
from params import num_iterations
import params
from pprint import pprint
from pyro.distributions import Bernoulli
from breed import breed
import utils
from goldstandard import gold
from sampleLexicon import sampleLexicon
import sys
from multiprocessing import Pool
import numpy as np

def runModel():
    numModels = 5
    lexs = [sampleLexicon() for x in range(numModels)]
    scores = [posteriorScore(lex, corpus) for lex in lexs]
    names = ['temp 1', 'temp 2', 'temp 3', 'temp 4', 'temp 5']
    temps = [0.0001, 1, 10, 100, 1000]
    numAccepted = [0] * numModels

    print "alpha:", params.alpha
    print "gamma:", params.gamma
    print "kappa:", params.kappa
    print "num_iterations:", num_iterations

    bestLex = lexs[0]
    bestScore = scores[0]
    icons = ['\\', '|', '/', '-']
    iconIdx = 0
    lastPrinted = bestLex

    interval = 10

    sys.stdout.write(icons[iconIdx])
    for i in range(num_iterations):
        iconIdx = (iconIdx+1)%4
        sys.stdout.write('\b')
        sys.stdout.write(icons[iconIdx])
        sys.stdout.flush()

        if i%5==0:
            a = choice(range(numModels))
            b = choice(range(numModels))
            if a != b:
                breed(a, b, lexs, scores)
                sys.stdout.write('\b')
                print "Bred %s, %s"%(names[a], names[b])

        if i%interval==0:
            sys.stdout.write('\b')
            print "Reached iteration\t", i
            for j in range(numModels):
                print "\t", names[j], "\tscore:", scores[j], "\tlen: ", lexs[j].getLen(), "\tnum accepted:", numAccepted[j], "/", interval
            numAccepted = [0] * numModels
            if i%50==0 and cmp(lastPrinted, bestLex)!=0:
                print "Current best lexicon (score = %d, len = %d):"%(bestScore, bestLex.getLen())
                print "F-score: %f, precision: %f, recall: %f"%utils.fScore(bestLex)
                utils.printLex(bestLex)
                lastPrinted = bestLex

        for j in range(numModels):
            lex = lexs[j]
            score = scores[j]
            temp = temps[j]

            newLex = mutate(lex)
            newScore = posteriorScore(newLex, corpus)

            prob = np.exp((newScore - score)/temp) if newScore<score else 1 # Scores are in log space
            sys.stdout.write('\b')
            if bool(Bernoulli(probs=prob).sample()):
                numAccepted[j] += 1
                lexs[j] = newLex
                scores[j] = newScore
                if newScore > bestScore:
                    diff = newScore-bestScore
                    bestLex = newLex
                    bestScore = newScore
                    sys.stdout.write('\b')
                    print "New high score!\t", bestScore, "\tdiscovered by:\t", names[j], "\tlen:", bestLex.getLen(), "\tscore diff\t", diff, "\titeration:",i
                    print "\tF-score: %f, precision: %f, recall: %f"%utils.fScore(bestLex)
                    # if i>100:
                    #     utils.printLex(bestLex)
                    if j != 0:
                        lexs[0] = bestLex
                        scores[0] = bestScore

    return (bestLex, bestScore)

# def runOvernight(i):
#     try:
#         sys.stdout = open('model%d.log'%i, 'w+')
#         lex, score = runModel()
#         print "All finished!"
#         print "Score:", score
#         utils.printLex(lex)
#     except Exception as e :
#         print e
#         return
#
# if __name__=='__main__':
#     f = runOvernight
#     Pool(10).map(f, range(10))

lex, score = runModel()
print
print "All finished!"
print "Score:", score
print "F-score: %f, precision: %f, recall: %f"%utils.fScore(lex)
utils.printLex(lex)
