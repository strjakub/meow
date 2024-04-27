# Install Meow and Nx for numerical computing

Mix.install([
  {:meow, "~> 0.1.0-dev", github: "strjakub/meow", branch: "main"},
  {:nx, "~> 0.3.0"},
  {:vega_lite, "~> 0.1.1"},
  {:jason, "~> 1.4"},
  # {:exla, "~> 0.3.0"}
])

# Nx.Defn.global_default_options(compiler: EXLA)

# Define the evaluation function, in this case using Nx to work with MeowNx

defmodule Problem do
  import Nx.Defn

  def size, do: 100

  @two_pi 2 * :math.pi()

  defn evaluate_rastrigin(genomes) do
    sums =
      (10 + Nx.power(genomes, 2) - 10 * Nx.cos(genomes * @two_pi))
      |> Nx.sum(axes: [1])

    -sums
  end
end

# Define the evolutionary algorithm

algorithm =
  Meow.objective(
    # Specify the evaluation function that we are trying to maximise
    &Problem.evaluate_rastrigin/1
  )
  |> Meow.add_pipeline(
    # Define how the population is initialized and what representation to use
    MeowNx.Ops.init_real_random_uniform(100, Problem.size(), -5.12, 5.12),
    # A single pipeline corresponds to a single population
    Meow.pipeline([
      # Define a number of evolutionary steps that the population goes through
      MeowNx.Ops.whale(5_000),
      MeowNx.Ops.log_metrics(
        %{
          fitness_max: &MeowNx.Metric.fitness_max/2,
          fitness_mean: &MeowNx.Metric.fitness_mean/2,
          fitness_sd: &MeowNx.Metric.fitness_sd/2
        },
        interval: 100
      ),
      Meow.Ops.max_generations(5_000)
    ])
  )

# Execute the above algorithm

report = Meow.run(algorithm)
%{population_reports: [%{population: population}]} = report

IO.puts("\nLogged metrics:")
IO.inspect(population.log.metrics)

report_path = Path.expand("tmp/report.html")
report_path |> Path.dirname() |> File.mkdir_p!()
:ok = Meow.Report.export_html(report, report_path)
IO.puts("Report saved to #{report_path}")
