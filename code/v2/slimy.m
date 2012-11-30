%slimy.m, November 2012
%Böttcher Lucas, Roth Simon, Schär Gabriela

clear


%parameters and constants
%--------------------------------------------------------------------------

D0 = 1.00;      %initial conductivity
I0 = 2.00;      %initial flux
g  = 1.80;      %gamma

T  = 1000;      %endtime
dt = 0.01;      %timestep


%initialisation of workspace
%--------------------------------------------------------------------------

%grid								%coded as:
filename  = 'geodata_5000.txt';		%0 => ghostland
grid = dlmread( filename );			%1 => freeland
									%2 => junctions
									%3 => source/sink nodes
									       
%draw grid
figure( 1 )
set( 1, 'color', 'white' )
set( 1, 'name', 'Topographie' )
imagesc( grid )
colormap( flipud( gray ) )
axis image
axis off
                                  
%get grid dimensions
[ Y, X ] = size( grid );

%get nodes
nodes = zeros( sum( sum( grid == 3 ) ), 2 );
k     = 1;

for i = 1:X
    for j = 1:Y
        
        if ( grid( j, i ) == 3 )
            
            nodes( k, 1 ) = i;
            nodes( k, 2 ) = j;
            
            k = k+1;
            
        end
        
    end
end

%define neighbourhood
neigh = [          0 -1 ;
          -1  0 ;          1  0 ;
                   0  1         ];
               
%set default conductivity and path
D = zeros( X*Y, X*Y );
path = grid;

for i = 1:X
    for j = 1:Y
            
        for k = 1:size( neigh, 1 )

                m = i+neigh( k, 1 );
                n = j+neigh( k, 2 );

                if ( grid( j, i ) > 0 && m>=1 && n>=1 && m<=X && n<=Y && grid( n, m ) > 0 )
                    
                    p = varnum( m, n, X );
                    q = varnum( i, j, X );
                    
                    D( p, q ) = D0;
                   
					if ( grid( n, m ) ~= 3 && D( p, q ) > 0 )
						
						path( n, m ) = 2;
						
					end
					
                end
            
        end
        
    end
end

%flux
flux = zeros( X*Y, X*Y );



%main loop
%--------------------------------------------------------------------------

for t = 0:dt:T;
    
    %equation system initialisation
    A = zeros( X*Y, X*Y );
    b = zeros( X*Y, 1 );
    
    %set source and sink node
    for s = 0:dt:T
        
        r1 = randi( size( nodes, 1 ), 1 );
        r2 = randi( size( nodes, 1 ), 1 );
        
        if ( r1 ~= r2 )
            
            break
            
        end
        
    end
    
    source = nodes( r1, : );
    sink   = nodes( r2, : );
    
    %compute equation system
    for i = 1:X
        for j = 1:Y
            
            row = varnum( i, j, X );

            for k = 1:size( neigh, 1 )

                m = i+neigh( k, 1 );
                n = j+neigh( k, 2 );

                if ( m>=1 && n>=1 && m<=X && n<=Y )

                    var = varnum( m, n, X );
                    p   = varnum( m, n, X );
                    q   = varnum( i, j, X );
                    
                    if ( i == sink( 1, 1 ) && j == sink( 1, 2 ) || path( j, i ) <= 1 )
                        
                        A( row, row ) = 1; 
                    
                    elseif ( grid( j, i ) >= 1 && grid( n, m ) >= 1 ) 
                        
                        A( row, var ) = A( row, var )+D( p, q );
                        A( row, row ) = A( row, row )-D( p, q );
                        
                    end
                    
                    if ( i == source( 1, 1 ) && j == source( 1, 2 ) )
                        
                        b( row ) = -I0;
                        
                    end

                end

            end

        end
    end
    
    %solve equation system
    press = A\b;
    
    %compute solutions
    path = grid;
	
	for i = 1:X
		for j = 1:Y

			for k = 1:size( neigh, 1 )

                m = i+neigh( k, 1 );
                n = j+neigh( k, 2 );

				if ( grid( j, i ) > 0 && m>=1 && n>=1 && m<=X && n<=Y && grid( n, m ) > 0 )

                    p = varnum( m, n, X );
                    q = varnum( i, j, X );
                    
                    flux( p, q ) = D( p, q )*( press( p )-press( q ) );
                    D( p, q )    = D( p, q )+( expans( flux( p, q ), g )-D( p, q ) )*dt;
                    
					if ( grid( n, m ) ~= 3 && D( p, q ) > eps )
						
						path( n, m ) = 2;
						
					end
                    
				end

			end

		end
	end
	
    %draw path	
	figure( 2 )
	set( 2, 'color', 'white' )
	set( 2, 'name', 'Path' )
	imagesc( path )
	title( sprintf( 't = %0.2f', t ), 'FontSize', 13 )
	colormap( 'jet' )
	colorbar
	axis image
	axis off
    
    pause( 0.01 );
    
end