defmodule MeowNx.Mutation do
  @moduledoc """
  Numerical implementations of common mutation operations.

  Mutation is a genetic operation that randomly alters genetic
  information of some individuals within the population, usually
  according to a fixed probability.

  Mutation is used to maintain genetic diversity within the population
  as it steps from one generation to another. It effectively introduces
  a bit of additional randomness to the evolutionary algorithm, so that
  more diversified solutions are explored. It may also help to reduce
  too rapid convergence of the algorithm to a local minimum.
  """

  import Nx.Defn

  @two_pi 2 * :math.pi()

  @doc """
  Performs simple uniform replacement mutation.

  Replaces every mutated gene with a random value drawn
  uniformly from the given range.

  Every gene has the same chance of mutation,
  configured with `probability`.

  ## Options

    * `:probability` - the probability of each gene
      getting mutated. Required.

    * `:min` - the lower bound of the range to draw from.
      Required.

    * `:min` - the upper bound of the range to draw from.
      Required.
  """
  defn replace_uniform(genomes, opts \\ []) do
    opts = keyword!(opts, [:probability, :min, :max])
    probability = opts[:probability]
    min = opts[:min]
    max = opts[:max]

    shape = Nx.shape(genomes)

    # Mutate each gene separately with the given probability
    mutate? = Nx.random_uniform(shape) |> Nx.less(probability)
    mutated = Nx.random_uniform(shape, min, max)
    Nx.select(mutate?, mutated, genomes)
  end

  defn parasitism_mutation(genomes) do
    {n, _length} = Nx.shape(genomes)
    genomes_copy = Nx.take(genomes, Nx.random_uniform({n}, 0, n), axis: 0)

    mutated_genomes = replace_uniform(genomes_copy, [probability: 0.001, min: -5.12, max: 5.12])  # arg

    Nx.concatenate([genomes, mutated_genomes]) |> MeowNx.Utils.interleave_rows()
  end

  defn whale_mutation(genomes, best_individual, iteration, max_iterations, b, min_clip, max_clip) do
    {n, length} = Nx.shape(genomes)
    c = Nx.random_uniform({n, 1}, 0.0, 2.0)
    coeff = (2 * (max_iterations - iteration) / max_iterations)
    a = Nx.random_uniform({n, 1}, -coeff, coeff)
    l = Nx.random_uniform({n, 1}, -1.0, 1.0)
    p = Nx.random_uniform({n, 1})

    case_second_genomes = a
    |> Nx.abs()
    |> Nx.less(0.5)
    |> Nx.broadcast({n, length})
    |> Nx.select(best_individual, Nx.take(genomes, Nx.random_uniform({n}, 0, n), axis: 0))
    ad = c
    |> Nx.multiply(case_second_genomes)
    |> Nx.subtract(genomes)
    |> Nx.abs()
    |> Nx.multiply(a)
    inner_swap = Nx.subtract(case_second_genomes, ad)

    bubble_attack =
      best_individual
      |> Nx.subtract(genomes)
      |> Nx.abs()
      |> Nx.multiply(Nx.exp(b * l) * Nx.cos(@two_pi * l))
      |> Nx.add(best_individual)

    p
    |> Nx.less(0.5)
    |> Nx.broadcast({n, length})
    |> Nx.select(inner_swap, bubble_attack)
    |> Nx.clip(min_clip, max_clip)
  end

  @doc """
  Performs bit-flip mutation.

  ## Options

    * `:probability` - the probability of each gene
      getting mutated. Required.
  """
  defn bit_flip(genomes, opts \\ []) do
    opts = keyword!(opts, [:probability])
    probability = opts[:probability]

    shape = Nx.shape(genomes)

    # Mutate each gene separately with the given probability
    mutate? = Nx.random_uniform(shape) |> Nx.less(probability)
    mutated = Nx.subtract(1, genomes)
    Nx.select(mutate?, mutated, genomes)
  end

  @doc """
  Performs Gaussian shift mutation.

  Adds a random value to every mutated gene.
  The value is drawn from a normal distribution
  with mean 0 and the specified standard deviation.

  Every gene has the same chance of mutation,
  configured with `probability`.

  ## Options

    * `:probability` - the probability of each gene
      getting mutated. Required.

    * `:sigma` - standard deviation of the normal
      distribution used for mutation. Defaults to 1.

  ## References

    * [Adaptive Mutation Strategies for Evolutionary Algorithms](https://www.dynardo.de/fileadmin/Material_Dynardo/WOST/Paper/wost2.0/AdaptiveMutation.pdf), Section 3.1
  """
  defn shift_gaussian(genomes, opts \\ []) do
    opts = keyword!(opts, [:probability, sigma: 1.0])
    probability = opts[:probability]
    sigma = opts[:sigma]

    shape = Nx.shape(genomes)

    # Mutate each gene separately with the given probability
    mutate? = Nx.random_uniform(shape) |> Nx.less(probability)
    mutated = genomes + Nx.random_normal(shape, 0.0, sigma)
    Nx.select(mutate?, mutated, genomes)
  end
end
