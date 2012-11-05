function [ index ] = mkindex( N )

%Define grid index
index = zeros( N, N );

%Set unique index for every gridcell
for i = 1:N
    for j = 1:N 

        index( i, j ) = (i-1)*10+j;
 
    end
end

end

