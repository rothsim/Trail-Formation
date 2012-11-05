%iterate over grid
for i = 1:Y
    for j = 1:X
            
        %iterate over neighbours
        for k = 1:size( neigh, 1 )

            m = i+neigh( k, 1 );
            n = j+neigh( k, 2 );
                    
            if ( m>=1 && n>=1 && m<=Y && n<=X )

                if ( grid( m, n ) >= 2 )

                    flux( varnum( m, n, X ), varnum( i, j, X ) ) = D( varnum( m, n, X ), varnum( i, j, X ) )*( press( varnum( m, n, X ) )-press( varnum( i, j, X ) ) );                                                 %compute flux
                    D( varnum( m, n, X ), varnum( i, j, X ) ) = D( varnum( m, n, X ), varnum( i, j, X ) )+( expans( flux( varnum( m, n, X ), varnum( i, j, X ) ), g )-D( varnum( m, n, X ), varnum( i, j, X ) ) )*dt;   %compute conductivity
                    path( i, j ) = path( i, j )+D( varnum( m, n, X ), varnum( i, j, X ) );
                                 
                end
                        
            end

        end

    end
end