%SERVICE_RANGE = 300;
Length_Landairport = 10000; % length of airport on the island
Length_Mothership = 415*3.28084; % Length of ship [m->ft]
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