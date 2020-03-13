function Vw = wind_wave_relationship(Hs)
% The interpolation is based on wind - wave relationship
% https://www.metoffice.gov.uk/weather/guides/coast-and-sea/beaufort-scale
VVw = [0	1	3	5	7	10	12	15	19	23	27	31]; % unit:m/sec
Hmax = [0	0.1	0.3	1	1.5	2.5	4	5.5	7.5	10	12.5	16]; % unit:m
HHs = Hmax / 1.86; % Delft Hydrodynamics textbooks, calculated by rayleigh distribution
% figure;
% plot(Hs,Vw);
% grid on;
% xlabel('H_s[m]');
% ylabel('V_w[m/sec]');
%{
figure;
plot(HHs,VVw);
xlabel('Significant wave height of wave[m]');
ylabel('wind speed at 10 m above the sealevel [m/sec]');
title('wind - wave relationship(source: UK metoffice');
grid on;
%}
Vw = interp1(HHs,VVw,Hs);
end