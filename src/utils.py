from world import world
from pprint import pprint
from goldstandard import gold

def printLex(lex):
    print '{'
    for i in lex.getEntries():
        key = lex.words[i]
        value = lex.objects[i]
        word = world.words_key[key]
        obj = world.objects_key[value]
        print word + ': ' + obj
    print '}'

def fScore(lex, comparison=None):
    # Returns tuple containing (F-score, precision, recall)
    if comparison==None: comparison = gold
    truePositives = 0
    falseNegatives = 0
    for i in comparison.getEntries():
        w = comparison.words[i]
        o = comparison.objects[i]
        if w in lex.words and lex.wordMapsToObj(w, o):
            truePositives += 1
        else:
            falseNegatives += 1

    falsePositives = lex.getLen()-truePositives

    precision = float(truePositives) / (truePositives + falsePositives)
    recall = float(truePositives) / (truePositives + falseNegatives)
    if truePositives == 0: fscore = 0
    else: fscore = 2 * (precision * recall) / (precision + recall)

    return (fscore, precision, recall)
