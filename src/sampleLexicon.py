from world import world
from random import choice

def sampleLexicon(lengths=0):
    # Input: lengths as list of integers
    # Generates a purely random lexicon of length randomly drawn from lengths list
    if lengths==0:
        lengths = range(30,40)
    lex = {}
    size = choice(lengths)
    for i in range(size):
        w = choice(world.words)
        o = choice(world.objects)
        lex[w] = o
    return lex
