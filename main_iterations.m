addpath('.\ship_model');
addpath('.\ship_datebase');

%% overwrite based aircraft structure;
refueling_aircraft = struct();
refueling_aircraft.wing_span = 132; % wing-span [ft] of refueling aircraft
refueling_aircraft.weight_takeoff = 150000; % take-off weight of refueling aircraft [lb]
refueling_aircraft.AR = 10.3; % aspect ratio of refueling aircraft
refueling_aircraft.sweep_angle = 25;  % Sweep angle [deg]
refueling_aircraft.thrust_weight_ratio = 0.253; % Thrust to weight ratio[-]
refueling_aircraft.service_range = 500;% service range km

%%  Parameter of target aircraft (baseline: Boeing 767)
target_airplane = struct();
target_airplane.target_cruise_mach = 0.8; % 533 mph
target_airplane.cruise_altitude = 35000; % ft cruise altitude for operations
target_airplane.SFC_target = 0.6; % Specific fuel consumption ratio
target_airplane.Range_target = 850 * 12.3; % Range of flights [m-ft]
target_airplane.LD_ratio_target = 	16.1; % Rodrigo Martínez-Val; et al. (January 2005). "Historical evolution of air transport productivity and efficiency". 43rd AIAA Aerospace Sciences Meeting and Exhibit. doi:10.2514/6.2005-121
% Take_off_weight = 412000; % take-off weight [lb]
target_airplane.empty_weight = 198440; % empty weight [lb]
target_airplane.max_payload = 96560; % max payload [lb]

[max_fuel_saved, x_pos, Weights, take_off_distance] = aircraft_calculation(refueling_aircraft,target_airplane);

%% Mothership availability criteria
L = [205, 245, 285, 330, 415];
factor = [1,2];
dirs = [15,45,75];%0:45:180; linspace(0,90,4);

mothership.length = 245;
mothership.factor = 1;
mothership.MAX_ALLOW_HEAVE = 0.4;
mothership.MAX_ALLOW_ROLL = 1.5;
% [dir, exceeding_prob, limit_type]= ship_calculation(mothership);