% Modeling and Simulating Social Systems with MATLAB
% http://www.soms.ethz.ch/matlab
% Author: Gabriela Schaer, Simon Roth, Lucas Boettcher 2012
% http://github.org/Trail-Formation

%PRE: A is the map with start: 2, free and end: 1, ghost 0, start and end
%coordinates from points vector and the neighborhood from neigh

%POST: Matrix B with drawn shortest path and the length (short_length)

function [B,short_length] = shortest_path(A,points,neigh)

% This function computes one shortest path and whose length between 
%two points given in a 1x4 matrix, with coordinates related to the 
%quadratic matrix A

% read matrix dimension
ALength1 = size(A,1);
ALength2 = size(A,2);

%initialize matrix B
B=A;

%Clear matrix B from ways and cities

for i=1:ALength1
    for j=1:ALength2
        if B(i,j)==2 || B(i,j)==3
            B(i,j)=1;
        end
    end
end

% iterate over the given points

    B(points(1),points(2)) = 2;

    % iterate over grid matrix A
            for step=1:ALength2^2
                
                % neighbor watch
                iter = 0;
                
                for k=1:ALength1
                    for l=1:ALength2
                                                    
                        if B(k,l) ~= 1
                            continue;
                        end
                        
                        % we use the linked neighborhood
                        
                        for p = 1:size( neigh, 1 )

                        m = k+neigh( p, 1 );
                        n = l+neigh( p, 2 );
                    
                        % need to respect borders
                        
                            if m >= 1 && n >= 1 && m <= ALength1 && n <= ALength2
                                
                                if B(m,n) == step+1
                                B(k,l) = step+2;
                                iter = 1;
                                end
                                
                            end
                        
                        end
                    end
                   
                end
                % if there is no other neighbor, break
                    if ~iter
                        break;
                    end
                
            end
        
       %compute the length from the marked elements in A     
       short_length = B(points(3),points(4))-B(points(1),points(2));
       
       %initialize the jumping backward iteration points (for the
       %backtracking drawing of the way)
       end1=points(3);
       end2=points(4);
   for k=1:short_length
      
       for p = 1:size( neigh, 1 )

                        m = end1+neigh( p, 1 );
                        n = end2+neigh( p, 2 );
                    
                        % need to respect borders
                        
                            if m >= 1 && n >= 1 && m <= ALength1 && n <= ALength2
                                
                                if B(m,n) == B(end1,end2)-1;
                                B(end1,end2) = 2;
                                end1=m;
                                end2=n;
                                end
                                
                            end
                            continue;
       end
       
       
   end
   
    for k=1:ALength1
    for l=1:ALength2
        if B(k,l)~=2 && B(k,l)~=1 && B(k,l)~=0
            B(k,l)=1;
        end
    end
    end
end
 

