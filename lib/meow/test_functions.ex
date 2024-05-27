defmodule Meow.TestFunctions do
  import Nx.Defn

  @spec size() :: 100
  def size, do: 100

  def lower_bound, do: -10

  def upper_bound, do: 10

  @two_pi 2 * :math.pi()
  @e :math.exp(1)


  @vector 5

  defn evaluate_rastrigin(genomes) do

    sums =
      (10 + Nx.power(genomes, 2) - 10 * Nx.cos((genomes) * @two_pi))
      |> Nx.sum(axes: [1])

    -sums
  end

  defn rastrigin_translated(genomes) do
    evaluate_rastrigin(genomes - @vector)
  end

  defn ackley(genomes) do
    {_, genome_length} = Nx.shape(genomes)

    -20 * Nx.exp(0.2 * Nx.sqrt(Nx.sum(genomes ** 2, axes: [1]) / genome_length)) - Nx.exp(Nx.sum(Nx.cos(genomes * @two_pi), axes: [1]) / genome_length) + 20 + @e
  end

  defn ackley_translated(genomes) do
    ackley(genomes - @vector)
  end

  defn zakharov(genomes) do
    {n, genome_length} = Nx.shape(genomes)
    a = Nx.sum(genomes ** 2, axes: [1])
    b = Nx.sum(genomes * (Nx.iota({n, genome_length}, axis: 1) + 1), axes: [1]) / 2

    -(a + b ** 2 + b ** 4)
  end

  defn griewank(genomes) do
    {n, genome_length} = Nx.shape(genomes)
    a = Nx.sum(genomes ** 2, axes: [1]) / 4000
    b = Nx.product(Nx.cos(genomes / (Nx.iota({n, genome_length}, axis: 1) + 1) ** 0.5))
    -(a - b + 1)
  end

  defn griewank_translated(genomes) do
    griewank(genomes - @vector)
  end

  defn zakharov_translated(genomes) do
    zakharov(genomes - @vector)
  end


  defn styblinski_tang(genomes) do
    Nx.sum(
    genomes ** 4 - 16 * genomes ** 2 + 5 * genomes,
    axes: [1]
    ) / -2
  end

  defn schwefel(genomes) do
    {_, genome_length} = Nx.shape(genomes)

    sums = 418.9829 * genome_length - Nx.sum(
      genomes * Nx.sin(Nx.sqrt(Nx.abs(genomes))),
      axes: [1]
    )

    -sums
  end

  defn rosenbrock(genomes) do
    {_, genome_length} = Nx.shape(genomes)

    x_i = Nx.slice_along_axis(genomes, 0, genome_length - 1, axis: 1)
    x_i_1 = Nx.slice_along_axis(genomes, 1, genome_length - 1, axis: 1)

    a = 100 * (x_i_1 - x_i ** 2) ** 2
    b = (1 - x_i) ** 2

    -Nx.sum(a + b, axes: [1])
  end
end
