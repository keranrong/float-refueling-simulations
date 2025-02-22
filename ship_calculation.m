% addpath('.\ship_model');
% addpath('.\ship_datebase');
% 
% L = [205, 245, 285, 330, 415];
% factor = [1,2];
% dirs = [15,45,75];%0:45:180; linspace(0,90,4);

% ship.length = 330;
% ship.factor = 2;
% ship.MAX_ALLOW_HEAVE = 0.4;
% ship.MAX_ALLOW_ROLL = 1.5;

function [dirs, exceeding_prob, limit_type]= ship_calculation(mothership)
MAX_ALLOW_ROLL = mothership.MAX_ALLOW_ROLL;
MAX_ALLOW_HEAVE = mothership.MAX_ALLOW_HEAVE;

dirs = [0, 15, 30, 45, 60, 75, 90];%0:45:180; linspace(0,90,4);
exceeding_prob = zeros(length(dirs),1);
limit_type = {};

for iii = 1: length(dirs)
    % dir = 90;
    dir = dirs(iii);
    str_e = sprintf('ship_datebase/length%d_f%d_dir%d',mothership.length,mothership.factor,dir);
    load(str_e);
    
    mooring_period = 180;
    K(1,1) = (M(1,1)+A(1,1,end))*(2*pi/mooring_period);
    K(2,2) = (M(2,2)+A(2,2,end))*(2*pi/mooring_period);
    K(6,6) = (M(6,6)+A(6,6,end))*(2*pi/30);
    RAO = zeros(length(w),6);
    for i = 1:length(w)
        RAO(i,:) = Fe(i,:)/(-w(i).^2.*(M+A(:,:,i))-1i.*w(i).*(B(:,:,i))+K);
    end
    surge_RAO = RAO(:,1);
    heave_RAO = RAO(:,3);
    roll_RAO = RAO(:,4);
    pitch_RAO = RAO(:,5);
    
    %% CALCULATION OF MAXIMUM MOTION IN 3HRS
    [HHs,TTz, prob] = CAM_weibull_scatter_diagram();
    max_heave = [];
    max_roll = [];
    for ii = 1:length(HHs)
        Hs= HHs(ii);
        Tz = TTz(ii);
        dw = diff(w);
        dw = dw(1);
        
        ss = pmspectrum(w,Tz,Hs);
        
        spec_heave = abs(heave_RAO).^2 .* ss';
        spec_roll = abs(roll_RAO).^2 .* ss';
        
        max_heave_amplitude = 1.86*2*sqrt(trapz(w,spec_heave));
        max_roll_amplitude = 1.86*2*sqrt(trapz(w,spec_roll))/pi*180;
        max_heave(end+1) = max_heave_amplitude;
        max_roll(end+1) = max_roll_amplitude;
    end
    
    p1 = interp1(max_heave, prob, MAX_ALLOW_HEAVE, 'pchip', 1);
    p2 = interp1(max_roll, prob, MAX_ALLOW_ROLL, 'pchip', 1);
    p = min(p1,p2);
    exceeding_prob(iii) = p;
    if p1 > p2
        limit_type{iii} = 'heave';
    else
        limit_type{iii} = 'roll';
    end
end
dirs = 0:15:180;
exceeding_prob = [exceeding_prob(1:end)' exceeding_prob(end-1:-1:1)'];
limit_type =  {limit_type{1:end},limit_type{end-1:-1:1}};
end