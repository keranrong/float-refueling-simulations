aircrafts = [135	0.35	7.59782	0	124379.187
    135	0.35	7.53159	0.00074	128209.1506
    135	0.35	7.18321	0.0001	134309.8253
    135	0.35	6.67072	0.0041	142826.3999
    135	0.35	6.01241	0.00652	158304.0799];


x_refueling = [2,1];
x_ship = [1,1];
x_aircraft = aircrafts(x_ship(1),:);
number_aircraft = 3;
tax_rate = 0.35;
discount_factor = 15 * 0.01;
margin_factor = 0.85;
%% NPV calculation
life_cycle = 20;
[ship_cost,ship_operation_cost] = shipcost(x_ship); % the capital cost of ship
ship_depreciation = ship_cost/life_cycle;
[AMP_2020, aircraft_operation_cost, revenue] = aircraft_cost(x_aircraft,x_refueling, 1);
aircraft_depreciation = AMP_2020/20;
avail =availability_ship(x_ship)*9*365*margin_factor;
FCF = zeros(1,life_cycle);
captial_cost = ship_cost + AMP_2020 * number_aircraft;
for i = 1:life_cycle
    [AMP_2020, aircraft_operation_cost, revenue] = aircraft_cost(x_aircraft,x_refueling, i);
    revenue = revenue * avail*number_aircraft;
    expense = aircraft_operation_cost * avail * number_aircraft + ship_operation_cost;
    EBITDA = revenue - expense;
    depreciation = ship_depreciation + aircraft_depreciation;
    EBIT = EBITDA - depreciation;
    FCF(i) = EBITDA - EBIT*tax_rate;
    
    
end
CashFlow=[-captial_cost,FCF];
npv = -captial_cost;
for i = 1:life_cycle
    npv = npv + FCF(i)/((1+discount_factor)^i);
end
