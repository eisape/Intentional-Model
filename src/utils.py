from world import world
from pprint import pprint
from goldstandard import gold

def printLex(lex):
    english = {}
    for key in lex:
        value = lex[key]
        english[world.words_key[key]] = world.objects_key[value]
    pprint(english)
