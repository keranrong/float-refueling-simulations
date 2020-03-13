function [b, D, KG] = draft_cog_estimation(L)
ll = [205, 245, 285, 330, 415];
dd = [16, 20, 23, 28, 35]; % Based on the classification of tanker size https://transportgeography.org/?page_id=6877
bb = [29, 34, 45, 55, 63];
D = interp1(ll,dd,L);
b = interp1(ll,bb,L);
% above hell 0.6D < KG < D
KG = D - 0.6*D;
end