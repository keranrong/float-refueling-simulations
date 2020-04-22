clear all
xx = [132.00000	0.35000	7.59782	0.00000	124379.187033
132.00000	0.35000	7.53159	0.00074	128209.150600
132.00000	0.35000	7.18321	0.00010	134309.825333
132.00000	0.35000	6.67072	0.00410	142826.399881
132.00000	0.35000	6.01241	0.00652	158304.079859
111.86962	0.35000	10.10000	0.46328	250000.000000
];
xx(:,1)=xx(:,1)+3*1;
% xx(:,4)=0;
% xx(:,1)=xx(:,1)*(1+0.01);
III = 5;
xx(:,III)=xx(:,III) - 1000*0;
result = zeros(size(xx,1),2);
to_distance = zeros(size(xx,1),1);
for ii = 1:size(xx,1)
[costobject_island, take_off_distance2, costobject_ship] = simulatedannealing_aircraft(xx(ii,:));
result(ii,:)=[-costobject_island,-costobject_ship];
to_distance(ii) = take_off_distance2/3.28084;
end
% to_distance = to_distance';
res= [result,to_distance];