function [max_fuel_saved, x_pos] = refueling_strategy(logistics,capacity,fuel_consumed,target_airplane)

%% Parameter of target aircraft (baseline: Boeing 767)
%{
target_cruise_mach = 0.8; % 533 mph
cruise_altitude = 35000; % ft cruise altitude for operations
SFC_target = 0.6; % Specific fuel consumption ratio
Range_target = 850 * 12.3 * 3280.84; % Range of flights [m-ft]
LD_ratio_target = 	16.1; % Rodrigo Martínez-Val; et al. (January 2005). "Historical evolution of air transport productivity and efficiency". 43rd AIAA Aerospace Sciences Meeting and Exhibit. doi:10.2514/6.2005-121
% Take_off_weight = 412000; % take-off weight [lb]
empty_weight = 198440; % empty weight [lb]
max_payload = 96560; % max payload [lb]
%}
target_cruise_mach = target_airplane.target_cruise_mach; % 533 mph
cruise_altitude = target_airplane.cruise_altitude; % 35000; % ft cruise altitude for operations
SFC_target = target_airplane.SFC_target; % 0.6; % Specific fuel consumption ratio
Range_target = target_airplane.Range_target * 3280.84; % Range of flights [m-ft]
LD_ratio_target = target_airplane.LD_ratio_target; % Rodrigo Martínez-Val; et al. (January 2005). "Historical evolution of air transport productivity and efficiency". 43rd AIAA Aerospace Sciences Meeting and Exhibit. doi:10.2514/6.2005-121
empty_weight_target = target_airplane.empty_weight; % empty weight [lb]
max_payload_target = target_airplane.max_payload; % max payload [lb]

Mach = target_cruise_mach;
[rho, airspeed]=air_physics(cruise_altitude);
u = Mach * airspeed; % mach to velocity ft/sec

%% Segment 7(already based on the optimzed position): Logistics: fuel saved for target airplane
% In this section, we calculated it based on the knowledge we have already
% know: All the fuel refueled will be used in the most last part of target airplane's
% jounery( The segment 7 got commemted shows the position versus fuel
% saved) However, this part of code allows mutlitple refueling for same
% target airplane and the mutlituple refueling for same refueling airplane.
% logistics = struct();
% logistics.number_refueling = 2; % number of refueling for same refueling airplane
% logistics.number_target = 2; % number of refueling  for same target airplane

dW = capacity / logistics.number_refueling; % amount of refuel to be refuel in one time

Wtarget_0 = empty_weight_target + max_payload_target;
Wr = Wtarget_0; % MTOW + Maxpayload;
Wr = Wr/0.995; % Landing see Raymer page 21
rr = 3600 * u * LD_ratio_target / SFC_target * log((dW+Wr)/Wr);

Wr = Wr ./ exp(-(Range_target - rr * logistics.number_target) * SFC_target / 3600 / u / LD_ratio_target);
Wr = Wr / 0.985;% historial date for climb see Raymer page 21;
Wr = Wr / 0.970; % take-off weight see Raymer page 21;

% Wn: weight without refueled backtrack to take-off weight
Wn = Wtarget_0; % MTOW + Maxpayload;
Wn = Wn/0.995; % Landing see Raymer page 21
Wn = Wn ./ exp(- (Range_target) * SFC_target / 3600 / u / LD_ratio_target);
Wn = Wn / 0.985;% historial date for climb see Raymer page 21;
Wn = Wn / 0.970; % take-off weight see Raymer page 21;

total_fuel_saved = (Wn - Wr) / logistics.number_target * logistics.number_refueling - capacity - fuel_consumed; % total fuel saved in lb

max_fuel_saved = total_fuel_saved;


x_pos = (Range_target - rr.*cumsum(ones(logistics.number_target,1))) / 3280.84;

end