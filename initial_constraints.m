%SERVICE_RANGE = 300;
Length_Landairport = 1.2*9000; % length of airport on the island [ft]
Length_Mothership = 1.2*9000;% 205*3.28084; % Length of ship [m->ft] % 1.2*9000;%
Safety_factor = 1/1; % discount on length of the airport
% constraints: Enough
% %%
% % Constraints
% cc = (t1.Takeoff_Distance <= Length_Landairport * Safety_factor) & (t2.Takeoff_Distance <= Length_Mothership * Safety_factor) & (t2.Capacity - t2.Fuel_Consumed) > 0 & t2.Validation > 0;
% cc = (t1.Takeoff_Distance <= Length_Landairport * Safety_factor) & (t2.Takeoff_Distance <= Length_Mothership * Safety_factor) & t2.Capacity > 0 & t2.Validation > 0;
% if Capacity(count) >=0 &&  x_pos >= 0
%     Validation(count) = 1;
% else
%     Validation(count) = 0;
% end

lb = [65,    0.2,  5.5, 0, 40000];
ub = [132,  0.35, 10.1, 25, 300000];
% save('constraints.mat','Length_Landairport', 'Length_Mothership', 'Safety_factor', 'lb','ub');