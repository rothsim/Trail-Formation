function [ num ] = varnum( y, x, Y )
%VARNUM assigns a unique number to every node and junction.
%   A unique number for every node or junction is nessecary to generate
%   and solve the equation system. The input variables are the coordinates
%   x y and the X dimension of the simulation surface.

    num = ( x-1 )*Y+y;

end