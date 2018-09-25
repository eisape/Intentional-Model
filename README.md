# Bayesian Language Learner
Author: Tiwalayo Eisape

## About this project
This repository contains Tiwalayo Eisape's final project for the Computational Models of Cognition course at Boston College, written in May 2018. The project replicates the methods found in the study "Using Speakers' Referential Intentions to Model Early Cross-Situational Word Learning" by Frank et al., which can be found [here](https://doi.org/10.1111%2Fj.1467-9280.2009.02335.x).

The code models the way infants can infer a speaker's "referential intentions" with no prior knowledge of the language. More precisely, it takes as input a script of sentences said by a mother to her child and the objects that were in the infant's view during each sentence (the model in  this repository operates on the same dataset as in Frank et al., which is the transcript of an actual mother-child interaction). Given this input, the model attempts to infer which nouns refer to which object. Thus, the algorithm is faced with two simultaneous problems: determining which words are nouns, and determining which nouns refer to which objects.

The model searches for the optimal lexicon (set of object-word pairings) using Metropolis-Hastings MCMC sampling. Essentially, at each time-step, the code randomly mutates its current lexicon and computes a "score" for that lexicon, i.e. how well the lexicon explains the data. The model will decided whether to adopt the new lexicon based on a random formula that is influenced by the comparison of the current score and the new one.

## Getting Started
To run the model, clone this repository. You can use pip to install its dependencies using ``pip install -r requirements.txt`` (note: it' recommended to use a virtual enivironment manager for Python to avoid conflicting dependencies and other issues).

Once the dependencies are installed, run the model with the command: ``python model.py``. As the model runs, it will output to the console periodically at predefined intervals, as well as whenever a new best-performing lexicon is discovered, along with some useful information like the lexicon's posterior score and F-score compared to the hand-coded gold standard in the Frank et al. paper.
