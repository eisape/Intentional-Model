# Implementation of situation class

import numpy as np
from params import gamma
from itertools import chain, combinations

class Situation:
    def __powerset(self, iterable):
        # Input: iterable object
        # Output: iterator over power set of the object's contents
        # sourced from itertools documentation
        s = list(iterable)
        return chain.from_iterable(combinations(s, r) for r in range(len(s)+1))


    def __computeIntents(self):
        # Output: gamma_intents as NumPy matrix
        gamma_intents = []
        numCols = 1 + len(self.objects)
        for intent in self.__powerset(range(len(self.objects))):
            row = [0] * numCols
            n = len(intent)
            if n == 0:
                row[0] = 1
                gamma_intents.append(row)
                continue
            for i in intent:
                row[0] = 1 - gamma
                row[i+1] = 1.0 / n
            gamma_intents.append(row)
        return np.matrix(gamma_intents)

    def __init__(self, words, objects):
        # Input: words and objects as lists
        self.words = words # list
        self.objects = objects # list
        self.gamma_intents = self.__computeIntents() # NumPy Matrix
