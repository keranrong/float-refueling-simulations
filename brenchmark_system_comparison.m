% This script is used for calculate fuel saved for benchmark aircraft
fuelsaved = zeros(6,1);
% S-3 Viking
x = [68, 0.35, 7.73, 15, 52539];
[~,t] = designvector_aircraft(x);
fuelsaved(1) = t;
% C-130J
x = [132.6, 0.19, 10.1, 0, 155000];
[~,t] = designvector_aircraft(x);
fuelsaved(2) = t;
% Boeing 737-200
x = [93, 0.324, 9.45, 25, 181200];
[~,t] = designvector_aircraft(x);
fuelsaved(3) = t;
% KC - 135
x = [93, 0.324, 9.45, 35, 181200];
[~,t] = designvector_aircraft(x);
fuelsaved(4) = t;
% KC - 46
x = [157, 0.299, 8, 34, 415000];
[~,t] = designvector_aircraft(x);
fuelsaved(5) = t;
% A330
x = [198, 0.27, 9.26, 29.7, 533519];
[~,t] = designvector_aircraft(x);
fuelsaved(6) = t;