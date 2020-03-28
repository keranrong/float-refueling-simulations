%% This script is used for perform the global optimization using simulated annealing method
% Keran Rong
% options = optimoptions('simulannealbnd','PlotFcns',...
%           {@saplotbestx,@saplotbestf,@saplotx,@saplotf});
options = optimoptions('simulannealbnd','MaxIterations',18000,'AnnealingFcn',{@annealingboltz});
options = optimoptions('simulannealbnd','MaxIterations',18000);

fun = @simulatedannealing_aircraft;
x = [84.1082379045193,0.349743513370215,10.0955983473695,22.0952630375766,105126.778450296];
x = [68, 0.35, 7.73, 15, 52539];

% x_final = x;
for i = 1:10
%     a = 65;
%     b = 132;
%     x(1) = (b-a).*rand(1,1) + a;
    lb = [65,    0.2,  5.5, 0, 40000];
    ub = [132,  0.35, 10.1, 25, 175000];
    x = (ub - lb).*rand(1,5) + lb;
    x = simulannealbnd(fun,x,lb,ub,options);
    if simulatedannealing_aircraft(x) < simulatedannealing_aircraft(x_final)
        x_final = x;
    end
end
% [128.819012239123,0.350000000000000,7.89064734860678,21.9315015547280,122698.599174602]
% x=[120.961610816211,0.350000000000000,10.57270323280882,23.5222812476999,137324.623889419];
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

% thr limit - no catapult
% x = [101.031629151878,0.349886341526088,5.50044101314982,17.4296510002829,105134.561351796]
% x = [106.498717604289,0.349895748459304,5.50005369775787,20.2066312991198,105133.516681540]