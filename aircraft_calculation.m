
%% This file is used to calculate the refueling aircraft' performance and logisitics
% Created by KRg/Gautam 30/05/2020,
% modified to a function verison of the implementation
function [max_fuel_saved, x_pos, Weights, take_off_distance] = aircraft_calculation(refueling_aircraft,target_airplane, logistics)
%% Constant
g = 32.174; % gravity
flag_catapult = 1; % On/Off Catapult

%% Initial sizing of aircraft
%{
wing_span = 132; % wing-span[ft] of refueling aircraft
weight_takeoff = 52000; % take-off weight of refueling aircraft [lb]
AR = 10.3; % aspect ratio of refueling aircraft
sweep_angle = 25/180*pi; % Sweep angle of S-3 Viking
thrust_weight_ratio = 0.2; % Thrust to weight ratio
service_range = 500 * 3280.84;% service range km to ft
%}

% overwrite based aircraft structure;
wing_span = refueling_aircraft.wing_span; % wing-span[ft] of refueling aircraft
weight_takeoff = refueling_aircraft.weight_takeoff; % take-off weight of refueling aircraft [lb]
AR = refueling_aircraft.AR; % aspect ratio of refueling aircraft
sweep_angle = refueling_aircraft.sweep_angle/180*pi; % Sweep angle of S-3 Viking
thrust_weight_ratio = refueling_aircraft.thrust_weight_ratio; % Thrust to weight ratio
service_range = refueling_aircraft.service_range * 3280.84;% service range km to ft

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
empty_weight = target_airplane.empty_weight; % empty weight [lb]
max_payload = target_airplane.max_payload; % max payload [lb]


%% Initialization
% We adopted airfoil bac XXX (used in boeing 747) for mean wing section (parameter)
% and Turbofan engine LEAP-1C used in COMAC C919 (released in 2021)
% Mach = Mach0;
[W_empty, W_full]=weightestimation(weight_takeoff); % weight estimatin [lb] W_empty: empty weight[lb], W_full: full take-off weight[lb]
% [~, ~, a, alpha0, ClMax, K, Kdelta, H]=sizing_aircraft(wing_span, AR, sweep_angle, Mach); % aerodynamic coefficient
[tda, SFC_SL, SFC]=engine_spec(); % engine specification data
%control thrust to weight ratio
Thr = thrust_weight_ratio *W_full;
W0= W_full; % take - off weight

%% segment 1: Aircraft take-off condition
%%% initialization %%%
Mach = 0.2; % for take-off/landing Mach is set to be 0.2
[Cd0, S, ~, ~, ClMax, K, Kdelta, H]=sizing_aircraft(wing_span, AR, sweep_angle, Mach); % aerodynamic coefficient

