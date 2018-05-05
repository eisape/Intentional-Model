# Hand-coded gold standard lexicon
from world import world

def makeGold(world):
    gold = {}
    english = {
        "baby": "baby",
        "bigbird": "bird",
        "bird": "bird",
        "books": "book",
        "bunnyrabbit": "bunny",
        "cows": "cow",
        "moocows": "cow",
        "duckie": "duck",
        "hand": "hand",
        "kitty": "kitty",
        "kittycats": "kitty",
        "lambie": "lamb",
        "pig": "pig",
        "piggies": "pig",
        "ring": "ring",
        "sheep": "sheep",
        "birdie": "duck",
        "bear": "bear",
        "bigbirds": "bird",
        "book": "book",
        "cow": "cow",
        "moocow": "cow",
        "duck": "duck",
        "eyes": "eyes",
        "hat": "hat",
        "kittycat": "kitty",
        "lamb": "lamb",
        "mirror": "mirror",
        "piggie": "pig",
        "rattle": "rattle",
        "rings": "ring",
        "bunnies": "bunny",
        "bird": "duck"
    }
    for key in english:
        gold[world.words_key.index(key)] = world.objects_key.index(english[key])
    return gold

gold = makeGold(world)
