function [] = initial( D0, I0, g, a0, a, T, dt, export, geo )
%INITIAL prepars all the input data for the simulation.
%   All parameters and constants and all input data are converted and
%   prepared to run the simulation.

	% folder structure
	simpath = initial_structure( export );


	% get dimension of geodata
	[ Y, X ] = size( geo );


	% get indices of nodes
	nodes = find( geo == 3 );


	% define von Neumann neighbourhood (x y)
	neigh = [         0 -1;
		      -1  0;         1  0;
			          0  1       ];


	% initialize conductivity and path
	D    = zeros( X*Y, X*Y );
	path = geo;
	
	[ D, path ] = initial_dpath( D0, geo, Y, X, neigh, D, path );


	% initialize flux
	flux = zeros( X*Y, X*Y );


	% export topography
	save( [ simpath, 'topography.txt' ], 'geo', '-ASCII' );


	% start main loop
	loop( I0, g, a0, a, T, dt, geo, simpath, Y, X, nodes, neigh, D, path, flux );


end


%% create folder structure
function [ simpath ] = initial_structure( parentfolder )


	%get unique foldername
	foldername = int2str( now*10^5 );

	%create folder
	mkdir( [ parentfolder, foldername ] );

	%folder path
	simpath = [ parentfolder, foldername, '/' ];


end


%% initialize conductivity and path
function [ D, path ] = initial_dpath( D0, geo, Y, X, neigh, D, path )


	for i = 1:X
		for j = 1:Y

			for k = 1:length( neigh )

				m = i+neigh( k, 1 );
				n = j+neigh( k, 2 );

				if ( geo( j, i ) > 0 && m >= 1 && n >= 1 && m <= X && n <= Y && geo( n, m ) > 0 )

					p = varnum( n, m, Y );
					q = varnum( j, i, Y );

					D( p, q ) = D0;

					if ( geo( p ) ~= 3 && D( p, q ) > 0 )

						path( p ) = 2;

					end

				end

			end

		end
	end


end