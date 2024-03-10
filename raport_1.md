# Problem analysis
## Problem definition:
The set of operators defined in MEOW is very narrow and should be extended 
to be able to represent more complex algorithms.

## List of implemented operators:

# Crossovers
- uniform
- single-point
- multi-point
- blend-alpha (BLX-alpha)
- simulated binary (SBX)
- order {permutation}
- linear-order {permutation}

# Mutations
- replace-uniform
- bit-flip
- shift-gaussian
- inversion {permutation}
- swap {permutation}

# Selections
- tournament
- natural
- roulette
- stochastic-universal-sampling

## List of other common operators in similar frameworks

# Crossovers
- binomial
- differential (DEX)
- edge-recombination (ERX)
- exponential (EXPX)
- half-uniform (HUX)
- parent-centric (PCX)

# Mutations
- polynomial (PM)
- choice-random (RM)

# Selections
MEOW has more selection methods implemented compared to other analyzed 
frameworks.

Due to lack of the preceding operators some algorithms cannot be implemented, 
for example Differential Evolution.

## Current implementation structure
Every mutation, crossover, selection, etc. is wrapped in Op struct 
and then added to the pipeline.

In a pipeline operations are executed sequentially and there can be 
more than one population that specimens can migrate between.