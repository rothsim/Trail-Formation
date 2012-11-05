function [G ] = conductivity( N,neigh,grid,G0,index )

%initialization of conductivity
G = zeros(N^2, N^2);

%set conductivity only for neighbours
for i = 1:N
    for j = 1:N
        
        for k = 1:size( neigh, 1 )
            
            m = i+neigh( k, 1 );
            n = j+neigh( k, 2 );
            
            if ( m>=1 && n>=1 && m<=N && n<=N )
                
                if ( grid( m, n ) >= 2 )
                
                    G( index( i, j ), index( m, n ) ) = G0;
                    
                end
                
            end
            
        end
        
    end
end 
end

