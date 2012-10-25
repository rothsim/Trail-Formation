%parameters
N  = 20;    %grid dimension
D0 = 1;     %initial conductivity
I0 = 2.00;  %initial flux
g  = 1.80;  %gamma

%grid initialisation, grid is coded as:
%0 = ghostland, 1 = freeland, 2 = node, 3 = junctionnode
grid = zeros( N, N );
grid( :, : ) = 3;       %set all to junctionnode

%node initialisation
nodes = [  1  1 ;                               %coordinates of nodes
           1  N ];
       
source = nodes( 1 , : );                        %set source node
sink   = nodes( 2 , : );                        %set sink node

for i = 1:size( nodes, 1 )
    
    grid( nodes( i, 2 ), nodes( i, 1 ) ) = 2;   %set grid to node
    
end
      
%ghostland initialisation
ghost = [  1  3 ;   %coordinates of ghostland
           2  3 ;
           3  3 ;
           4  3 ;
           5  3 ;
           6  3 ;
           7  3 ;
           8  3 ;
           9  3 ;
          10  3 ];                              

for i = 1:size( ghost, 1 )
    
    grid( ghost( i, 2 ), ghost( i, 1 ) ) = 0;   %set grid to ghostland
    
end

%define neighbourhood
neigh = [  1  0 ;
           0 -1 ;
          -1  0 ;
           0  1 ];

%define grid index       
index = zeros( N, N );

for i = 1:N
    for j = 1:N
        
        index( i, j ) = (i-1)*N+j;      %set unique index for every girdcell
        
    end
end

%conductivity initialisation
D = zeros( N^2, N^2 );

for i = 1:N
    for j = 1:N
        
        for k = 1:size( neigh, 1 )
            
            m = i+neigh( k, 1 );
            n = j+neigh( k, 2 );
            
            if ( m>=1 && n>=1 && m<=N && n<=N )
                
                if ( grid( m, n ) >= 2 )
                
                    D( index( i, j ), index( m, n ) ) = D0;     %set conductivity only for neighbours
                    
                end
                
            end
            
        end
        
    end
end

%flux initialisation
flux = zeros( N^2, N^2 );

%main loop
for t=1:100000
    
    %equation system initialisation
    A = zeros( N^2+1, N^2 );
    b = zeros( N^2+1, 1 );
    eq = 1;                     %number of current row

    %iterate over gird
    for i = 1:N
        for j = 1:N

                %iterate over neighbours
                for k = 1:size( neigh, 1 )

                    m = i+neigh( k, 1 );
                    n = j+neigh( k, 2 );
                    
                    if ( m>=1 && n>=1 && m<=N && n<=N )

                        if ( grid( m, n ) >= 2 )                                                                    %only iterate over nodes and junctionnodes

                            A( eq, index( m, n ) ) = A( eq, index( m, n ) )+D( index( m, n ), index( i, j ) );      %set equation parameter for p_i
                            A( eq, index( i, j ) ) = A( eq, index( i, j ) )-D( index( m, n ), index( i, j ) );      %set equation parameter for p_j

                        end

                        if ( sink( 1, 2 ) == i && sink( 1, 1 ) == j )

                            A( N^2+1, index( i, j ) ) = 1;                                                          %set p_sink to zero

                        end

                        if ( source( 1, 2 ) == i && source( 1, 1 ) == j )

                            b( eq ) = -I0;                                                                          %set right side of equation system

                        elseif ( sink( 1, 2 ) == i && sink( 1, 1 ) == j )

                            b( eq ) = I0;                                                                           %set right side of equation system

                        end
                        
                    end

                end

                eq = eq+1;                                                                                          %next row of equation system

        end

    end

    press = A\b;    %solve equation system

    %iterate over grid
    for i = 1:N
        for j = 1:N
            
                die = 0;                                                                                                                                    %set death of junction condition to zero

                %iterate over neighbours
                for k = 1:size( neigh, 1 )

                    m = i+neigh( k, 1 );
                    n = j+neigh( k, 2 );
                    
                    if ( m>=1 && n>=1 && m<=N && n<=N )

                        if ( grid( m, n ) >= 2 )

                            flux( index( m, n ), index( i, j ) ) = D( index( m, n ), index( i, j ) )*( press( index( m, n ) )-press( index( i, j ) ) );     %compute flux
                            fQ = abs( flux( index( m, n ), index( i, j ) ) )^g/( 1+abs( flux( index( m, n ), index( i, j ) ) ) );                           %compute fluxfunction
                            D( index( m, n ), index( i, j ) ) = D( index( m, n ), index( i, j ) )+( fQ-D( index( m, n ), index( i, j ) ) );                 %compute conductivity

                            die = die+D( index( m, n ), index( i, j ) );                                                                                    %compute death of junction

                        end
                        
                    end

                end                    
                
                if ( die == 0 && grid( i, j ) == 3 )

                    grid( i, j ) = 1;                                                                                                                       %set junctionnode without conductivity to freeland

                end

        end
    end
    
    %draw grid
    clf                                
    imagesc( grid, [0 3] )
    %colormap is coded as:
    colormap( [ 1 0 0 ;     %red = ghostland
                0 1 0 ;     %green = freeland
                0 0 1 ;     %blue = node
                1 1 0 ] );  %yellow = junctionnode
    pause(0.01)

end