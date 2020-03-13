function [Hs,Tz, P] = CAM_weibull_scatter_diagram()
% Joint distribution of significante wave height and period
% Based on CMA proposed by Bitner_Greersen, 1988, 2005
% More see DNV-RP-C205 page 38


alpha = 1.798; % Based on the world wide operations
beta = 1.214;
gamma = 0.856; 

a0 = -1.01;
a1 = 2.847;
a2 = 0.075;

P = linspace(0, 0.9, 10);
Hs = wblinv(P,alpha,beta) + gamma;
% figure
% plot(P,Hs);

%{
figure;
plot(P,Hs);
xlabel('probability of occurance not exceeding specific wave height[-]');
ylabel('Significant wave height Hs[m]');
grid on 


figure; 
plot(Hs,Tz);
ylabel('max likelihood estimation of zero-crossing period T_z[sec]');
xlabel('Significant wave height H_s [m]');
grid on 
%}
% The maximum likelihood of the Tz
mu = a0 + a1.* Hs .^a2;

Tz = exp(mu);

end