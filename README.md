<h2 align="center">Multi Agent Physical Simulation</h2> 
<h2 align="center">Project in the Technion's ECE faculty (044169)</h2> 
<h4 align="center">Plan and simulate of a multi agent pickup n' delivery task</h4> 

<p align="center">
  <img src="https://github.com/saarst/MultiAgentPhysicalSimulation/blob/main/assets/gate.jpg" alt="gate" width="50%">
</p>

  <p align="center">
    Yamit Pisman: <a href="https://www.linkedin.com/in/yamit-pisman/?originalSubdomain=il">LinkedIn</a> , <a href="https://github.com/YamitPisman
">GitHub</a>
  <br>
    Saar Stern: <a href="https://www.linkedin.com/in/saar-stern-a43413246/">LinkedIn</a> , <a href="https://github.com/saarst">GitHub</a>
  <br>
  Supervised by:
<br>
  Ayal taitler: <a href="https://www.linkedin.com/in/ayal-taitler/">LinkedIn</a> , <a href="https://github.com/ataitler">GitHub</a>
</p>

Using the planner ScottyActivity2, from the paper:
Enrique Fernandez-Gonzalez , Brian Williams, Erez Karpas [ScottyActivity: Mixed Discrete-Continuous Planning with Convex Optimization](https://www.jair.org/index.php/jair/article/view/11219)
Please contact Enrique Fernandez (efernan@mit.edu) for questions or comments about this planner.


- [Multi Agent Physical Simulation](#Multi-Agent-Physical-Simulation)
  * [Background](#background)
  * [Results](#results)
  * [Installation](#installation)
  * [Files in the repository](#files-in-the-repository)

## Background
This project specifically focuses on the navigation challenges associated with drone-delivered packages, a rapidly evolving field. Our solution is an operation scheme, at the core of which lies an algorithm called Scotty. We encapsulate Scotty within blocks that we've written, and ultimately perform a simulation in the Unity environment.

<p align="center">
  <img src="https://github.com/saarst/MultiAgentPhysicalSimulation/blob/main/assets/Simulation.png" alt="Simulation Image" width="50%">
</p>

In this problem scenario, two drones are assigned the task of picking up packages from distinct warehouses and delivering five packages to four different houses, all within specified time windows. The planning process considers acceleration, deceleration, and adheres to delivery constraints. These aspects collectively mirror the real-world challenges inherent in drone-based package delivery systems.

<p align="center">
  <img src="https://github.com/saarst/MultiAgentPhysicalSimulation/blob/main/assets/Scheme.png" alt="General Scheme" width="50%">
</p>

## Results
We conducted simulations with package 5's delivery to house 3 restricted within three distinct time windows:
[Watch the youtube playlist](https://www.youtube.com/playlist?list=PLwswt8EN0U2SnTcBOxYs7qaw6X1bokqm-)
## Installation

For the installation you will need:
- scottyActivity2 planner
- Gurobi optimizatoin 7.0.2
- Matlab
- Unity

You can contact us for the unity files.

## Files in the repository
We included only the pre and post process Matlab files.
