# Slimy Manual

## Simulation
The Simulation is started with the main.m file, which is a script. There are some variables which can be adjusted for different scenarios by editing the main.m file. Good results can be achieved with I0 = 2.00, g = 1.80. The current state of the Simulation can be checked with the state.txt file in the simulation folder (to check the state remotely, sync the state.txt file with a cloud storage service like Dropbox). All input data are processed with ArcGIS.

## Analysis
To analyse the output data of the simulation the main_analysis.m file has to be used. It is a script file and there are some variables which can be adjusted by editing the main_analysis.m file. Output files can be processed with ArcGIS.

## Attention
Because of the cellular automata approach high hardware performance is needed to run the simulation on large geographic data. This means a fast CPU and at least 8 GB of RAM. Depending on the hardware and the input data a simulation lasts about three days.