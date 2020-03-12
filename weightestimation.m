function [W_empty, W_full]=weightestimation(W_ot)
% Input: take-off: W[lb]
%{
% The there is a relationship between take-off weight and empty weight, see Nicolai p133 
% empty weight fraction = a * log10(take-off weight) + b
0.63 @ 1000 lb
0.44 @790,000 lb
K = [log10(1000), 1; log10(790000), 1];
Y = [0.63 0.44]';
T = K\Y;
T = [-0.0656, 0.8267];
empty weight fraction = -0.0656 * log10(take-off weight) + 0.8267
%}
fraction_empty = -0.0656 * log10(W_ot) + 0.8267;
W_empty = fraction_empty * W_ot;
W_full =  W_ot;
end