# Meow testing on GPU
We tried to run the same algorithmy on both GPU and CPU, here are the results.

## Summary on GPU
18:40:43.135 [info] successful NUMA node read from SysFS had negative value (-1), but there must be at least one NUMA node, so returning NUMA node zero
18:40:43.141 [info] XLA service 0x7ff5307dd630 initialized for platform CUDA (this does not guarantee that XLA will be used). Devices:
18:40:43.141 [info] StreamExecutor device (0): NVIDIA GeForce GTX 1060 with Max-Q Design, Compute Capability 6.1
18:40:43.141 [info] Using BFC allocator.
18:40:43.141 [info] XLA backend allocating 5582861107 bytes on device 0 for BFCAllocator.

──── Summary ────

Total time: 5.138s
Populations: 1
Population time (mean): 4.69s
Generations (mean): 5000

──── Best individual ────

Fitness: -9.508065021428084
Generation: 4992
Genome: #Nx.Tensor<
  f64[100]
  [0.005285739898681641, -0.03413820266723633, -0.005744457244873047, 0.01862812042236328, -0.021018028259277344, 0.008717365553470025, -0.0021886825561523438, -0.049019813537597656, -0.0011754035949707031, 0.0025877952575683594, -7.309913635253906e-4, -0.018687725067138672, 0.015357494354248047, -0.02369403839111328, -0.06533193588256836, -0.015707969665527344, -0.02059316635131836, -0.03024435043334961, -7.910728454589844e-4, 0.026046276092529297, -0.010030746459960938, 9.303092956542969e-4, -0.006515979766845703, -0.0011620521545410156, 0.007817268371582031, 0.008418083190917969, -1.9407272338867188e-4, 0.0059337615966796875, 0.05737447738647461, 0.01733541488647461, 0.009860992431640625, 0.006227016448974609, 0.0035009384155273438, -0.02807760238647461, -0.005374908447265625, -0.0053882598876953125, -0.005047798156738281, 0.04808855056762695, -0.01926136016845703, 0.009390830993652344, -0.010098934173583984, 0.023197174072265625, 0.05555152893066406, -0.0037403106689453125, 0.005841255187988281, -0.027824878692626953, -0.0506443977355957, -0.029887676239013672, -0.010825157165527344, -0.016715049743652344, ...]
>

## Summary on CPU
──── Summary ────

Total time: 150.348s
Populations: 1
Population time (mean): 150.181s
Generations (mean): 5000

──── Best individual ────

Fitness: -11.700291115894657
Generation: 4917
Genome: #Nx.Tensor<
  f64[100]
  [-0.009693155065178871, -0.009724038653075695, -0.014836268499493599, 0.004234509076923132, -0.049656741321086884, -0.002934190910309553, 0.012495839037001133, -3.841124416794628e-4, 0.0340319387614727, -0.009237835183739662, -0.0010173225309699774, -8.143034065142274e-4, -0.03498675301671028, 0.014963219873607159, 0.005305716302245855, 0.00511252973228693, -0.016604706645011902, 0.0020147545728832483, -0.020471995696425438, -0.006788903381675482, -0.010308688506484032, 0.03972825035452843, 0.02623126097023487, 0.03284185007214546, -9.853619121713564e-5, 0.0010582883842289448, -0.016484661027789116, 0.007871180772781372, 0.010069001466035843, -0.02095317840576172, -0.009150027297437191, 0.0033709595019821847, -0.01080041378736496, -0.018506508320569992, -0.002900685416534543, -0.02499440684914589, 0.9937336444854736, -0.06750887632369995, 1.3518991181626916e-4, 0.027394786477088928, 0.011238016188144684, -0.021565258502960205, 0.026595454663038254, 0.011028596200048923, -0.0010787007631734014, -0.023101195693016052, 0.0037404615432024, 0.01474833209067583, 0.01888209953904152, -0.01006899680942297, ...]
>

## Conclusion
The main difference between both outcomes is the time it takes to run an algorithm. On given sample we can see that GPU is aproximetely 30 times faster.

# Attempts of implementing algorithms

## Bat optimisation
We started with intend to implement a Bat Optimization but soon saw that this demands a specific population implementation due to necessity of passing to further generations velocities, rate, and loudness of bats. That was not consistent with the standard of library where everything more than implementation specific, should be reusable, and possible to apply for multiple algorithms. Due to that reasons, we stopped on an idea to develop bat optimizations and proceeded to another algorithm.

## Differential Evolution
After analyzing the Bat Optimization we started to work on Differential Evolution. We practically finished it, but on the last step we encountered a problem - how to create a tensor with rows based on another tensor. We could not use pure elixir functions due to function being of type defn which forbids usage of a lot of functions inside (basically all Enum and some Nx). After long brainstorm, we came to the conclusion that with the current project version of Nx (0.3) it is impossible or nearly impossible to construct the algorithm in the way we tried. In version 0.3 function vectorize that could help is not present and to_batched function that also could be solution cannot be used in defn function definition. Due to these reasons, it is not possible to use any variation of map function on tensor rows. The most promising solution is to bump Nx to version 0.7, but that would take a lot of effort to assimilate already implemented operations and utilities to standard of Nx 0.7 where a lot of past functions are absent and/or replaced by the new ones.

# List of algorithms sorted by assumed complexity
- symbiotic organism search (simplified mutualism - update in pairs)
- whale optimization algorithm
- gray-wolf algorithm
- bat algorithm (not reusable population representation)
- harmony search
- teaching-learning-based optimization (spaciman are updated sequentially - GPU sad, maybe parallel implementation ??)
- differential (function used on each row, requires bump of Nx)
- basin hopping (maybe CPU faster)
- double annealiung (maybe CPU faster, need global state)
- tabu search (maybe CPU faster, need global state)
- direct (population size growing constantly - GPU sad)
- shgo (how it works again?)
