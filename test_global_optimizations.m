%% This script is used for perform the global optimization using simulated annealing method
% Keran Rong
% options = optimoptions('simulannealbnd','PlotFcns',...
%           {@saplotbestx,@saplotbestf,@saplotx,@saplotf});
options = optimoptions('simulannealbnd','MaxIterations',18000,'AnnealingFcn',{@annealingboltz});
fun = @simulatedannealing_aircraft;
x = [84.1082379045193,0.349743513370215,10.0955983473695,22.0952630375766,105126.778450296];
lb = [65,    0.2,  5.5, 0, 40000];
ub = [132,  0.35, 10.1, 25, 175000];
x = simulannealbnd(fun,x,lb,ub,options)

% x = [[88.9262691416019,0.448683168234183,10.0927980434682,7.07892535031432,104971.362075440]]; % final with 1 refueling 1 airplane
% x = [[88.9262691416019,0.448683168234183,10.0927980434682,7.07892535031432,104971.362075440]]; % final with 2 refueling 2 airplane
% x = [[88.9262691416019,0.448683168234183,10.0927980434682,7.07892535031432,104971.362075440]]; % final with 1 refueling 2 airplane
% x =
% [[[88.2937516024172,0.520916911653323,10.0996099628242,8.81214771343587,104965.929401046]]];
% % With out constraint on thrust to weight ratio
% %
% [81.1606731839481,0.349916777488686,10.0943959007835,5.96604468903532,104989.206561300]
% thr limit - 0.35 with catapult
% x = [84.1082379045193,0.349743513370215,10.0955983473695,22.0952630375766,105126.778450296]% 
%