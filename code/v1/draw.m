clf

%grid figure
%figure( 1 )
%imagesc( grid, [0 3] )
%axis image

%colormap is coded as:
%colormap( [ 1 0 0 ;     %red    = ghostland
%            0 1 0 ;     %green  = freeland
%            0 0 1 ;     %blue   = node
%            1 1 0 ] );  %yellow = junctionnode
        
%path figure
figure( 1 )
imagesc( path )
axis image
colormap( 'summer' )

pause(0.01)