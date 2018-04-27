function [s_hyp] = generate_dynamic_data_stream(s_hyp)

A = zeros(s_hyp.n,s_hyp.d);
y = zeros(s_hyp.n,1);

if mod(s_hyp.n, s_hyp.n_dynamic) ~= 0
    fprintf('WARNING | %d / %d not zeros, dynamic levels setting error! \n', s_hyp.n, s_hyp.n_dynamic);
end
dynamic = s_hyp.dynamic_variation_base*(1:1:s_hyp.n_dynamic);
s_hyp.n_unit = s_hyp.n/s_hyp.n_dynamic;
for i = 1:s_hyp.n_dynamic
    begin_index = (i-1) * s_hyp.n_unit + 1;
    end_index = begin_index + s_hyp.n_unit -1;
    if strcmp(s_hyp.model_opt, 'ridge_regression')
         [A(begin_index:end_index,:), y(begin_index:end_index,:)] = ridge_regression(dynamic(i), s_hyp.n/s_hyp.n_dynamic,s_hyp.d);
    elseif strcmp(s_hyp.model_opt, 'logistic_regression')
        [A(begin_index:end_index,:), y(begin_index:end_index,:)] = logistic_regression(dynamic(i), s_hyp.n/s_hyp.n_dynamic,s_hyp.d);
    elseif strcmp(s_hyp.model_opt, 'portfolio')
        %generate data
        s_hyp.n_unit = s_hyp.n/s_hyp.n_dynamic;
        kappa = s_hyp.kappa;
        A(begin_index:end_index,:) = portfolio(kappa,dynamic(i), s_hyp.n_unit,s_hyp.d);
        [n,d] = size(A);
        s_hyp.n = n;
        s_hyp.d = d;
    end
end

s_hyp.A = A;
s_hyp.y = y;
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
A1 = 1 + rand(n1, d);
y1 = ones(n1,1);
A2 = -1 - rand(n1, d);
y2 = -ones(n2,1);
A = 0.1*dynamic*[A1;A2];%simulate the dynamic model
y = [y1; y2];

end


function[A] = portfolio(kappa, dynamic, n,d)

%generate data for portfolio optimization
%V = diag([max_eig_value, min_eig_value, min_eig_value + (max_eig_value - min_eig_value)*rand(1,d-2)]);
%U= orth(randn(d,d));
%cov = U*V*U^-1;
cov = diag([1:kappa, ones(1,d-kappa)*kappa/2]);

A_temp = mvnrnd( dynamic*ones(n,d), cov);
A = abs(A_temp);












end







