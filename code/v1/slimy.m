%parameters
Y  = 30;    %vertical grid dimension
X  = 30;    %horizontal grid dimension
D0 = 1;     %initial conductivity
I0 = 2.00;  %initial flux
g  = 1.80;  %gamma
dt = 0.01;

%initialisation
initial

%main loop
for t=1:100000
    
    %mathematical model
    model

    %update values
    update
    
    %draw grid
    draw
    
end