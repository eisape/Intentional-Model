from pprint import pprint
from world import world, corpus

pprint(world.words_key)
print world.num_words
print world.words
print world.words_freq

pprint(world.objects_key)
print world.num_objects
print world.objects
print world.objects_freq

for i in range(len(world.objects_freq)):
    print i, '\t', world.objects_key[i], '\t', world.objects_freq[i]


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
