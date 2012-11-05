function [ fQ ] = expans( Q, g )
%EXPANS computes the expansion of tubes.
%   This function describes the expansion of tubes in response to the flux.

    fQ = abs( Q )^g/( 1+abs( Q )^g );

end