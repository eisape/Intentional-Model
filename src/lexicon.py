class Lexicon:
    def __init__(self, words=None, objects=None):
        self.words = [] if words==None else words
        self.objects = [] if objects==None else objects

    def getEntries(self):
        return range(len(self.words))

    def getLen(self):
        return len(self.words)

    def wordMapsToObj(self, word, obj):
        for i in self.getEntries():
            w = self.words[i]
            o = self.objects[i]
            if w == word and o == obj:
                return True
        return False

    def duplicate(self):
        return Lexicon(self.words[:], self.objects[:])

    def addPair(self, word, obj):
        self.words.append(word)
        self.objects.append(obj)

    def getPairByIdx(self, i):
        return (self.words[i], self.objects[i])

    def deletePair(self, word, obj):
        # Ignores operation if pair isn't present
        for i in self.getEntries():
            w = self.words[i]
            o = self.objects[i]
            if w == word and o == obj:
                self.words.pop(i)
                self.objects.pop(i)
                return None
        return None

    def deleteByIdx(self, i):
        self.words.pop(i)
        self.objects.pop(i)
        return None

    def clearDuplicates(self):
        # Eliminates duplicate entries
        pairs = []
        toDelete = []
        for i in self.getEntries():
            pair = self.getPairByIdx(i)
            if pair in pairs:
                toDelete.append(i)
            else:
                pairs.append(pair)
        for i in toDelete:
            self.deleteByIdx(i)
            for j in range(len(toDelete)):
                toDelete[j] = toDelete[j]-1
        return None
