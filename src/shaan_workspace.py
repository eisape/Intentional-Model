from pprint import pprint
from world import world, corpus

# # Tests construction of the world
# print world.words_key
# print world.num_words
# print world.words
# print world.words_freq
# print
print world.objects_key
# print world.num_objects
# print world.objects
# print world.objects_freq

#Tests construction of the corpus
for s in corpus:
    print s.objects
