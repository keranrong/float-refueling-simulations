% This script is used for calculate fuel saved for benchmark aircraft
fuelsaved = zeros(6,1);
takeoffdistance = zeros(6,1);
fuelsaved_ship = zeros(6,1);
climb_consumed = zeros(6,1);
% S-3 Viking
x = [68, 0.35, 7.73, 15, 52539];
[t2,t,tk,ww] = designvector_aircraft(x);
fuelsaved(1) = -t;
fuelsaved_ship(1) = -t2;
takeoffdistance(1) = tk;
climb_consumed(1) = ww;
% C-130J
x = [132.6, 0.19, 10.1, 0, 155000];
[t2,t,tk,ww] = designvector_aircraft(x);
fuelsaved(2) = -t;
fuelsaved_ship(2) = -t2;
takeoffdistance(2) = tk;
climb_consumed(2) = ww;
% Boeing 737-200
x = [93, 0.324, 9.45, 25, 181200];
[t2,t,tk,ww] = designvector_aircraft(x);
fuelsaved(3) = -t;
fuelsaved_ship(3) = -t2;
takeoffdistance(3) = tk;
climb_consumed(3) = ww;

% KC - 135
x = [93, 0.324, 9.45, 35, 181200];
[t2,t,tk,ww] = designvector_aircraft(x);
fuelsaved(4) = -t;
fuelsaved_ship(4) = -t2;
takeoffdistance(4) = tk;
climb_consumed(4) = ww;

% KC - 46
x = [157, 0.299, 8, 34, 415000];
[t2,t,tk,ww] = designvector_aircraft(x);
fuelsaved(5) = -t;
fuelsaved_ship(5) = -t2;
takeoffdistance(5) = tk;
climb_consumed(5) = ww;
% A330
x = [198, 0.27, 9.26, 29.7, 533519];
[t2,t,tk,ww] = designvector_aircraft(x);
fuelsaved(6) = -t;
fuelsaved_ship(6) = -t2;
takeoffdistance(6) = tk;
climb_consumed(6) = ww;
fuelsaved = fuelsaved';
fuelsaved_ship = fuelsaved_ship';
takeoffdistance = takeoffdistance';