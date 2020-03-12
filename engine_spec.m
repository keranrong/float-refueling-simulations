function [tda, SFC_SL, SFC]=engine_spec()
% Thrust based on LEAP-1C used in COMAC C919 (released in 2021)
tda=0.0; % Thrust Deflection Angle
SFC_SL=0.32; % Specific Fuel Consumption of Engine at sea level (Not avaialable, coped from CFM56) unit:lb/lbf/h
SFC = 0.53; % Specific Fuel Consumption unit:lb/lbf/h
% T=30830; % Thrust at Sealevel unit lbf
end