function [ A, y ] = generate_dynamic_data_stream(n, d, model_opt,dynamic_variation_base,n_dynamic)

A = zeros(n,d);
y = zeros(n,1);

if mod(n, n_dynamic) ~= 0
    fprintf('WARNING | %d / %d not zeros, dynamic levels setting error! \n', n, n_dynamic);
end
dynamic = dynamic_variation_base*(1:1:n_dynamic);

for i = 1:n_dynamic
    begin_index = (i-1) * n/n_dynamic+1;
    end_index = begin_index + n/n_dynamic-1;
    if strcmp(model_opt, 'ridge_regression')
         [A(begin_index:end_index,:), y(begin_index:end_index,:)] = ridge_regression(dynamic(i), n/n_dynamic,d);
    elseif strcmp(model_opt, 'logistic_regression')
        [A(begin_index:end_index,:), y(begin_index:end_index,:)] = logistic_regression(dynamic(i), n/n_dynamic,d);
    end
end


end


function[A, y] = ridge_regression(dynamic, n,d)
% model y=Ax+b
% obtain A and b and noise
A = dynamic*rand(n,d);%simulate the dynamic model
b = rand(n,1);
noise = randn(n,1);
%obtain x and y
x = rand(d,1);
y = A*x+b+noise;
end

function[A, y] = logistic_regression(dynamic, n,d)
% model y = sum log(1+exp(-y Ax))
n1 = fix(n/2);
n2 = n-n1;
A1 = 5 + rand(n1, d);
y1 = ones(n1,1);
A2 = -5 + rand(n1, d);
y2 = -ones(n2,1);
A = dynamic*[A1;A2];%simulate the dynamic model
y = [y1; y2]+ 0.5*randn(n,1);

end


