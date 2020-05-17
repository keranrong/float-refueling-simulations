function [AMP_2020, operation_cost, revenue, max_fuel_saved1, annual_fixed_cost] = aircraft_cost(x_aircraft,x_refueling, year, ship_id)
wto = x_aircraft(end); % take-off weight [lb]

%% The aircraft cost price is based on Roskam, J., Airplane Design Part VIII, 1990.
% Commercial Jet Empirical Data (60k lb < W_to < 1 million lb)
% wto = 124379
AMP_1989 = 10^(3.3191 + 0.8043*log10(wto));

inflation_rate = 2.08; % inflation rate 1989->2020
AMP_2020 = inflation_rate * AMP_1989;


%% calculate the operation cost related to operation
initial_parameterss;
logistics.distance_refueling = 26400*2; %[km] the distance between two refueling for same refeuling airplane, 5 miles as the minimum safety distance
num_refuel = x_refueling(1);
num_target = x_refueling(2);

wing_span = x_aircraft(1);
thr_w_ratio = x_aircraft(2);
aspect_ratio = x_aircraft(3);
sweep_angle = x_aircraft(4);
mto_weight = x_aircraft(5);

logistics.number_refueling = num_refuel;
logistics.number_target = num_target;
logistics.distance_refueling = 26400*2; %[km] the distance between two refueling for same refeuling airplane, 5 miles as the minimum safety distance
refueling_aircraft.wing_span = wing_span; % wing-span [ft] of refueling aircraft
refueling_aircraft.weight_takeoff = mto_weight; % take-off weight of refueling aircraft [lb]
refueling_aircraft.AR = aspect_ratio; % aspect ratio of refueling aircraft
refueling_aircraft.sweep_angle = sweep_angle;  % Sweep angle [deg]
refueling_aircraft.thrust_weight_ratio = thr_w_ratio; % Thrust to weight ratio[-]

flag_catapult = 1; % take-off from ships
refueling_aircraft.service_range = 400; %500/2;% service range km
if ship_id == 6
    flag_catapult = 0; % take-off from ships
    refueling_aircraft.service_range = 1000;% service range km
    refueling_aircraft.service_range = 500;% service range km
end
[max_fuel_saved1, ~, Weights, ~] = aircraft_calculation(refueling_aircraft, target_airplane, logistics, flag_catapult);
%             (Weights2(end-1) - Weights2(end))
% Weights = [W0,W1,W2,W3,W3-dW,W5,W6,W7,capacity,fuel_consumed];
fuel_consumed = Weights(end);
%%
% https://www.eia.gov/environment/emissions/co2_vol_mass.php
% 6.7 lbs/gallon
co2emssion_equivalent = 21.10/6.71; %Co2 emission[lb] / jet fuel [lb]

carbon_tax = 50;% State and Trends of Carbon Pricing 2019[USD/ton]
carbon_tax = carbon_tax/2205; % USD/Ton -> USD/lb
growth_rate_carbon_tax = (75/60)^0.1-1; % carbon tax rate, page 22
carbon_tax = carbon_tax*(1+growth_rate_carbon_tax).^year;
% Jet fuel cost, based on J Rodrigue The geography of transport system
jet_price = 2.2; %usd per gallon
jet_price = jet_price/6.71;% USD per lb
%
%% operation cost based on the study of J Rodrigue The geography of transport system
% Based on the operations passenger airline costs, U.S. 2019
% operation_cost = fuel_consumed * jet_price/0.177;
%% operation cost based on the study of bearue of transportation statistics
% Based on the operations passenger airline costs, U.S. 2019
% operation_cost = fuel_consumed * jet_price/0.177/0.7;
operation_cost = fuel_consumed * (jet_price + 0 * co2emssion_equivalent * carbon_tax)/0.25*(1-0.25);
annual_fixed_cost = 0;
% variable_cost = (200 + 1099 + 3004)*1.5;
flight_time = 2*refueling_aircraft.service_range/753.6171; %1.25; % 2*refueling_aircraft.service_range/800;
if ship_id == 6
    %     variable_cost = (200 + 807 + 2024) * 1.4 * 1.25*2;
    variable_cost = (200 + 807 + 2024) * 1.4 * flight_time*1;
    
else
    variable_cost = (200 + 807 + 2024) * 1.4 * flight_time*1;
end
operation_cost = variable_cost;
% operation_cost = fuel_consumed * (jet_price + 0*co2emssion_equivalent * carbon_tax)+variable_cost;
annual_fixed_cost = 473248 * 1.4;
% annual_fixed_cost = 461702;
%% operation cost based on the study of Markish, J. Valuation Techniques for Commercial Aircraft Program Design, S.M. Thesis, MIT,
%June 2002.
% Based on the operations passenger airline costs, U.S. 2019
% operation_cost = fuel_consumed * jet_price*1/0.2*0.8/0.7*0.8;
revenue = max_fuel_saved1*jet_price + max_fuel_saved1 * co2emssion_equivalent * carbon_tax;

end