% Modeling and Simulating Social Systems with MATLAB
% http://www.soms.ethz.ch/matlab
% Author: Gabriela Schaer, Simon Roth, Lucas Boettcher 2012
% http://github.org/Trail-Formation

%input the parameter values

N = input('Enter the dimension of NxN matrix: '); 	%input grid dimension
G0 = input('Enter the initial conductivity: '); 	%input initial conductivity
I0 = input('Enter the initial flux: ');             %input initial flux
g = input('Enter the initial gamma: ');             %input initial gamma

%initialization of the grid
%0 = ghostland, 1 = freeland, 2 = node, 3 = junctionnode

grid = zeros( N, N );	%initialize grid with dimension NxN
grid( :, : ) = 3;       %set all elements to junctionnode

%initialization of the nodes
nodes = [ 1 1 ; 1 N];	%coordinates of nodes
source = nodes( 1, : ); %set source node
sink = nodes(2, : ); 	%set sink node 

%set source and sink to node 
for i = 1:size( nodes, 1 )   
    grid( nodes( i, 2 ), nodes( i, 1 ) ) = 2;  
end
      
%snitialization of ghostland
ghost = [ ]; 		%coordinates of ghostland

%set ghost to ghostland 
for i = 1:size( ghost, 1 )

    grid( ghost( i, 2 ), ghost( i, 1 ) ) = 0;

end

%define neighbourhood
neigh = [ 1 0 ; 0 -1 ; -1 0 ; 0 1 ];

%define flux
flux = zeros(N^2,N^2);

%call the index function
index = mkindex(N);

%call the coductivity function
G  = conductivity( N, neigh, grid, G0, index );

%main loop
for t=1:1000
    
    %initialization of the equation system
    A = zeros( N^2+1, N^2 );	%pressure parameters
    b = zeros( N^2+1, 1 );		%initial flux
    eq = 1;                     %iterated row
    
%iterate over grid and generate pressure matrix A, current matrix b
%calling function genAB

[A, b] = genAB( N, neigh, grid, index, A, b, eq, I0, G, source, sink );    
    
    %solve equation system
    pressure = A\b;
    
%generate final grid by calling function mzsolve    

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

                            flux( index( m, n ), index( i, j ) ) = G( index( m, n ), index( i, j ) )*( pressure( index( m, n ) )-pressure( index( i, j ) ) ); 	%compute flux

                            fQ = abs( flux( index( m, n ), index( i, j ) ) )^g/( 1+abs( flux( index( m, n ), index( i, j ) ) )^g );                             %compute fluxfunction

                            G( index( m, n ), index( i, j ) ) = G( index( m, n ), index( i, j ) )+( fQ-G( index( m, n ), index( i, j ) ) );                     %compute conductivity

                            die = die+G( index( m, n ), index( i, j ) );                                                                                        %compute death of junction

                        end
                        
                    end

                end
		
                %set junctionnode without conductivity to freeland
                if ( die == 0 && grid( i, j ) == 3 )

                    grid( i, j ) = 1;

                end

        end
    end
 
    %draw grid
    clf
    imagesc( grid, [0 3] )

    %colormap is coded as:
    colormap( [ 1 0 0 ; 		%red = ghostland
                0 1 0 ; 		%green = freeland
                0 0 1 ; 		%blue = node
                1 1 0 ] ); 		%yellow = junctionnode

    pause(0.01)

end