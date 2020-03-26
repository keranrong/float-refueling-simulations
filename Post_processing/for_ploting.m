% Breguet range equation
initial_parameters;
[rho, airspeed]=air_physics(target_airplane.cruise_altitude);
u = target_airplane.target_cruise_mach * airspeed; 
time = 0:1:14;
service_range = u .* 3600 .* time;
W_final = target_airplane.empty_weight + target_airplane.max_payload;
W_0 = W_final .* exp(target_airplane.SFC_target .* time ./ (target_airplane.LD_ratio_target));
W_fuel = W_0 - W_final;
figure;
plot(time, W_fuel/1000);
xlabel('flight time [hr]');
ylabel('fuel consumed [1000lb]');
grid on 
title('fuel consumed versus flight time(based on boeing 767)');

figure;
plot(time, -target_airplane.SFC_target ./ 3600 .* service_range ./ (u .* target_airplane.LD_ratio_target));
hold on
plot(time, exp(-target_airplane.SFC_target ./ 3600 .* service_range ./ (u .* target_airplane.LD_ratio_target)));