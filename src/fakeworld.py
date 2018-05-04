from situation import Situation
# Testing data

words = range(9)
words_key = ['ball', 'bat', 'ballie', 'look', 'at', 'this', 'i', 'like', 'toy']
#              0      1        2        3       4     5      6     7        8
numWords = 9

objects = range(4)
objects_key = ['ball', 'toy', 'face', 'bat']
#                0       1       2      3
num_objects = 4

words_freq = [1, 1]
# objects_freq = [5, 18, 14 134 113 15 21 67 75 19 5 15 102 43 25 11 15 28 140 199 175 12 15]
# mis: []

# [ball toy face] [ball toy bat]

corpus = [
    Situation([3, 4, 5, 0], [0, 1, 2]),
    # Situation([3, 4, 5, 1], [0, 1, 3]),
    # Situation([6, 7, 5, 2], [0, 3, 2])
]
