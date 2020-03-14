%% This script is used to optimzation the refueling airplane design
%% The tradspace exploration: maximum take-off weight versus (capacity - fuel consumed)
main_iterations; % load initalization

%% overwrite based aircraft structure;
refueling_aircraft = struct();
MTFW = [];
Capacity = [];
Validation = [];
Config = {};
SERVICE_RANGE = 500;
MAX_take_off_length = 253;
WING_SPAN = linspace(68,132,6);
Thr_Weight_Ratio = linspace(0.2,0.45,6); % See Nicolai p469
Sweep_Angle = linspace(0, 25, 4);
AspectRatio = linspace(5.57, 10.1,6);
MAX_TO_WEIGHT = linspace(40000, 175000,10);
FLAG_catapult = [0,1];
RANGES = 300:200:1100;


No_cases = length(WING_SPAN)*length(Thr_Weight_Ratio)*length(AspectRatio)*length(Sweep_Angle)*length(MAX_TO_WEIGHT);
for flag_catapult = [0,1]
    for SERVICE_RANGE = RANGES
        MTFW = zeros(No_cases,1);
        Capacity = zeros(No_cases,1);
        Fuel_Consumed = zeros(No_cases,1);
        Validation = zeros(No_cases,1);
        Config = zeros(No_cases,5);
        Takeoff_Distance = zeros(No_cases,1);
        
        count = 1;
        for wing_span = WING_SPAN
            for thr_w_ratio = Thr_Weight_Ratio
                for aspect_ratio = AspectRatio
                    for sweep_angle = Sweep_Angle
                        for mto_weight = MAX_TO_WEIGHT
                            disp(count);
                            refueling_aircraft.wing_span = wing_span; % wing-span [ft] of refueling aircraft
                            refueling_aircraft.weight_takeoff = mto_weight; % take-off weight of refueling aircraft [lb]
                            refueling_aircraft.AR = aspect_ratio; % aspect ratio of refueling aircraft
                            refueling_aircraft.sweep_angle = sweep_angle;  % Sweep angle [deg]
                            refueling_aircraft.thrust_weight_ratio = thr_w_ratio; % Thrust to weight ratio[-]
                            refueling_aircraft.service_range = SERVICE_RANGE;% service range km
                            [max_fuel_saved, x_pos, Weights, take_off_distance] = aircraft_calculation(refueling_aircraft,target_airplane,logistics,flag_catapult);
                            MTFW(count) = refueling_aircraft.weight_takeoff;
                            Capacity(count) = Weights(end-1) ; % capacity - fuel consumed
                            Fuel_Consumed(count) = Weights(end);
                            Config(count,:) = [wing_span, thr_w_ratio, aspect_ratio, sweep_angle, mto_weight];
                            Takeoff_Distance(count) = take_off_distance;
                            if Capacity(count) >=0 && max_fuel_saved >= 0
                                Validation(count) = 1;
                            else
                                Validation(count) = 0;
                            end
                            count  = count + 1;
                        end
                    end
                end
            end
        end
        str_e = sprintf('aircraft_sizinge/aircraft_range%d_catapult%d',SERVICE_RANGE,flag_catapult);
        save(str_e,'MTFW','Capacity','Fuel_Consumed','Validation','Config','Takeoff_Distance');
        
    end
end