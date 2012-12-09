function [] = analysis( simpath, dt, geo, cellsize )
%ANALYSIS computes all results of the simulation
%   All simulation data is processed and stored in appropriate form for
%   further use.


	% create analysis folder
	mkdir( [ simpath, 'analysis' ] );
	analysispath = [ simpath, 'analysis/' ];


	% analyse path
	analysis_path( simpath, dt, geo, analysispath );


	% convert to arcGIS
	analysis_arcgis( analysispath, cellsize );


	%% analyse path
	function [ D ] = analysis_path( simpath, dt, geo, analysispath )


		% get dimensions
		[ Y, X ] = size( geo );

		% define von Neumann neighbourhood (x y)
		neigh = [         0 -1;
			     -1  0;         1  0;
				          0  1       ];

		% list all conductivity files
		conductivity = dir( [ simpath, 'conductivity/conductivity_*.mat' ] );
		S = length( conductivity );

		% get enttime of simulation
		lastD = conductivity( S ).name;
		T = sscanf( lastD, 'conductivity_%i.mat' );

		% initialize path over time vectors
		timepath = zeros( 1, T+1 );
		time     = zeros( 1, T+1 );

		% initialize waitbar
		w = waitbar( 0, 'Please wait...' );

		for t = 0:T

			for s = 1:S

				currentD = conductivity( s ).name;

				if ( sscanf( currentD, 'conductivity_%i.mat' ) == t )

					path = geo;

					loadD = conductivity( s ).name;
					load( [ simpath, 'conductivity/' loadD ] );

					sumD = zeros( Y, X );

					for i = 1:X
						for j = 1:Y

							for k = 1:length( neigh )

								m = i+neigh( k, 1 );
								n = j+neigh( k, 2 );

								if ( geo( j, i ) > 0 && m >= 1 && n >= 1 && m <= X && n <= Y && geo( n, m ) > 0 )

									p = varnum( n, m, Y );
									q = varnum( j, i, Y );

									if ( geo( p ) ~= 3 && D( p, q ) > eps )

										path( p ) = 2;

									end

									if ( s == S && path( q ) > 1 )

										sumD( q ) = sumD( q )+D( p, q );

									end

								end

							end

						end
					end

					pathlength = sum( find( path == 2 ) );

					break

				end

			end
			
			time( t+1 )     = t*dt;
			timepath( t+1 ) = pathlength;

			save( [ analysispath, 'time' ], 'time' );
			save( [ analysispath, 'timepath' ], 'timepath' );

			waitbar( t/T );

		end

		close( w );

		save( [ analysispath, 'path' ], 'path' );
		save( [ analysispath, 'conductivity' ], 'sumD' );

	end


	%% arcGIS conversion
	function [ path, sumD ] = analysis_arcgis( analysispath, cellsize )


		% path
		load( [ analysispath, 'path.mat' ] );
		[ nrows, ncols ] = size( path );

		file = fopen( [ analysispath, 'path.txt' ], 'w' );
		
		header = { 'ncols        ', ncols;
		           'nrows        ', nrows;
		           'xllcorner    ', 0;
		           'yllcorner    ', 0;
		           'cellsize     ', cellsize;
		           'NODATA_value ', 0};

		for row = 1:size( header, 1 )

			fprintf( file, '%s%d\n', header{ row, : } );

		end

		fclose( file );

		dlmwrite( [ analysispath, 'path.txt' ], path, '-append', 'delimiter', ' ' );


		% conductivity
		load( [ analysispath, 'conductivity.mat' ] );
		[ nrows, ncols ] = size( sumD );

		file = fopen( [ analysispath, 'conductivity.txt' ], 'w' );
		
		header = { 'ncols        ', ncols;
		           'nrows        ', nrows;
		           'xllcorner    ', 0;
		           'yllcorner    ', 0;
		           'cellsize     ', cellsize;
		           'NODATA_value ', 0};

		for row = 1:size( header, 1 )

			fprintf( file, '%s%d\n', header{ row, : } );

		end

		fclose( file );

		dlmwrite( [ analysispath, 'conductivity.txt' ], sumD, '-append', 'delimiter', ' ' );


	end


end

