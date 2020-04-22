x0 = [132.00000	0.35000	6.67072	0.00410	142826.399881];
fun = @simulatedannealing_aircraft;

hessian_matrix = zeros(5,5);
for i = 1:5
    for j = 1:5
        hessian_matrix(i,j)= second_partial_derivative(fun, x0, i, j);
        
    end
end
