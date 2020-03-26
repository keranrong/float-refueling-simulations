clear all;
SERVICE_RANGE = 300;
Length_Landairport = 6000; % length of airport on the island
Length_Mothership = 1e8;% 415*3.28084; % Length of ship [ft->m]
Safety_factor = 1/1; % discount on length of the airport


str_e1 = sprintf('aircraft_sizing/C13_aircraft_range%d_catapult%d', SERVICE_RANGE, 0); % without aircraft catapult
str_e2 = sprintf('aircraft_sizing/C13_aircraft_range%d_catapult%d', SERVICE_RANGE, 1); % with aircraft catapult
% str_e2 = sprintf('aircraft_sizing/C13_aircraft_range%d_catapult%d', SERVICE_RANGE, 1); % with aircraft catapult

t1 = load(str_e1);
t2 = load(str_e2);

% constraints: Enough
%%
% Constraints
cc = (t1.Takeoff_Distance <= Length_Landairport * Safety_factor) & (t2.Takeoff_Distance <= Length_Mothership * Safety_factor) & (t2.Capacity - t2.Fuel_Consumed) > 0 & t2.Validation > 0;
cc = (t1.Takeoff_Distance <= Length_Landairport * Safety_factor) & (t2.Takeoff_Distance <= Length_Mothership * Safety_factor) & t2.Capacity > 0 & t2.Validation > 0;

Target_value = t2.Capacity - t2.Fuel_Consumed;

cc1 = cc & t2.Config(:,2) < 0.4;
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

% figure;
% plot(Weights,target_values(:,6)-target_values(:,7),'*');
%%
initial_parameters;
strategy = zeros(length(Weights),4);

%% strategy 1: one refueling one target airplane
logistics.number_refueling = 1; % number of refueling for same refueling airplane
logistics.number_target = 1; % number of refueling  for same target airplane
logistics.distance_refueling = 26400*1; %[km] the distance between two refueling for same refeuling airplane, 5 miles as the minimum safety distance
no_strategy = 1;
for i = 1: length(Weights)
    refueling_aircraft.wing_span = target_values(i,1); % wing-span [ft] of refueling aircraft
    refueling_aircraft.weight_takeoff = target_values(i,5); % take-off weight of refueling aircraft [lb]
    refueling_aircraft.AR = target_values(i,3); % aspect ratio of refueling aircraft
    refueling_aircraft.sweep_angle = target_values(i,4);% Sweep angle [deg]
    refueling_aircraft.thrust_weight_ratio = target_values(i,2);% Thrust to weight ratio[-]
    refueling_aircraft.service_range = SERVICE_RANGE;% service range km
    [max_fuel_saved, ~] = refueling_strategy(logistics,target_values(i,6),target_values(i,7),target_airplane);
    strategy(i,no_strategy) = max_fuel_saved;
end
%% strategy 2: two refueling one target airplane
logistics.number_refueling = 1; % number of refueling for same refueling airplane
logistics.number_target = 2; % number of refueling  for same target airplane
logistics.distance_refueling = 26400*1; %[km] the distance between two refueling for same refeuling airplane, 5 miles as the minimum safety distance
no_strategy = 2;
for i = 1: length(Weights)
    refueling_aircraft.wing_span = target_values(i,1); % wing-span [ft] of refueling aircraft
    refueling_aircraft.weight_takeoff = target_values(i,5); % take-off weight of refueling aircraft [lb]
    refueling_aircraft.AR = target_values(i,3); % aspect ratio of refueling aircraft
    refueling_aircraft.sweep_angle = target_values(i,4);% Sweep angle [deg]
    refueling_aircraft.thrust_weight_ratio = target_values(i,2);% Thrust to weight ratio[-]
    refueling_aircraft.service_range = SERVICE_RANGE;% service range km
    [max_fuel_saved, ~] = refueling_strategy(logistics,target_values(i,6),target_values(i,7),target_airplane);
    strategy(i,no_strategy) = max_fuel_saved;
end
%% strategy 3: one refueling two target airplane
logistics.number_refueling = 2; % number of refueling for same refueling airplane
logistics.number_target = 1; % number of refueling  for same target airplane
logistics.distance_refueling = 26400*1; %[km] the distance between two refueling for same refeuling airplane, 5 miles as the minimum safety distance
no_strategy = 3;
for i = 1: length(Weights)
    refueling_aircraft.wing_span = target_values(i,1); % wing-span [ft] of refueling aircraft
    refueling_aircraft.weight_takeoff = target_values(i,5); % take-off weight of refueling aircraft [lb]
    refueling_aircraft.AR = target_values(i,3); % aspect ratio of refueling aircraft
    refueling_aircraft.sweep_angle = target_values(i,4);% Sweep angle [deg]
    refueling_aircraft.thrust_weight_ratio = target_values(i,2);% Thrust to weight ratio[-]
    refueling_aircraft.service_range = SERVICE_RANGE;% service range km
    [max_fuel_saved, ~] = refueling_strategy(logistics,target_values(i,6),target_values(i,7),target_airplane);
    strategy(i,no_strategy) = max_fuel_saved;
end
%% strategy 4: two refueling two target airplane
logistics.number_refueling = 2; % number of refueling for same refueling airplane
logistics.number_target = 2; % number of refueling  for same target airplane
logistics.distance_refueling = 26400*1; %[km] the distance between two refueling for same refeuling airplane, 5 miles as the minimum safety distance
no_strategy = 4;
for i = 1: length(Weights)
    refueling_aircraft.wing_span = target_values(i,1); % wing-span [ft] of refueling aircraft
    refueling_aircraft.weight_takeoff = target_values(i,5); % take-off weight of refueling aircraft [lb]
    refueling_aircraft.AR = target_values(i,3); % aspect ratio of refueling aircraft
    refueling_aircraft.sweep_angle = target_values(i,4);% Sweep angle [deg]
    refueling_aircraft.thrust_weight_ratio = target_values(i,2);% Thrust to weight ratio[-]
    refueling_aircraft.service_range = SERVICE_RANGE;% service range km
    [max_fuel_saved, ~] = refueling_strategy(logistics,target_values(i,6),target_values(i,7),target_airplane);
    strategy(i,no_strategy) = max_fuel_saved;
end
strategy*365*6*0.5