# Robotics and Control 2 - Project

## Preliminary Note

You have to define the initial pose of the robot for the Tracking problem and the final pose of the robot for the Regulation problem in **array** form. Example:

```matlab
Reference trajectory has initial x of: 0
Reference trajectory has initial y of: 0
Initial pose robot [x,y,theta] specified as array [], with theta in degree: [1 1 90]
```

## Steps

Run in order:

```shell
>>> TrajectoryGeneration.m
>>> AutomatedSimulation.m
```

the script end with the word `Done` in the MATLAB Command Window

> It is not necessary to run the simulation in Simulink (some variables are defined in MATLAB), all the simulations must be run from the MATLAB script