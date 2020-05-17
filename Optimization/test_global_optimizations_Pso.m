%% This script is used for perform the global optimization using simulated annealing method
% Keran Rong
options = optimoptions('particleswarm','SwarmSize',300);
initial_constraints;
fun = @simulatedannealing_aircraft;
shipLL = [205,245,285,330,415,9000];
initial_constraints;
% x_optimal = zeros(5,5);
for j = 1:length(shipLL) % mot_len = shipLL
    shipLL(j)
    Length_Mothership = shipLL(j)*3.28084; % Length of ship [m->ft] % 1.2*9000;%
    save('constraints.mat','Length_Mothership');
    clear x_final
    for i = 1:1
        lb = [65,    0.2,  5.5, 0, 100000];
        ub = [132,  0.35, 10.1, 25, 200000];
        x = particleswarm(fun,5,lb,ub,options);
        if ~exist('x_final','var')
            x_final = x;
        end
% %         x1 = fminunc(@gradient_aircraft,x);
        if simulatedannealing_aircraft(x) < simulatedannealing_aircraft(x_final)
            x_final = x;
        end
    end
    x_optimal(:,j)= x_final;
end
x_optimal= x_optimal';
% x = x_optimal(:,3);
x= [132, 0.349999960215063, 7.90521922328925, 0.00343016008608858, 122355.552943517];