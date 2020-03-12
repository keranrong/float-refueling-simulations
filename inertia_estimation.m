function [Ixx, Iyy, Izz] = inertia_estimation(Weight_gross)
%{
% There is relationship based on historial data based on Nicolai p133
% curve fitting based on the graph measure by ruler in a printed graph
% scale factor  11cm
scale_factor = 11;
Weight_gross = 20000;
%  Ixx for two engines
Ixx_w = log10(10.^([4.95,6.65,8.9,10.2,12.55,13.89]/11)*2);
Ixx_i = log10([6,10,20,30,60,90]);
%  f(x) = p1*x + p2
p1 = 1.449;
p2 = -0.3091;

% Iyy 
Iyy_w = log10(10.^([4, 4.9, 7.3, 9.35,10.52, 12.73, 13.32]/11)*2);
Iyy_i = log10([4, 5, 10, 20, 30,70, 90]);
% f(x) = p1*x^2 + p2*x + p3
p1 = 0.4578;
p2 = 0.6012;
p3 =   -0.002383;

% Izz
Izz_w = log10(10.^([2.7, 4.44,5.85, 8.1, 9.2, 10.55, 11.75, 12.35]/11)*2);
Izz_i = log10([5,7,10,20,30,50, 80, 100]);
%  f(x) = p1*x^2 + p2*x + p3
p1 =  0.6653;
p2 =  0.1958;
p3 =  0.3846;

%}
w_log10 = log10(Weight_gross/1000);

Ixx = 10 ^(1.449 * w_log10 - 0.3091) * 1000; % slug*ft^2
Iyy = 10 ^(0.4578 * w_log10^2 + 0.6012 * w_log10 -0.002383) * 1000; % slug*ft^2
Izz = 10 ^(0.6653 * w_log10^2 + 0.1958 * w_log10 + 0.3846) * 1000; % slug*ft^2

end