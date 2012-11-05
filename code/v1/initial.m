%grid initialisation, grid is coded as:
grid = zeros( Y, X );   %0 = ghostland
                        %1 = freeland
                        %2 = node
                        %3 = junctionnode

                        
%path initialisation
path  = zeros( Y, X );

                        

%node initialisation
nodes = [  2 29 ;       %coordinates of nodes
           5  5 ;
          17 23 ;
           6 28 ;
          29 10 ;
           4 12 ;
          14 15 ;
          15 15 ;
          14 16 ;
          15 16 ;
          29 29 ;
           5 23 ;
          17  5 ;
          27 18 ;
          30  1 ;
          30  2 ;
          29  1 ;
          29  2 ;
          15  3 ];
       
 
%ghostland initialisation
ghost = [ 15  5 ;        %coordinates of ghostland
          16  5 ;
          17  5 ;
          16  6 ;
          17  6 ;
          18  6 ;
          17  7 ;
          18  7 ;
          19  7 ;
          18  8 ;
          19  8 ;
          20  8 ;
          19  9 ;
          20  9 ;
          21  9 ;
          20 10 ;
          21 10 ;
          22 10 ;
          21 11 ;
          22 11 ;
          23 11 ;
          24 11 ;
          25 11 ];  
       
       
%prepare grid
grid( :, : ) = 3;                               %set all to junctionnode

for i = 1:size( nodes, 1 )
    
    grid( nodes( i, 2 ), nodes( i, 1 ) ) = 2;   %set nodes
    
end

for i = 1:size( ghost, 1 )
    
    grid( ghost( i, 2 ), ghost( i, 1 ) ) = 0;   %set ghostland
    
end  
       

%define neighbourhood
neigh = [  0 -1 ;
           1 -1 ;
           1  0 ;
           1  1 ;
           0  1 ;
          -1  1 ;
          -1  0 ;
          -1 -1 ];    

      
%conductivity initialisation
D = zeros( X*Y, X*Y );

for i = 1:Y
    for j = 1:X
        
        for k = 1:size( neigh, 1 )
            
            m = i+neigh( k, 1 );
            n = j+neigh( k, 2 );
            
            if ( m>=1 && n>=1 && m<=Y && n<=X )
                
                if ( grid( m, n ) >= 2 )
                
                    D( varnum( i, j, X ), varnum( m, n, X ) ) = D0;     %set conductivity only to neighbours
                    
                end
                
            end
            
        end
        
    end
end


%flux initialisation
flux = zeros( X*Y, X*Y );