clear all;
SERVICE_RANGE = 300;
Length_Landairport = 6000; % length of airport on the island
Length_Mothership = 1e8*315*3.28084; % Length of ship [ft->m]
Safety_factor = 1/1; % discount on length of the airport


str_e1 = sprintf('aircraft_sizing/C13_aircraft_range%d_catapult%d', SERVICE_RANGE, 0); % without aircraft catapult
str_e2 = sprintf('aircraft_sizing/C13_aircraft_range%d_catapult%d', SERVICE_RANGE, 1); % with aircraft catapult
% str_e2 = sprintf('aircraft_sizing/C13_aircraft_range%d_catapult%d', SERVICE_RANGE, 1); % with aircraft catapult

t1 = load(str_e1);
t2 = load(str_e2);

% constraints: Enough 
cc = (t1.Takeoff_Distance <= Length_Landairport * Safety_factor) & (t2.Takeoff_Distance <= Length_Mothership * Safety_factor) & (t2.Capacity - t2.Fuel_Consumed) > 0 & t2.Validation > 0;
cc = (t1.Takeoff_Distance <= Length_Landairport * Safety_factor) & (t2.Capacity - t2.Fuel_Consumed) > 0 & t2.Validation > 0;
cc = (t1.Takeoff_Distance <= Length_Landairport * Safety_factor) & (t2.Takeoff_Distance <= Length_Mothership * Safety_factor) & t2.Capacity > 0 & t2.Validation > 0;
% 
% figure;
% plot(t2.MTFW(cc), t2.Capacity(cc),'+');
% 
% figure;
% plot(t1.MTFW(cc), t2.Capacity(cc)-t2.Fuel_Consumed(cc),'+');
% figure;
% plot(t1.Fuel_Consumed(cc), t1.Capacity(cc),'+');
% mean(t2.Capacity(cc)-t2.Fuel_Consumed(cc))
% 
% figure;
% plot(t2.Takeoff_Distance(cc), t2.Config(cc,5),'+');
%% Main affect:

No_factors = 0;
[n1, n2] = size(t2.Config);
for f = 1:n2
    No_factors = No_factors + length(unique(t2.Config(:,f)));
end

Main_affect = zeros(No_factors+1,5);

cc1 = cc;
count = 1;
for f = 1:n2
    unique_value = unique(t2.Config(:,f));
    for v = 1:length(unique_value)
        Main_affect(count,1) = f;
        Main_affect(count,2) = unique_value(v);
        ccc = t2.Config(:,f) == unique_value(v);
        ccc = cc1 &ccc;
        Main_affect(count,3) = mean(t2.Capacity(ccc));
        Main_affect(count,4) = mean(t2.Fuel_Consumed(ccc));
        Main_affect(count,5) = mean(t2.Takeoff_Distance(ccc));
        count = count + 1;
    end
end
Main_affect(count,3) = mean(t2.Capacity(cc));
Main_affect(count,4) = mean(t2.Fuel_Consumed(cc));
Main_affect(count,5) = mean(t2.Takeoff_Distance(cc));

%% Pick up the optimal solution

Target_value = t2.Capacity - t2.Fuel_Consumed;
cc1 = cc & t2.Config(:,2) < 0.45;
Weights = unique(t2.MTFW(cc1));
target_values = zeros(length(Weights),5+1+1);

for i = 1: length(Weights)
   weight = Weights(i); 
   cc_temp = cc1 & t2.MTFW == weight;
   temp = Target_value;
   temp(~cc_temp)=-99;
   [max_value,ii] = max(temp); 
   target_values(i,:) = [t2.Config(ii,:), t2.Capacity(ii), t2.Fuel_Consumed(ii)];
end

figure;
plot(Weights,target_values(:,6)-target_values(:,7),'*');
