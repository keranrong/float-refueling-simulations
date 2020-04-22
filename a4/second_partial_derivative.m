function res = second_partial_derivative(fun, x0, i, j)

h =1e-6;

x1 = x0;
x1(i) = x1(i) + h/2; x1(j) = x1(j) + h/2;

x2 = x0;
x2(i) = x2(i) + h/2; x2(j) = x2(j) - h/2;

x3 = x0;
x3(i) = x3(i) - h/2; x3(j) = x3(j) + h/2;

x4 = x0;
x4(i) = x4(i) - h/2; x4(j) = x4(j) - h/2;

res = (fun(x1)-fun(x2))/h^2 - (fun(x3)-fun(x4))/h^2;

end

