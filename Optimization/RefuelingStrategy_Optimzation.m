design_vector = [132.000000	0.350000	7.597821	0.000000	124379.187033
132.000000	0.350000	7.531587	0.000741	128209.150600
131.999998	0.350000	7.183211	0.000097	134309.825333
132.000000	0.350000	6.670715	0.004096	142826.399881
132.000000	0.350000	6.012412	0.006522	158304.079859
];
% 111.869617548	0.350000000	10.100000000	0.463278273	250000.000000000];
% design_vector = [111.869617548	0.350000000	10.100000000	0.463278273	250000.000000000
% 111.869617548	0.350000000	10.100000000	0.463278273	250000.000000000];
% 106.5	0.35	10.1	0.1	209078];
fuel_saved =zeros(size(design_vector,1),2);
Refueling_Strategy = zeros(size(design_vector,1),2);

initial_parameterss;

logistics.distance_refueling = 26400*2; %[km] the distance between two refueling for same refeuling airplane, 5 miles as the minimum safety distance
numbers_refueling = 1;
numbers_target = [1];

for iii = 1:size(design_vector,1)
    max_fuel_saved = -99999;
    for num_refuel = numbers_refueling
        for num_target = numbers_target
            %             num_target = 1;
            %             num_refuel = 5;
            iptipt = design_vector(iii,:);
            wing_span = iptipt(1);
            thr_w_ratio = iptipt(2);
            aspect_ratio = iptipt(3);
            sweep_angle = iptipt(4);
            mto_weight = iptipt(5);
%             simulatedannealing_aircraft(iptipt)
            logistics.number_refueling = num_refuel;
            logistics.number_target = num_target;
            logistics.distance_refueling = 26400*2; %[km] the distance between two refueling for same refeuling airplane, 5 miles as the minimum safety distance
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
            %             (Weights2(end-1) - Weights2(end))
            
            max_fuel_saved = max_fuel_saved2;
            fuel_saved(iii,:) = [max_fuel_saved1, max_fuel_saved2];
            Refueling_Strategy(iii,:) = [num_refuel,num_target];
            
            %             if max_fuel_saved <= max_fuel_saved1*logistics.number_target
            %                 max_fuel_saved = max_fuel_saved2;
            %                 fuel_saved(iii,:) = [max_fuel_saved1, max_fuel_saved2];
            %                 Refueling_Strategy(iii,:) = [num_refuel,num_target];
            %             end
        end
    end
    
end