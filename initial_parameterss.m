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
target_airplane.Range_target = 850 * 13.5; % Range of flights [m-ft]
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
logistics.number_refueling = 5; % number of refueling for same refueling airplane 
logistics.number_target = 1; % number of refueling  for same target airplane 
logistics.distance_refueling = 26400*1; %[km] the distance between two refueling for same refeuling airplane, 5 miles as the minimum safety distance
% According to FAA regulations
flag_catapult = 1;
% save('parameters.mat','flag_catapult', 'logistics', 'refueling_aircraft', 'target_airplane');

% %% Airbus A350
% target_airplane.target_cruise_mach = 903/ 1076.59580000000; % 533 mph
% target_airplane.SFC_target = 0.545; % Specific fuel consumption ratio
% target_airplane.LD_ratio_target = 	21; % Rodrigo Martínez-Val; et al. (January 2005). "Historical evolution of air transport productivity and efficiency". 43rd AIAA Aerospace Sciences Meeting and Exhibit. doi:10.2514/6.2005-121
% target_airplane.empty_weight = 314000; % operating empty weight [lb]
% target_airplane.max_payload = 243662 ; % max payload [lb]
% 
% %% Boeing 777
% target_airplane.target_cruise_mach = 892/ 1076.59580000000; % 533 mph
% target_airplane.SFC_target = 0.545; % Specific fuel consumption ratio
% target_airplane.LD_ratio_target = 	21; % Rodrigo Martínez-Val; et al. (January 2005). "Historical evolution of air transport productivity and efficiency". 43rd AIAA Aerospace Sciences Meeting and Exhibit. doi:10.2514/6.2005-121
% target_airplane.empty_weight = 320000; % operating empty weight [lb]
% target_airplane.max_payload = 766000- target_airplane.empty_weight; % max payload [lb]
% 
% % Singapore Airlines SQ 21 -> A350-900
% target_airplane.Range_target = 15344; % Range of flights [km]
% target_airplane.target_cruise_mach = 903/ 1076.59580000000; % 533 mph
% target_airplane.SFC_target = 0.565; % Specific fuel consumption ratio
% target_airplane.LD_ratio_target = 21; % Rodrigo Martínez-Val; et al. (January 2005). "Historical evolution of air transport productivity and efficiency". 43rd AIAA Aerospace Sciences Meeting and Exhibit. doi:10.2514/6.2005-121
% target_airplane.empty_weight = 314000; % operating empty weight [lb]
% target_airplane.max_payload = 243662 ; % max payload [lb]
% % % Singapore Airlines SQ 37, SQ 35 -> A350-900
% target_airplane.Range_target = 14114; % Range of flights [km]
% target_airplane.target_cruise_mach = 903/ 1076.59580000000; % 533 mph
% target_airplane.SFC_target = 0.565; % Specific fuel consumption ratio
% target_airplane.LD_ratio_target = 	21; % Rodrigo Martínez-Val; et al. (January 2005). "Historical evolution of air transport productivity and efficiency". 43rd AIAA Aerospace Sciences Meeting and Exhibit. doi:10.2514/6.2005-121
% target_airplane.empty_weight = 314000; % operating empty weight [lb]
% target_airplane.max_payload = 243662 ; % max payload [lb]
% % % Delta Air Lines DL 201 -> Boeing 777
% target_airplane.Range_target = 13581; % Range of flights [km]
% target_airplane.target_cruise_mach = 892/ 1076.59580000000; % 533 mph
% target_airplane.SFC_target = 0.565; % Specific fuel consumption ratio
% target_airplane.LD_ratio_target = 	21; % Rodrigo Martínez-Val; et al. (January 2005). "Historical evolution of air transport productivity and efficiency". 43rd AIAA Aerospace Sciences Meeting and Exhibit. doi:10.2514/6.2005-121
% target_airplane.empty_weight = 320000; % operating empty weight [lb]
% target_airplane.max_payload = 766000- target_airplane.empty_weight; % max payload [lb]
% % % Philippine Airlines PR 119 -> Boeing 777
% target_airplane.Range_target = 13230; % Range of flights [km]
% target_airplane.target_cruise_mach = 892/ 1076.59580000000; % 533 mph
% target_airplane.SFC_target = 0.565; % Specific fuel consumption ratio
% target_airplane.LD_ratio_target = 	21; % Rodrigo Martínez-Val; et al. (January 2005). "Historical evolution of air transport productivity and efficiency". 43rd AIAA Aerospace Sciences Meeting and Exhibit. doi:10.2514/6.2005-121
% target_airplane.empty_weight = 320000; % operating empty weight [lb]
% target_airplane.max_payload = 766000- target_airplane.empty_weight; % max payload [lb]
% % % American Airlines AA 125 -> Boeing 777-300ER
% target_airplane.Range_target = 13072; % Range of flights [km]
% target_airplane.target_cruise_mach = 892/ 1076.59580000000; % 533 mph
% target_airplane.SFC_target = 0.565; % Specific fuel consumption ratio
% target_airplane.LD_ratio_target = 	21; % Rodrigo Martínez-Val; et al. (January 2005). "Historical evolution of air transport productivity and efficiency". 43rd AIAA Aerospace Sciences Meeting and Exhibit. doi:10.2514/6.2005-121
% target_airplane.empty_weight = 320000; % operating empty weight [lb]
% target_airplane.max_payload = 766000- target_airplane.empty_weight; % max payload [lb]
