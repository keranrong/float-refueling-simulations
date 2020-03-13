function s = pmspectrum(w,Tz,Hs)
gamma = 1; % Pierson-Moskowitz (PM) spectrum
Tp = Tz/(0.6673 + 0.05037*gamma - 0.006230*gamma^2 + 0.0003341*gamma^3);

wp = 2*pi/Tp;

s = 5/16 .* Hs.^2 .* wp.^4 .* w.^-5 .* exp(-5./4.*(w./wp).^(-4));
%{
Hs = 2.5;
Tz= 7.5;
w = linspace(0,2,100);
gamma = 1; % Pierson-Moskowitz (PM) spectrum
Tp = Tz/(0.6673 + 0.05037*gamma - 0.006230*gamma^2 + 0.0003341*gamma^3);

wp = 2*pi/Tp;

s = 5/16 .* Hs.^2 .* wp.^4 .* w.^-5 .* exp(-5./4.*(w./wp).^(-4));
figure;
plot(w,s);
xlabel('angular frequency [rad/sec]');
title('Pierson–Moskowitz spectrum Hs=2.5m ,Tz= 7.5sec');
ylabel('[m*sec/rad]')
grid on
%}
end