u=.025; % coefficient of friction for tires to ground (based on STOL take-off rule, see Nicolai p 257
Clgrd = ClMax * 1.2 * Kdelta; % assume 20% of epand of full-span LE flap and a correction factor see Nicolai page 241
[rho, ~]=air_physics(0);% air density @ ground

% Deduction of drage coefficient due to ground see Nicolai's page 259
hb = H/2/wing_span;
sigma = 1 - 1.32 * hb /(1.05 + 7.4 * hb);

Cdgrd = Cd0 + K*ClMax^2 - sigma*ClMax^2/pi/AR; % The reduction in induced drag of the aircraft in ground effect
Vs = sqrt(2 * (W0 / S) / (rho(1) * ClMax)); % stall velocity at maximum lift coefficient with take-off weight
sm=1.2; %Stall margin requrired see Nicolai p 257
% disp([ 'stall speed:',num2str(Vs/airspeed)]);
Vr = sm * Vs;

%%% Take-off numerical simulation %%%
if flag_catapult==0
    thr_catapult = 0;
else
    % catapult baseline: C-13, stroke = 310 feet, 80,000 pound (18t) at 140.0 knots
    % thrust is calculated by energy consumed / stroke
    thr_catapult = 0.5 * 80000 * 140 ^ 2 / 310 / g; % kinetic energy / stroke unit:lb
    stroke_limit = 310;
    % C-7,  weaker and older verison
    thr_catapult = 0.5 * 40000 * 148 ^ 2 / 253 / g; % kinetic energy / stroke unit:lb
    stroke_limit = 253;    
end

%initial velocity and time
v=0;
t=0;
x=0;
dt = 0.001; % timestamps [sec]
W = W_full;
Thr = (Thr + thr_catapult);
while v<Vr
    t = t+dt;
    if x < stroke_limit
        dvdt = (g./W).*((Thr + thr_catapult).*cosd(tda)-0.5.*rho(1).*S.*Cdgrd.*v.^2-u.*(W-0.5.*rho(1).*S.*Clgrd.*v.^2- (Thr + thr_catapult).*sind(tda)));
    else
        dvdt = (g./W).*((Thr + 0).*cosd(tda)-0.5.*rho(1).*S.*Cdgrd.*v.^2-u.*(W-0.5.*rho(1).*S.*Clgrd.*v.^2- (Thr + 0).*sind(tda)));
    end
    v = v + dvdt * dt;
    x = x + v * dt;
    FuelSpentTO = SFC_SL*Thr*dt*(1/3600);
    W = W-(FuelSpentTO*g);
end

take_off_distance = x;
W1= W; % the weight after take-off

%% segment 2: Aircraft Climb section
% Mach number is calculated iteratively to match the speed
Mach = 0.8; % inital mach number
Mach_n_1 = 0;
dt = 1;
h = 0;
W = W1;
t = 0;
Thr0 = Thr;
[rho0, ~]=air_physics(0);

while (h <cruise_altitude)
    [rrho, airspeed]=air_physics(h);
    Thrr = Thr0 / rho0 * rrho;
    count = 1;
    while(abs(Mach-Mach_n_1)>= 0.1 && count<10)
        Mach = Mach_n_1;
        [Cd0, S, ~, ~, ~, K, ~, ~]=sizing_aircraft(wing_span, AR, sweep_angle, Mach); % aerodynamic coefficient
        % [Me, Mf, Cd0, S, a, alpha0, ClMax, K, Cf, alphamax, Kdelta, ~]=sizing_aircraft(L,wing_span,AR,weight_takeoff,sweep_angle,Mach);
        Cl=(-(Thrr/W)+sqrt((Thrr/W).^2+12*Cd0*K))/(2*K); % Cl for max rate of climb assuming thrust independent of airspeed
        V = sqrt(W./(0.5.*rrho*S.*Cl));
        Mach_n_1 = V / airspeed; % convert to Mach number
        count = count + 1;
    end
    Cd=Cd0+K*Cl.^2;
    singam=(Thrr/W)-(Cd./Cl);
    dhdt=V.*singam'; % sink rate
    h = h + dhdt*dt; % climbing
    FuelSpentClimb = SFC.*Thr.*dt./3600;
    W = W - (FuelSpentClimb);
    t = t + dt;
end

W2 = W;

%% Section 3: approaching
Mach = target_cruise_mach;
[Cd0, S, a, alpha0, ClMax, K, Kdelta, H]=sizing_aircraft(wing_span, AR, sweep_angle, Mach); % aerodynamic coefficient
[tda, SFC_SL, SFC]=engine_spec(); % engine specification data
[rho, airspeed]=air_physics(cruise_altitude);
u = Mach * airspeed; % mach to velocity ft/sec
max_LD = 1/(2*sqrt(Cd0*K)); % Nocolai page 76
% service_range_approach = service_range;
service_range_approach = service_range + logistics.number_refueling * logistics.distance_refueling;
W3 = W2 * exp(-SFC/3600 * service_range_approach/(u*max_LD)); % Breguet Range equations Nicolai p 78

%% Segment 4: refueling
%A single flying boom can transfer fuel at approximately 6,000 lbs per
%minute;
% Howeverm the refueling capacity can be treated as the output based on the
% service range, thus what we are going to do is that we are going to
% calculate needed landing and return to back-track how much fuel we can
% served
% We treated the service range as a equailvalent SFC factor.
d_SFC = 6000*60;
% equalvalent SFC is much bigger than the Engine SFC... We can treated the
% refueling is instant and thus ignore the time.
%% 
%% Segment 5 & 6: landing -> return
W7= W_empty; % Weight after landed.
W6 = W7 / 0.995; % Wetght before landed based on Hisotical data see Raymer page 21.
W5 = W6/exp(-SFC/3600 * service_range/(u*max_LD)); % Breguet Range equations Nicolai p 78

if W3 < W5
    disp('impossible, please change your serivce range');
else
    capacity = W3-W5;
    fuel_comsumed = W_full-W_empty-(W3-W5);
end

%% Segment 7( show the optimzed position ): Logistics: fuel saved for target airplane
% In this section, we will calculate how much fuels we saved for
% severviability of refueling mission
% We use back-track method to do the calculation e.g. from landing to
% take-off
%{
dW = capacity;
Mach0 = target_cruise_mach;
[rho, airspeed]=air_physics(cruise_altitude);
u = Mach0 * airspeed; % cruise speed mach to velocity ft/sec

x = linspace(0*Range_target,Range_target*1,1000); % a range of x for testing
% W0-take off-> W1 -Climb-> W2 -range-> W3 -refuel->W3+dW -range->W4->W5
% Wr: weight with refueled backtrack to take-off weight
Wtarget_0 = empty_weight + max_payload;
Wr = Wtarget_0; % MTOW + Maxpayload;
Wr = Wr/0.995; % Landing see Raymer page 21
Wr = Wr./exp(-(Range_target-x)*SFC_target/3600/u/LD_ratio_target);
Wr = max(Wr - dW,Wtarget_0);
Wr = Wr./exp(-(x)*SFC_target/3600/u/LD_ratio_target);
Wr = Wr / 0.985;% historial date for climb see Raymer page 21;
Wr = Wr / 0.970; % take-off weight see Raymer page 21;
% Wn: weight without refueled backtrack to take-off weight
Wn = Wtarget_0; % MTOW + Maxpayload;
Wn = Wn/0.995; % Landing see Raymer page 21
Wn = Wn./exp(-(Range_target)*SFC_target/3600/u/LD_ratio_target);
Wn = Wn / 0.985;% historial date for climb see Raymer page 21;
Wn = Wn / 0.970; % take-off weight see Raymer page 21;
total_fuel_saved = Wn - Wr - dW - fuel_comsumed; % total fuel saved in lb

%{
figure;
plot(x, total_fuel_saved,'--');
title(['C130 max saved',num2str(max(total_fuel_saved)),'lb'])
xlabel('location to refuel x[m]');
ylabel('fuel saved[lb]');
grid on
%}
[max_fuel_saved,t2] = max(total_fuel_saved);
Weights = [W0,W1,W2,W3,W3-dW,W5,W6,W7,dW,fuel_comsumed];
x_pos = x(t2)/3280.84;

%}

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

Wtarget_0 = empty_weight + max_payload;
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



total_fuel_saved = (Wn - Wr) / logistics.number_target * logistics.number_refueling - capacity - fuel_comsumed; % total fuel saved in lb

max_fuel_saved = total_fuel_saved; 


x_pos = (Range_target - rr.*cumsum(ones(logistics.number_target,1))) / 3280.84;
Weights = [W0,W1,W2,W3,W3-dW,W5,W6,W7,dW,fuel_comsumed];

end