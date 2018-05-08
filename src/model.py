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
import numpy as np

def runModel():
    lexs = [sampleLexicon(), sampleLexicon()]
    scores = [posteriorScore(lexs[0], corpus), posteriorScore(lexs[1], corpus)]
    names = ['sticky', 'MH']
    numAccepted = [0, 0]

    interval = 50

    print "alpha:", params.alpha
    print "gamma:", params.gamma
    print "kappa:", params.kappa
    print "num_iterations:", num_iterations

    print "Initial score:", scores[0]
    print "Initial lexicon:"
    utils.printLex(lexs[0])

    bestLex = lexs[0]
    bestScore = scores[0]
    icons = ['\\', '|', '/', '-']
    iconIdx = 0
    lastPrinted = bestLex

    sys.stdout.write(icons[iconIdx])
    for i in range(num_iterations):
        iconIdx = (iconIdx+1)%4
        sys.stdout.write('\b')
        sys.stdout.write(icons[iconIdx])
        sys.stdout.flush()

        if i%300==0:
            lexs[0] = bestLex
            scores[0] = bestScore

        if i%interval==0:
            sys.stdout.write('\b')
            print "Reached iteration\t", i
            print "\tsticky \tscore:", scores[0], "\tlen:", lexs[0].getLen(), "\tnum accepted:", numAccepted[0], "/", interval
            print "\tMH \tscore:", scores[1], "\tlen:", lexs[1].getLen(), "\tnum accepted:", numAccepted[1], "/", interval
            numAccepted = [0, 0]
            if i%250==0 and cmp(lastPrinted, bestLex)!=0:
                print "Current best lexicon (score = %d, len = %d):"%(bestScore, bestLex.getLen())
                print "F-score: %f, precision: %f, recall: %f"%utils.fScore(bestLex)
                utils.printLex(bestLex)
                lastPrinted = bestLex

        for j in range(len(lexs)):
            lex = lexs[j]
            score = scores[j]
            temp = 6000

            newLex = mutate(lex)
            newScore = posteriorScore(newLex, corpus)

            prob = np.exp(newScore - score) if newScore<score else 1 # Scores are in log space
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

lex, score = runModel()
print
print "All finished!"
print "Score:", score
utils.printLex(lex)
