class WorldObj:
    def __initKey(self, filename):
        key = {}
        f = open(filename, 'r')
        added = set()
        i = 0
        for line in f.readlines():
            for word in line.replace('\t','').replace('\n','').split(' '):
                if word not in added:
                    key[i] = word
                    added.add(word)
                    i += 1
        return key

    def __init__(self):
        wordFile = "words.txt"
        objectFile = "objects.txt"
        self.words_key = self.__initKey(wordFile)
        self.numWords = len(self.words_key)
        self.words = range(self.numWords)

        self.objects_key = self.__initKey(objectFile)
        self.numObjects = len(self.objects_key)
        self.objects = range(self.numObjects)
        #
        # self.words_freq = []
        # self.objects_freq = [5 18 14 134 113 15 21 67 75 19 5 15 102 43 25 11 15 28 140 199 175 12 15]
        # self.mis: []
        #
        # self.alpha = 0.1
        # self.gamma = 0.1
        # self.kappa = 0
        #
        # self.script = "" # Every word that's said
        #

world = WorldObj()

# Testing data
#This is still pseudocode!
#
# words = range(3)
# words_key = {'ball': 0, 'bat': 1, 'ballie': 2}
# numWords = 3
#
# objects = range(4)
# objects_key = {
#     'ball': 0,
#     'toy': 1,
#     'face': 2,
#     'bat': 3
# }
# num_objects = 23
#
# words_freq = [1, 1]
# # objects_freq = [5, 18, 14 134 113 15 21 67 75 19 5 15 102 43 25 11 15 28 140 199 175 12 15]
# # mis: []
#
# script = "look at this ball now look at this bat" # Every word that's said
# # [ball toy face] [ball toy bat]
