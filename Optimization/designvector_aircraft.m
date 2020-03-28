function [costobject, costobject2, take_off_distance1] = designvector_aircraft(iptipt)
wing_span = iptipt(1);
thr_w_ratio = iptipt(2);
aspect_ratio = iptipt(3);
sweep_angle = iptipt(4);
mto_weight = iptipt(5);

initial_parameterss;
refueling_aircraft.wing_span = wing_span; % wing-span [ft] of refueling aircraft
refueling_aircraft.weight_takeoff = mto_weight; % take-off weight of refueling aircraft [lb]
refueling_aircraft.AR = aspect_ratio; % aspect ratio of refueling aircraft
refueling_aircraft.sweep_angle = sweep_angle;  % Sweep angle [deg]
refueling_aircraft.thrust_weight_ratio = thr_w_ratio; % Thrust to weight ratio[-]
flag_catapult = 0; % take-off from island
[max_fuel_saved1, x_pos1, Weights1, take_off_distance1] = aircraft_calculation(refueling_aircraft, target_airplane, logistics, flag_catapult);
flag_catapult = 1; % take-off from ships
[max_fuel_saved2, x_pos2, Weights2, take_off_distance2] = aircraft_calculation(refueling_aircraft, target_airplane, logistics, flag_catapult);

initial_constraints;

h1 = max(0, take_off_distance1 - Length_Landairport * Safety_factor);
h2 = max(0, take_off_distance2 - Length_Mothership * Safety_factor);
h3 = max(max(0, -x_pos1));
h4 = max(max(0, -x_pos2));
h5 = max(0, -Weights1(end-1));
h6 = max(0, -Weights2(end-1));
panelty = 1e10;

% Weights = [W0,W1,W2,W3,W3-dW,W5,W6,W7,capacity,fuel_consumed];
% [W0,W1,W2,W3,W3-dW,W5,W6,W7,capacity,fuel_consumed] = Weights1;
% costobject = Weights2(end-1)/1e3 - Weights2(end)/1e3 + panelty * (h1^2 + h2^2 + h3^2 + h4^2 + h5^2 + h6^2);
% costobject = -max_fuel_saved2/1e3 + panelty * (h1^2 + h2^2 + h3^2 + h4^2 + h5^2 + h6^2);
% costobject2 = -max_fuel_saved1/1e3 + panelty * (h1^2 + h3^2 + h5^2);


costobject = -(Weights2(end-1)-Weights2(end)) + panelty * (h1^2 + h2^2 + h3^2 + h4^2 + h5^2 + h6^2);
costobject2 = -(Weights1(end-1)-Weights1(end)) + panelty * (h1^2 + h3^2 + h5^2);

end