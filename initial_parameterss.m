%% overwrite based aircraft structure;
refueling_aircraft = struct();
refueling_aircraft.wing_span = 106.4; % wing-span [ft] of refueling aircraft
refueling_aircraft.weight_takeoff = 105000; % take-off weight of refueling aircraft [lb]
refueling_aircraft.AR = 10.1; % aspect ratio of refueling aircraft
refueling_aircraft.sweep_angle = 16.67;  % Sweep angle [deg]
refueling_aircraft.thrust_weight_ratio = 0.3786;% 0.353; % Thrust to weight ratio[-]
refueling_aircraft.service_range = 500;% service range km

%%  Parameter of target aircraft (baseline: Boeing 767)
target_airplane = struct();
target_airplane.target_cruise_mach = 0.8; % 533 mph
target_airplane.cruise_altitude = 35000; % ft cruise altitude for operations
target_airplane.SFC_target = 0.6; % Specific fuel consumption ratio
target_airplane.Range_target = 850 * 14.3; % Range of flights [m-ft]
target_airplane.LD_ratio_target = 	16.1; % Rodrigo Martínez-Val; et al. (January 2005). "Historical evolution of air transport productivity and efficiency". 43rd AIAA Aerospace Sciences Meeting and Exhibit. doi:10.2514/6.2005-121
% Take_off_weight = 412000; % take-off weight [lb]
target_airplane.empty_weight = 198440; % empty weight [lb]
target_airplane.max_payload = 96560; % max payload [lb]

% %% Logistics strategy
% logistics = struct();
% logistics.number_refueling = 1; % number of refueling for same refueling airplane 
% logistics.number_target = 1; % number of refueling  for same target airplane 
% logistics.distance_refueling = 26400*1; %[km] the distance between two refueling for same refeuling airplane, 5 miles as the minimum safety distance
% % According to FAA regulations
% flag_catapult = 1;

%% Logistics strategy
logistics = struct();
logistics.number_refueling = 1; % number of refueling for same refueling airplane 
logistics.number_target = 1; % number of refueling  for same target airplane 
logistics.distance_refueling = 26400*1; %[km] the distance between two refueling for same refeuling airplane, 5 miles as the minimum safety distance
% According to FAA regulations
flag_catapult = 1;