function [ num ] = varnum( y, x, X )
%VARNUM assigns a unique number to every node or junctionnode.
%   A unique number for every node or junctionnode is nessecary to generate
%   and solve the equation system. The input variables are the coordinates
%   x y and the X dimension of the simulation surface.

    num = ( y-1 )*X+x;

end