function avail =availability_ship(x)
ship_size = x(1);
ship_number = x(2);

% based on data analysis.xlsx
if ship_number == 1
    availability = [0.503483247
        0.610911264
        0.717179913
        0.821322514
        0.897105202
        1]';
else
    availability = [0.546293293
        0.67835936
        0.790412213
        0.883120213
        1
        1]';
end

avail = availability(ship_size);
end