from situation import Situation

class WorldObj:
    def __initKey(self, filename):
        # Input: filename of the word/object file
        # Output: int index->string word key
        freqs = []
        key = {}
        f = open(filename, 'r')
        added = []
        i = 0
        for line in f.readlines():
            for word in line.replace('\t','').replace('\n','').split(' '):
                if word == '': continue
                if word not in added:
                    key[i] = word
                    added.append(word)
                    freqs.append(1)
                    i += 1
                else:
                    freqs[added.index(word)] += 1
        f.close()
        return key, freqs

    def __init__(self, wordFile, objectFile):
        self.words_key, self.words_freq = self.__initKey(wordFile)
        self.num_words = len(self.words_key)
        self.words = range(self.num_words)

        self.objects_key, self.objects_freq = self.__initKey(objectFile)
        self.num_objects = len(self.objects_key)
        self.objects = range(self.num_objects)

        # self.mis: []

def processLine(s):
    return s.replace('\t', '').replace('\n', '')

def makeCorpus(wordFile, objectFile):
    # Input: filenames of word and object files
    # Output: Corpus as list of Situations
    corpus = []
    wf = open(wordFile, 'r')
    of = open(objectFile, 'r')

    wl = wf.readline()
    ol = of.readline()
    while(len(wl)!=0 and len(ol)!=0):
        wl = processLine(wl)
        ol = processLine(ol)

        words = [x for x in wl.split(' ') if x!='']
        objects = [x for x in ol.split(' ') if x!='']
        corpus.append(Situation(words, objects))

        wl = wf.readline()
        ol = of.readline()
    return corpus

wordFile = "words.txt"
objectFile = "objects.txt"

world = WorldObj(wordFile, objectFile)
corpus = makeCorpus(wordFile, objectFile)
