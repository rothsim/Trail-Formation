%project slimy
%main_analysis.m, November 2012
%B�ttcher Lucas, Roth Simon, Sch�r Gabriela


clear


% simulation data
%--------------------------------------------------------------------------

simpath  = 'output/73520551715/';
dt       = 0.01;

load( [ simpath, 'geodata.mat' ] );
cellsize = 2500;						%[m]


% start analysis
%--------------------------------------------------------------------------

analysis( simpath, dt, geo, cellsize );