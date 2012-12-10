function [] = loop( g, a0, a, T, dt, geo, simpath, Y, X, nodes, I, neigh, D, path, t0, flux )
%LOOP is the main loop of simulation.
%   This function is the main loop of the simulation. After the
%   initialisation, every step is controled from here.


	%initialize loop history variables
	oldpath = 0;

	for t = t0:dt:T

		% initialize equation system
		A = zeros( X*Y, X*Y );
		b = zeros( X*Y, 1 );


		% set source and sink node
		[ soury, sourx, sinky, sinkx, curI ] = loop_nodes( T, Y, X, nodes, I );


		% get equation system
		[ A, b ] = loop_system( geo, Y, X, neigh, D, path, A, b, soury, sourx, sinky, sinkx, curI );


		% solve equation system
		press = A\b;


		% update conductivity and path
		[ D, path ] = loop_update( g, dt, geo, Y, X, neigh, D, flux, press );
		

		% compute and save results
		newpath = sum( find( path == 2 ) );

		loop_export( dt, simpath, D, path, oldpath, a0, a, t, newpath );

		oldpath = newpath;

	end


end


%% get random source and sink node
function [ soury, sourx, sinky, sinkx, curI ] = loop_nodes( T, Y, X, nodes, I )


	for u = 0:T

		% random node numbers
		v1 = randi( length( nodes ), 1 );
		v2 = randi( length( nodes ), 1 );

		if ( v1 ~= v2 )

			break

		end

	end

	% get source and sink coordinates
	[ soury, sourx ] = ind2sub( [ Y, X ], nodes( v1 ) );
	[ sinky, sinkx ] = ind2sub( [ Y, X ], nodes( v2 ) );

	% get flux of source
	curI = I( v1 );


end


%% compute equation system
function [ A, b ] = loop_system( geo, Y, X, neigh, D, path, A, b, soury, sourx, sinky, sinkx, curI )


	for i = 1:X
		for j = 1:Y

			for k = 1:length( neigh )

				m = i+neigh( k, 1 );
				n = j+neigh( k, 2 );

				if ( m >= 1 && n >= 1 && m <= X && n <= Y )

					p = varnum( n, m, Y );
					q = varnum( j, i, Y );

					if ( i == sourx && j == soury )

						b( q ) = -curI;

					end
						
					if ( i == sinkx && j == sinky || path( j, i ) < 2 )

						A( q, q ) = 1;

					elseif ( geo( j, i ) > 0 && geo( n, m ) > 0 )

						A( q, p ) = A( q, p )+D( p, q );
						A( q, q ) = A( q, q )-D( p, q );

					end

				end

			end

		end
	end


end


%% compute new conductivity and set path
function [ D, path ] = loop_update( g, dt, geo, Y, X, neigh, D, flux, press )


	% reset path
	path = geo;
		
	for i = 1:X
		for j = 1:Y

			for k = 1:length( neigh )

				m = i+neigh( k, 1 );
				n = j+neigh( k, 2 );

				if ( geo( j, i ) > 0 && m >= 1 && n >= 1 && m <= X && n <= Y && geo( n, m ) > 0 )

					p = varnum( n, m, Y );
					q = varnum( j, i, Y );

					flux( p, q ) = D( p, q )*( press( p )-press( q ) );
					D( p, q )    = D( p, q )+( loop_expans( g, flux( p, q ) )-D( p, q ) )*dt;

					if ( geo( n, m ) ~= 3 && D( p, q ) > eps )

						path( n, m ) = 2;

					end

				end

			end

		end
	end


end


%% tube expansion function
function [ fQ ] = loop_expans( g, Q )


	fQ = abs( Q )^g/( 1+abs( Q )^g );


end


%% save the results
function [] = loop_export( dt, simpath, D, path, oldpath, a0, a, t, newpath )


	% only save results on change
	if ( newpath ~= oldpath )

		draw( path , 'jet', [ simpath, 'path/' ], [ 'path_', num2str( 1/dt*t ) ] );
		save( [ simpath, 'conductivity/', 'conductivity_', num2str( 1/dt*t ) ], 'D' );

	end

	% update state file
	save( [ simpath, 'state.txt' ], 'a0', 'a', 't', 'newpath', '-ascii' );


end
