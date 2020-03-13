%% This file is used to define the basic parameter estimationg for the mother ship

% Price estimation based on the dwt
function [p,wc] = price_estimation(t0)

p = 135.01 .* t0 + 3e06; % based on the regression analysis on real broker data

wc = 0.5*t0;

end
