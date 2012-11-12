% Modeling and Simulating Social Systems with MATLAB
% http://www.soms.ethz.ch/matlab
% Author: Gabriela Schaer, Simon Roth, Lucas Boettcher 2012
% http://github.org/Trail-Formation

function [ short_length ] = shortest_path( A, points, neigh )
% This function computes the shortest path length between two points given
% in a Nx4 matrix, with coordinates related to the quadratic matrix A

% read matrix dimension
ALength = length(A);
pointLength = size(points,1);

% output length
short_length = zeros(pointLength,1);

% iterate over the given points

for i=1:pointLength

    % start: 2, free and end: 1, ghost 0

    A(points(i,1),points(i,2)) = 2;

    % iterate over grid matrix A
            for step=1:ALength^2
                
                % neighbor watch
                iter = 0;
                
                for k=1:ALength
                    for l=1:ALength
                                                    
                        if A(k,l) ~= 0
                            continue;
                        end
                        
                        % we use the linked neighborhood
                        
                        for p = 1:size( neigh, 1 )

                        m = k+neigh( p, 1 );
                        n = l+neigh( p, 2 );
                    
                        % need to respect borders
                        
                            if m >= 1 && n >= 1 && m <= ALength && n <= ALength
                                
                                if A(m,n) == step+1
                                A(k,l) = step+2;
                                iter = 1;
                                end
                                
                            end
                        
                        end
                    end
                   
                end
                % if there is no other neighbor
                    if ~iter
                        break;
                    end
                
            end
end
short_length(i) = A(points(i,3),points(i,4))-A(points(i,1),points(i,2));
end

