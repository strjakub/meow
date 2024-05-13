## Optimized functions

We changed the architecture for optimized functions to be available out of the box in the library, without need to implement them each time when we want to use one of the more popular ones. We included the below functions:
- rastrigin (previously only implemented in example file, not in library)
- translated rastrigin
- styblinski-tang
- schwefel
- rosenbrock

## Bug with whale

We had another problem in our application being that the size of the problem and number of iterations needed to be the same, otherwise there was an error. It turned out to be the same bug. More specifically, when these numbers were equal and the second bug did not appear, it was because the algorithm luckily did not need to make a broadcast. When numbers were different, the algorithm could not make a broadcast, which was basically column multiplication (we think that it can be an issue with old version of Nx). When we removed bug with size of problem, then whale algorithm started to work properly, although it still has high convergence, but it does not favor 0 anymore.

## Comparision with different CPU implementation

To show the operation of the two previous features, we compared our implementation of whale on schwefel problem with the same combination in pyMetaheuristic.

### Meow
──── Summary ────

Total time: 2.993s
Populations: 1
Population time (mean): 2.504s
Generations (mean): 1000

──── Best individual ────

Fitness: -5.535572927328758e-4
Generation: 969
Genome: #Nx.Tensor<
f64[100]
[420.96828048064975, 420.9682732655894, 420.9682658567377, 420.9682570173451, 420.9682692131335, 420.9682569291344, 420.9682987052949, 420.9682779497955, 421.0099234817171, 420.9682629323998, 420.96825738296803, 420.9683059699234, 420.9682586699501, 420.9682745747255, 420.96826208164606, 420.96830140309663, 420.96827390295, 420.9683276333096, 420.9682597116473, 420.96826694725354, 420.96826342927756, 420.968267787714, 420.968282845821, 420.9682650250233, 420.9682733390446, 420.9682660224847, 420.9682641885542, 420.96826321541226, 420.96826198582124, 420.9682594723427, 420.9682694422223, 420.96825764831397, 420.96825837738163, 420.96827845014553, 420.9682690516301, 420.9682688843613, 420.9683231786364, 420.96827033904196, 420.96827805561844, 420.9681943087541, 420.9682735562493, 420.9682792135041, 420.9683318271038, 420.9682735520411, 420.9682689903232, 420.9682707279208, 420.9682790091414, 420.9682585617715, 420.9682586833706, 420.9682672325032, ...]
>

### Metaheuristic

##### Implementation
```python
import time
import numpy as np
from pyMetaheuristic.algorithm import whale_optimization_algorithm
from pyMetaheuristic.test_function import schwefel

parameters = {
    "hunting_party": 50, 
    "spiral_param": 1,  
    "min_values": [-500] * 100, 
    "max_values": [500] * 100, 
    "iterations": 1000,
    "verbose": False
}

start_time = time.time_ns()
pso = whale_optimization_algorithm(target_function = schwefel, **parameters)
end_time = time.time_ns()

variables = pso[:-1]
minimum   = pso[ -1]
print('Variables: ', variables , ' Minimum Value Found: ', minimum )
print(f'time: {(end_time - start_time) * 10**-9} s')
```

##### Results
Variables:
[
 -301.81033656 -303.08629998 -305.55502531 -304.20383548 -302.80007656
 -303.10010545 -304.59728422 -303.65116597 -304.34868964 -300.67906983
 -303.64877299 -304.52962144 -301.16811125 -303.96236415 -302.40537035
 -300.86590755 -300.32278605 -300.69223945 -303.72036722 -303.04125411
 -300.03856694 -300.42877324 -303.37602135 -299.94185809 -304.50935742
 -303.5531782  -303.34178995 -299.46837136 -305.95961007 -303.84524105
 -300.68670764 -303.80911425 -301.40987857 -302.591709   -301.62692051
 -301.65173204 -303.80535091 -300.95586436 -304.76923585 -298.25529467
 -301.09193154 -303.51372121 -301.72671966 -300.56611417 -300.64368795
 -301.74180619 -123.05298712 -120.63416437 -302.07499333 -302.62767966
 -302.77608912 -303.76231244 -304.17097302 -302.4209752  -305.85081336
 -304.29282767 -301.30115729 -302.29550606 -302.17773424 -302.81299542
 -303.27740776 -303.11444625 -305.34429236 -301.64766706 -302.51672805
 -302.09776802 -301.53552051 -302.01852858 -300.60852604 -303.2499805
 -301.36997326 -304.13074439 -303.25533171 -301.8653511  -301.93487812
 -302.80921047 -301.9746641  -301.45825671 -303.34917938 -303.17270617
 -304.556992    -16.69952603 -302.62498697 -302.71337346 -304.26983428
 -300.23746808 -303.31003702 -301.92922202 -299.45201341 -303.72973506
 -302.22198543 -298.6212811  -301.78837995 -306.38167721 -300.76537899
 -301.14094681 -305.33142572  420.40997855 -302.71055836 -301.69383603
]  
Minimum Value Found:  12402.464980083674
time: 69.43300883500001 s

### Conclusion
Meow implementation is approximately 28 times faster. Moreover, pyMetaheuristic implements an optimized version of whale algorithm, which should be better. Despite that, the results of it are wrong — found point is not the global minimum.