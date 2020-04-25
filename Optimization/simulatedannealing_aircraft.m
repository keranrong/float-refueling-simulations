function [costobject, take_off_distance2, costobject2, fuel_consumption] = simulatedannealing_aircraft(iptipt)
wing_span = iptipt(1);
thr_w_ratio = iptipt(2);
aspect_ratio = iptipt(3);
sweep_angle = iptipt(4);
mto_weight = iptipt(5);

initial_parameterss;
logistics.distance_refueling = 26400*0; %[km] the distance between two refueling for same refeuling airplane, 5 miles as the minimum safety distance
refueling_aircraft.wing_span = wing_span; % wing-span [ft] of refueling aircraft
refueling_aircraft.weight_takeoff = mto_weight; % take-off weight of refueling aircraft [lb]
refueling_aircraft.AR = aspect_ratio; % aspect ratio of refueling aircraft
refueling_aircraft.sweep_angle = sweep_angle;  % Sweep angle [deg]
refueling_aircraft.thrust_weight_ratio = thr_w_ratio; % Thrust to weight ratio[-]
flag_catapult = 0; % take-off from island
refueling_aircraft.service_range = 1000;% service range km
[max_fuel_saved1, x_pos1, Weights1, take_off_distance1] = aircraft_calculation(refueling_aircraft, target_airplane, logistics, flag_catapult);
flag_catapult = 1; % take-off from ships
refueling_aircraft.service_range = 500;% service range km
[max_fuel_saved2, x_pos2, Weights2, take_off_distance2] = aircraft_calculation(refueling_aircraft, target_airplane, logistics, flag_catapult);

initial_constraints;
load('constraints.mat');
h1 = max(0, take_off_distance1 - Length_Landairport * Safety_factor);
h2 = max(0, take_off_distance2 - Length_Mothership * Safety_factor);
h3 = max(max(0, -x_pos1));
h4 = max(max(0, -x_pos2));
h5 = max(0, -max_fuel_saved1);
h6 = max(0, -max_fuel_saved2);

panelty = 1e10;
% costobject = Weights2(end-1)/1e3 - Weights2(end)/1e3 + panelty * (h1^2 + h2^2 + h3^2 + h4^2 + h5^2 + h6^2);
% costobject = -max_fuel_saved2/1e3 + panelty * (h1^2 + h2^2 + h3^2 + h4^2 + h5^2 + h6^2);
costobject = - (Weights1(end-1) - Weights1(end)) + panelty * (h1^2 + h2^2 + h3^2 + h4^2 + h5^2 + h6^2);
costobject2 = - (Weights2(end-1) - Weights2(end)) + panelty * (h1^2 + h2^2 + h3^2 + h4^2 + h5^2 + h6^2);
fuel_consumption = Weights1(end);
end