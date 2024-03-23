# Algorithms analysis
We analyzed various algorithms in terms of difficulty of potential assimilation to Meow library architecture and grouped them in 4 sets.

## Algorithms with single specimen population
That is the most specific of the groups. It consists of algorithms which in every iteration have population equal to one and in most cases (except Basin hopping), it needs to store global state.

### Basin hopping
- temperature schedule can be generated using generation number
- perturb is a kind of crossover
- single specimen population
- accept is a kind of selection

### double_annealing
- has global state (temperature)
- single specimen population

### tabu search
- has global state (list of previous specimens)
- single specimen population
- what is a neighbor (needs specification)

## Promising algorithms
Algorithms in this group are almost certain to be possible to implement as part of Meow library. In most cases it just needs the implementation of certain crossover specific for this exact algorithm.

### Direct
- selects hyper-rectangles and splits them
- needs new crossover

### symbiotic organism search
- requires best specimen
- has 3 stages, each executed for each specimen and a random other one
- mutualism - both specimens are updated based on each other (crossover)
- commensalism - one specimen is updated based on the other (crossover)
- parasitism - a choice is made between one specimen and a mutation of the other (mutation and selection) 

### bat algorithm
- requires best specimen
-  bats move with some velocity
- velocity is dependent on old velocity and random vector
- position is dependent on old position and velocity

## Hard to describe algorithms
These proved to be hard to comprehend despite long search through the internet. Shgo implementation in other languages has really complicated code which span across multiple files, which makes it hard to analyze. Moreover, the only somewhat described repositories are clones of scipy which is not the best implementation. Harmony search seems to be somewhat promising, but it is unknown for us by now if selection is specific for this algorithm or not. 

### shgo
- couldn’t find readable documentation 

### harmony search
- easy implementation at first glance
- basically, consist only of specimen transformation in one of three ways
- although selection method is unclear 

## Potential algorithms to implement with certain difficulties
These algorithms look promising, but implementation seems complicated in some places, for example crossover implementation that takes another crossover as argument (differential algorithm)

### whale optimization algorithm
- requires best specimen
- specimens are updated based on the best specimen and a random vector

### Differential
- combines 3 specimens before crossing them over with another one
- differential crossover has another crossover as a parameter

### teaching-learning-based optimization
- requires best specimen
- requires 2 new crossovers
- specimens learn from each other and from the teacher (best specimen)
- updates specimens one by one

### gray-wolf algorithm
- similar to whale optimization
- specimens are updated based on 3 best specimens instead of 1
