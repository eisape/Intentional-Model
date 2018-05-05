from situation import Situation
from pyro.distributions import Categorical
import torch

class World:
    def __initKey(self, filename):
        # Input: filename of the word/object file
        # Output: words key as list, frequencies as list
        freqs = []
        f = open(filename, 'r')
        added = []
        i = 0
        for line in f.readlines():
            for word in line.replace('\t','').replace('\n','').split(' '):
                if word == '': continue
                if word not in added:
                    added.append(word)
                    freqs.append(1)
                    i += 1
                else:
                    freqs[added.index(word)] += 1
        f.close()
        return added, freqs

    def __init__(self, wordFile, objectFile):
        # Input: filenames of word and object files
        self.words_key, self.words_freq = self.__initKey(wordFile)
        self.num_words = len(self.words_key)
        self.words = range(self.num_words)

        self.objects_key, self.objects_freq = self.__initKey(objectFile)
        self.num_objects = len(self.objects_key)
        self.objects = range(self.num_objects)

        self.mis = []
        self.word_object_pairs = [] # NB: word-object pairs are stored as a tuple (word, object)

    def makeMIs(self, corpus):
        # Input: corpus as list of situations
        # Updates self.mis and self.word_object_pairs to contain probability weights
        word_counts = {}
        obj_counts = {}
        word_obj_counts = {}

        for word in self.words:
            word_counts[word] = 0
            for obj in self.objects:
                obj_counts[obj] = 0
                word_obj_counts[(word, obj)] = 0

        for situation in corpus:
            for word in situation.words:
                word_counts[word] += 1
                for obj in situation.objects:
                    obj_counts[obj] += 1
                    word_obj_counts[(word, obj)] += 1

        for word, obj in word_obj_counts.keys():
            pair = (word, obj)
            self.word_object_pairs.append(pair)
            mi = float(word_obj_counts[pair])/(word_counts[word] * obj_counts[obj])
            self.mis.append(mi)

def processLine(s):
    # Helper function
    return s.replace('\t', '').replace('\n', '')

def makeCorpus(world, wordFile, objectFile):
    # Input: World object, filenames of word and object files
    # Output: Corpus as list of Situations
    corpus = []
    wf = open(wordFile, 'r')
    of = open(objectFile, 'r')

    wl = wf.readline()
    ol = of.readline()
    while(len(wl)!=0 and len(ol)!=0):
        wl = processLine(wl)
        ol = processLine(ol)

        words = [world.words_key.index(x) for x in wl.split(' ') if x!='']
        objects = [world.objects_key.index(x) for x in ol.split(' ') if x!='']
        corpus.append(Situation(words, objects))

        wl = wf.readline()
        ol = of.readline()
    return corpus

wordFile = "words.txt"
objectFile = "objects.txt"

world = World(wordFile, objectFile)
corpus = makeCorpus(world, wordFile, objectFile)
world.makeMIs(corpus)

# print world.mis
# print world.word_object_pairs
