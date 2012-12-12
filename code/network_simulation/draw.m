function [] = draw( data, color, folderpath, filename )
%DRAW exports graphic of current simulation.
%   Automatic graphic export with input parameters to adjust appearance.


	set( gcf, 'Position', [ 0 0 1 1 ] );
	imagesc( data )
	colormap( color )
	axis image
	axis off

	saveas( gcf, [ folderpath, filename,'.png' ] );


end

