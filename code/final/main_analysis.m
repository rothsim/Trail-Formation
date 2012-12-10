%project slimy
%main_analysis.m, November 2012
%Böttcher Lucas, Roth Simon, Schär Gabriela


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