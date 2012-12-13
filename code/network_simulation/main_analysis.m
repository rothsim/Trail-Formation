% Modeling and Simulating Social Systems with MATLAB
% http://www.soms.ethz.ch/matlab
% Author: Gabriela Schaer, Simon Roth, Lucas Boettcher 2012
% http://github.org/Trail-Formation


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