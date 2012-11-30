%project slimy
%main.m, November 2012
%Böttcher Lucas, Roth Simon, Schär Gabriela


clear


% parameters and constants
%--------------------------------------------------------------------------

D0 = 1.00;	%initial conductivity
I0 = 2.00;	%initial flux
g  = 1.80;	%expans equation gamma
a0 = 2012;	%year of simulation data
a  = 2050;	%year of simulation

T  = 1000;	%end of simulation
dt = 0.01;	%timestep of simulation


% folder sturcture
%--------------------------------------------------------------------------

import = 'input/';		%folder of input data
export = 'output/';		%folder to save the simulation results


% load input data
%--------------------------------------------------------------------------

geo  = load( [ import , 'geodata.txt' ] );		%coded geodata
%elev = load( [ import, 'elevation.txt' ] );	%digital elevation model
%pop  = load( [ import, 'population.txt' ] );	%population
%grow = load( [ import, 'growth.txt' ] );		%population growth


% initialize simulation
%--------------------------------------------------------------------------

initial( D0, I0, g, a0, a, T, dt, export, geo );