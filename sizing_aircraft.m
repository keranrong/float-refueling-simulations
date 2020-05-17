function [Cd0, S, a, alpha0, ClMax, K, Clgrd, H, Keff, d_Cd0]=sizing_aircraft(wing_span, AR, sweep, Mach)
% AR: aspect ratio 10.1 for C-130, 7.73 for S-3 Viking, 6.96 for boeing 747
% 9.45 for new boeing 737 
% b: wing-span: 132.6 ft for C-130, 68ft for S-3A, 117 ft for boeing 737,
% 211 for boeing 747
% Wp: weight of pay-load:  11611 lb for S-3Viking 42000 for C-130
% L: length of the aircraft 53 ft for S-3A, 

%{
Wp = 11611;
L = 53;
b = 68;
sweep = 25/180*pi;
AR = 10.1;
Mach = 0.8;
%}

H = 22; % Default height of the aircraft
S  = wing_span^2 / AR; % project wing area S

[ClMax, Clo, Cd0, Cdmin,maxclcd, K, alpha0, alphamax, alpha_Cdmin, a0, Cmo, upper_alpha, lower_alpha] = airfoil_bacXXX(); % bacxxx at Re=1e6;

% corrected for induced angle of attack efficiency factor is assumed to be 1 see Caughey Page 17
a = cos(sweep);
a = 1 + ( pi * AR / a0 / a ).^2 .* (1 - Mach.^2 * a.^2);
a = pi * AR ./ (1 + sqrt(a)); 
% Thus Cl = a * (alpha - alpha0)
ClMax = (alphamax- alpha0)*a;


% Oswald span efficiency method see Raymer page 347
if sweep >= 30/180*pi
    e = 4.61 * (1 - 0.045*AR^0.68) * (cos(sweep*1.03))^0.15 -31;
else
    e = 1.78 * (1 - 0.045*AR^0.68) - 0.64;
end
K = 1 / pi / e / AR; % see Nicolai's page 50.

% Kdelta = (1-0.08*cos(sweep)^2)*(cos(sweep))^(3/4); % correction factor for ground lifting see Nicolai page 241
% due to the lack of date on fusage drag, now we assumed the Cd0 is same as
% Boeing 747-200
Mach = min(max(Mach,0.198),0.9);
MACH = [0.198, 0.65, 0.9]; % approach, low cruise, high cruise
Cd0 = [0.0751,0.0164,0.0305]; % approach, low cruise, high cruise
Cd0 = interp1(MACH, Cd0, Mach, 'spline'); % verified

% Mach = linspace(0.198, 0.9,200);
% Cd0 = interp1(MACH, Cd0, Mach, 'spline'); % verified
% figure;
% plot(mach,Cd0);
% grid on
% xlabel('Mach number[-]');
% ylabel('C_{d0}');

% GROUND AFFECT
Clgrd = 0.253*AR+0.65; % based on the regression on page Nicolai's 229 (the aircraf with leading edge such as U2s is removed from the table) 
% ground K see Rayemer's page354
h_b = H / 2 / wing_span;
Keff = K * 33*h_b^(1.5) / (1 + 33*h_b^(1.5));
kf = 0.14; % for full flap see Raymer's page 354; The drag coefficient of
% Boeing 747-200 is already the drag at approach mach = 0,02
d_Cd0 = kf^2 * (max(0, Clgrd-ClMax)).^2 .* cos(sweep);
end