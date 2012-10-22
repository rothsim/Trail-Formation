# MATLAB HS12 – Research Plan

> * Group Name: Slimy
> * Group participants names: Böttcher Lucas, Roth Simon, Schär Gabriela
> * Project Title: Trail formation with Physarum polycephalum

## General Introduction

Generating a biologically inspired model of the Swiss railroad network depending on population growth. By using a biological (based on Physarum polycephalum) model, we want to simulate future scenarios of the Swiss railroad network. Probably a problem in future would be, that in fact of the population growth more people will use the public transport system. So we think it is necessary to simulate the main transport lines, to see where the system should be improved.

## The Model
 
The mathematical model is based on (2). The urban areas (food sources) are the independent variables. By using theorems from hydro dynamics there exists three types of dependent variables for each node: conductivity, length and pressure.

## Fundamental Questions

* Is the simulated railroad network a good approximation of the real network?
* Are there inefficient junctions and are new junctions needed for the future?

## Expected Results

Because Switzerland has a special topography the model is maybe not fully adaptable. In general we assume that the junctions and their capacity show more or less the future network.


## References

* http://www.sciencemag.org/content/327/5964/439.full (1)
* http://eprints.lib.hokudai.ac.jp/dspace/bitstream/2115/28042/1/PASMA363-1.pdf (2)
* http://www.youtube.com/watch?v=b5Z_BWu-daA (Hagen Poiseuille equation)


## Research Methods

Cellular grid (matrix based on Swiss topography - GIS) with predefined rules from hydro dynamics, continuous modeling


## Other

* Simulation surface with GIS - https://geodata.ethz.ch/geovite/
