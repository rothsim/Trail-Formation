function [ grid ] = mzsolve( N, neigh, grid, index, pressure, R, g, flux )

 %iterate over grid
    for i = 1:N
        for j = 1:N

            	%set death of junction condition to zero
                die = 0; 

                %iterate over neighbours
                for k = 1:size( neigh, 1 )

                    m = i+neigh( k, 1 );
                    n = j+neigh( k, 2 );
                    
                    if ( m>=1 && n>=1 && m<=N && n<=N )

                        if ( grid( m, n ) >= 2 )

                            flux( index( m, n ), index( i, j ) ) = R( index( m, n ), index( i, j ) )*( pressure( index( m, n ) )-pressure( index( i, j ) ) ); 	%compute flux

                            fQ = abs( flux( index( m, n ), index( i, j ) ) )^g/( 1+abs( flux( index( m, n ), index( i, j ) ) )^g );                             %compute fluxfunction

                            R( index( m, n ), index( i, j ) ) = R( index( m, n ), index( i, j ) )+( fQ-R( index( m, n ), index( i, j ) ) );                     %compute conductivity

                            die = die+R( index( m, n ), index( i, j ) );                                                                                        %compute death of junction

                        end
                        
                    end

                end
		
                %set junctionnode without conductivity to freeland
                if ( die == 0 && grid( i, j ) == 3 )

                    grid( i, j ) = 1;

                end

        end
    end

end

