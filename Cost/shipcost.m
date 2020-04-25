function [cost,operation_cost] = shipcost(x)

ship_id = x(1);
shipnumber = x(2);

density_seawater = 1.024;
% the ship size is based on ean-Paul Rodrigue.The geography of transport systems. Taylor & Francis, 2016.
ship_sizes = [205	29	16
    245	34	20
    285	45	23
    330	55	28
    415	63	35];

geo_ton = ship_sizes(:,1).*ship_sizes(:,2).*ship_sizes(:,3)*density_seawater;
% dwt afra_max is around 80,000 ton, thus we have scale factor from geo
% volumn to dwt
scale_factor = 80000/geo_ton(2);
dwt_ton = geo_ton*scale_factor;

b1 = regression_ship_cost();
cost_price = b1(1)+dwt_ton*b1(2);
if shipnumber == 1
    modification_cost = 1.2;
else
    modification_cost = 2*1.2+0.6;
end
airport = 16e6*1.79; % based on  Scott McClure FPSO/FSO converison versus new build

cost = modification_cost * cost_price(ship_id) + airport;
operation_cost = 982196*1.06; % https://www.researchgate.net/publication/298736632_LONG-TERM_FSOFPSO_CHARTER_RATE_ESTIMATION
end