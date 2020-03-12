function [rho, mach]=air_physics(height)
% Based on 1976 U.S. Standard Atmosphere

ALTITUDE = [0, 10000, 15000, 20000, 25000, 30000, 40000, 60000]; % Alt in ft.
RHO=[0.002377, 0.001755, 0.001496, 0.001266, 0.001065, 0.00089, 0.000585,0.000224]; % air density in slug/ft3
MACH = [1116.4, 1077.4, 1057.3, 1036.8, 1016.0, 994.7, 968.1, 968.1];

rho = interp1(ALTITUDE, RHO, height);
mach = interp1(ALTITUDE, MACH, height);

end