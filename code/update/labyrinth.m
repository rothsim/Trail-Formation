% Modeling and Simulating Social Systems with MATLAB
% http://www.soms.ethz.ch/matlab
% Author: Gabriela Schär, Simon Schär, Lucas Böttcher 2012

% Simple maze solver

% INPUT AND DEFINITION

% Set input values
N=input('Enter grid size: ');                   % Grid size (NxN)
i_init=input('Enter the the start i value: ');  % Define i_initial
j_init=input('Enter the the start j value: ');  % Define j_initial
i_end=input('Enter the the end i value: ');     % Define i_end
j_end=input('Enter the the end j value: ');     % Define j_end

% Define grid
x = zeros(N, N);    % The grid x, is coded as:  0=way, 1=border, 2=source, 3=sink
x(i_end,j_end)=3;   % End point
x(i_init,j_init)=2; % Start point
                    % Define blockades with 1
% Define variables
L=0;                % Start Length is set to 0
i=1;
j=1;

% Define the Van Neumann neighborhood, i.e. the 4 nearest neighbors
step = [1 0;-1 0;0 1;0 -1];
left = step(1,1);
right = step(2,1);
up = step(3,2);
down = step(4,2);

% //...../way_k1/way_k2/.../way_kN^2/L
% //right/
% //left /
% //up   /
% //down /

% CALCULATION AND OUPUT

for k=1:pow(2,N)
   way(k) = zeroes(pow(N,2),4);
end

% Iterate over the neighbors via Moore
% Function get the cell position
 








