function [] = draw( background, data, color, folderpath, filename )
%DRAW exports graphic of current simulation.
%   Automatic graphic export with input parameters to adjust appearance.


	fig = figure( 'visible', 'off' );
	set( fig, 'color', background )
	imagesc( data )
	colormap( color )
	axis image
	axis off

	print( fig, '-dpng', [ folderpath, filename ] );


end

