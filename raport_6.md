## Optimized functions

We added for more optimized functions:
- Griewank (zero vector optimum)
- Griewank in a translated version
- Zakharov (zero vector optimum)
- Zakharov in a translated version

## Comparision of results - diagrams

### Griewank function
#### Size - 100
![alt text](raport_diagrams/Griewank%20-%20100.png)
#### Size - 1000
![alt text](raport_diagrams/Griewank%20-%201000.png)
For the Griewank function all algorithms are accurate taking into consideration 5000 iterations, especially for size equal 100. For the bigger problem size, the standard meow implementation starts to fail to converge in a given number of iterations.

### Rosenbrock function
#### Size - 100
![alt text](raport_diagrams/Rosenbrock%20-%20100.png)
![alt text](raport_diagrams/Rosenbrock%20-%20100%20(last%202000%20iterations).png)
#### Size - 1000
![alt text](raport_diagrams/Rosenbrock%20-%201000.png)
![alt text](raport_diagrams/Rosenbrock%20-%201000%20(last%201000%20iterations).png)
For the Rosenbrock function, despite starting with poor fitness, all algorithms quickly improve it and start to stabilize on a certain level. The best performance has Whale algorithm. The second best is symbiotic settling absolute value of fitness to couple hundreds in five thousands iterations. The worst is standard implementation, which stops on couple hundreds for smaller problem size (still more than symbiotic) and couple hundred thousands for bigger size.

### Schwefel function
#### Size - 100
![alt text](raport_diagrams/Schwefel%20-%20100.png)
#### Size - 1000
![alt text](raport_diagrams/Schwefel%20-%201000.png)
In case of Schwefel function, symbiotic algorithm for some reason is practically not improving at all. The Whale algorithm, like for every other function, has even too good result. Standard implementation is gradually improving, but for bigger problem size it is still huge absolute value for a fitness.
