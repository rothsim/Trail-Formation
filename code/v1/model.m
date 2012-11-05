%equation system initialisation
A = zeros( X*Y+1, X*Y );
b = zeros( X*Y+1, 1 );

%set random source and sink node
for s = 1:100000
    
    r1 = randi( size( nodes, 1 ), 1 );
    r2 = randi( size( nodes, 1 ), 1 );
    
    if ( r1 ~= r2 )
        break
    end
    
end

source = nodes( r1 , : );   
sink   = nodes( r2 , : );                      

%iterate over gird
for i = 1:Y
    for j = 1:X

        %iterate over neighbours
        for k = 1:size( neigh, 1 )

            m = i+neigh( k, 1 );
            n = j+neigh( k, 2 );
                    
            if ( m>=1 && n>=1 && m<=Y && n<=X )

                if ( grid( m, n ) >= 2 )                                                                                                                %only iterate over nodes and junctionnodes

                    A( varnum( i, j, X ), varnum( m, n, X ) ) = A( varnum( i, j, X ), varnum( m, n, X ) )+D( varnum( m, n, X ), varnum( i, j, X ) );    %set equation parameter for p_i
                    A( varnum( i, j, X ), varnum( i, j, X ) ) = A( varnum( i, j, X ), varnum( i, j, X ) )-D( varnum( m, n, X ), varnum( i, j, X ) );    %set equation parameter for p_j

                end

                if ( sink( 1, 2 ) == i && sink( 1, 1 ) == j )

                    A( X*Y+1, varnum( i, j, X ) ) = 1;                                                                                                  %set p_sink to zero

                end

                if ( source( 1, 2 ) == i && source( 1, 1 ) == j )

                    b( varnum( i, j, X ) ) = -I0;                                                                                                       %set right side of equation system

                elseif ( sink( 1, 2 ) == i && sink( 1, 1 ) == j )

                    b( varnum( i, j, X ) ) = I0;                                                                                                        %set right side of equation system

                end
                        
            end

        end

    end

end
    
press = A\b;    %solve equation system