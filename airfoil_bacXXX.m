function [ClMax, Clo, Cd0, Cdmin,maxclcd, K, alpha0, alphamax, alpha_Cdmin, a0, Cmo, upper_alpha, lower_alpha] = airfoil_bacXXX()
% Airfoil - based on boeing 747 - bac XXX see http://airfoiltools.com/airfoil/details?airfoil=bacxxx-il#polars
% Conventional Aircraft:                                 Wing Root Airfoil             Wing Tip Airfoil
% Boeing 747-300                                         BAC 463 to BAC 468            BAC 469 to BAC 474
% Boeing 747-100 (C-19)                                  BAC 463 to BAC 468            BAC 469 to BAC 474

d_alpha = [-9.75	-9.5	-9.25	-9	-8.75	-8.5	-8.25	-8	-5.25	-5	-4.75	-4.5	-4.25	-4	-3.75	-3.5	-3.25	-3	-2.75	-2.5	-2.25	-2	-1.75	-1.5	-1.25	-1	-0.5	-0.25	0	0.25	0.5	0.75	1	1.25	1.5	1.75	2	2.25	2.5	2.75	3	3.25	3.5	3.75	4	4.25	4.5	4.75	5	5.25	5.5	5.75	6	6.25	6.5	6.75	7	7.25	7.5	7.75	8	8.25	8.5	8.75	9	9.25	9.5	9.75	10	10.25	10.5	10.75	11	11.25	11.5	11.75	12	12.25	12.5	12.75	13	13.25	13.5	13.75	14	14.25	14.5	14.75	15	15.25	15.5	15.75	16	16.25	16.5	16.75	17]/180*pi;
d_cl = [-0.5187	-0.5473	-0.5826	-0.6085	-0.604	-0.5974	-0.5885	-0.5668	-0.3175	-0.2861	-0.2581	-0.2391	-0.2133	-0.1847	-0.1623	-0.1357	-0.1098	-0.0848	-0.0578	-0.0307	-0.005	0.0104	0.0331	0.06	0.0863	0.1125	0.1663	0.1933	0.2199	0.2458	0.2697	0.2914	0.3119	0.3327	0.3556	0.3796	0.4042	0.4286	0.4531	0.4778	0.5024	0.5275	0.5546	0.585	0.6171	0.6498	0.6858	0.7206	0.756	0.7915	0.8164	0.8375	0.8591	0.8806	0.902	0.9242	0.9465	0.9689	0.9922	1.0148	1.0363	1.0585	1.0804	1.104	1.126	1.1488	1.1708	1.1926	1.215	1.2355	1.2533	1.2719	1.2892	1.3058	1.323	1.3379	1.3501	1.3534	1.3674	1.3795	1.3901	1.399	1.407	1.4116	1.4107	1.4017	1.386	1.3859	1.3841	1.3794	1.3705	1.3594	1.3447	1.3256	1.3019	1.2745	1.2436];
d_cd= [0.08084	0.07319	0.06929	0.06586	0.06065	0.05622	0.05206	0.04741	0.01467	0.01374	0.01202	0.01118	0.01053	0.00994	0.00951	0.00912	0.00879	0.00847	0.00819	0.00798	0.00771	0.00593	0.00548	0.00531	0.0052	0.00507	0.00497	0.00495	0.00494	0.00498	0.00509	0.00532	0.00564	0.006	0.00626	0.00647	0.00663	0.00678	0.00692	0.00701	0.00711	0.00723	0.00738	0.00756	0.00776	0.00798	0.0082	0.00843	0.00867	0.00891	0.00913	0.00933	0.00953	0.00975	0.01001	0.01024	0.01049	0.01078	0.01102	0.01135	0.0118	0.01221	0.01266	0.01294	0.01339	0.01374	0.01417	0.01461	0.01498	0.01551	0.01628	0.01696	0.01772	0.0185	0.01912	0.01983	0.0207	0.02218	0.02288	0.0237	0.02462	0.02567	0.0268	0.02819	0.03005	0.03267	0.03609	0.0384	0.04107	0.04433	0.04845	0.05341	0.05955	0.06688	0.07521	0.08401	0.09332];
d_cm = [-0.0402	-0.0451	-0.0442	-0.0432	-0.0473	-0.0497	-0.051	-0.0516	-0.0533	-0.054	-0.0542	-0.0524	-0.052	-0.0522	-0.0509	-0.0505	-0.05	-0.0494	-0.0491	-0.0488	-0.0483	-0.0467	-0.0458	-0.0455	-0.0451	-0.0447	-0.0441	-0.0438	-0.0435	-0.043	-0.042	-0.0407	-0.0391	-0.0378	-0.0368	-0.0361	-0.0356	-0.0349	-0.0343	-0.0336	-0.0329	-0.0323	-0.0321	-0.0328	-0.0339	-0.0352	-0.0373	-0.039	-0.041	-0.043	-0.0427	-0.0414	-0.0403	-0.0391	-0.038	-0.037	-0.036	-0.0352	-0.0344	-0.0336	-0.0327	-0.0319	-0.031	-0.0304	-0.0296	-0.0289	-0.0282	-0.0274	-0.0267	-0.0257	-0.0244	-0.0231	-0.0216	-0.02	-0.0185	-0.0167	-0.0145	-0.0111	-0.0093	-0.0074	-0.0054	-0.0034	-0.0013	0.0009	0.0034	0.0061	0.0084	0.0093	0.0098	0.0098	0.0089	0.0071	0.004	0.0001	-0.0043	-0.0086	-0.013];

ClMax = max(d_cl); % Max Coefficient of Lift at Sealevel (needs to be checked) Re = 1 miilon
alphamax = d_alpha(d_cl==ClMax) ;
Cd0 = interp1(d_cl, d_cd, 0); % find Cd0 where zero-lift drag coefficient
[Cdmin,i] = min(d_cd); % min Cd
alpha_Cdmin = d_alpha(i)/pi*180; 

alpha0 = interp1(d_cl,d_alpha,0) ;
Clo = interp1(d_alpha, d_cl, 0);
Cmo = interp1(d_alpha, d_cm, 0);

upper_alpha = d_alpha(d_cl == max(d_cl)); % upper limit of alpha without stall
lower_alpha = d_alpha(d_cl == min(d_cl)); % lower limit of alpha without stall
available_alpha = d_alpha(d_alpha>=lower_alpha & d_alpha<=upper_alpha);
available_cl = d_cl(d_alpha>=lower_alpha & d_alpha<=upper_alpha);
available_cd = d_cd(d_alpha>=lower_alpha & d_alpha<=upper_alpha);
K = (available_cl.^2)'\(available_cd' - Cd0);
a0 = available_cl/(available_alpha);

%% find Cl/Cd min
t = linspace(lower_alpha, upper_alpha, 500) ;
temp_cl = a0.*(t - alpha0);
temp_cd = Cd0 + K* temp_cl.^2;
maxclcd = max(temp_cl./temp_cd);
%{
figure;
hold on
plot(available_cl, available_cd,'*');
plot(temp_cl,temp_cd);

figure;
plot(d_alpha,d_cl);
xlabel('Angle of Attack \alpha[deg]');
ylabel('Lift coefficient C_l[-]');
grid on
title('Angle of attack versus Lift coeff for Bac XXX');

figure;
plot(d_cd,d_cl);
xlabel('Angle of Attack [deg]');
ylabel('Lift coefficient C_l [-]');
grid on
title('Angle of attack versus Lift coeff for Bac XXX');
%}
end