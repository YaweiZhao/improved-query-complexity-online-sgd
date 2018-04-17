function [ x_opt, f_opt ] = nesterov_accelerated_gradient_method(x_t, Ai, yi, gamma, d, model_opt)

if strcmp(model_opt,'ridge_regression')
    f = @(x) (Ai*x-yi)*transpose(Ai*x-yi) + gamma/2*(x'*x);
    g = @(x) (Ai*x - yi)*Ai'+gamma*x;
elseif strcmp(model_opt,'logistic_regression')
    f = @(x) log(1+exp(-yi*Ai*x)) + gamma/2*(x'*x);
    g = @(x) -yi/(1+exp(yi*Ai*x))*Ai' + gamma*x;
end
problem = general(f, g, [], [], d);
clear options;
% general options for optimization algorithms
options.w_init = x_t;
options.tol_gnorm = 1e-6;
options.max_iter = 50;
options.verbose = false;
options.store_w = false;
options.step_alg = 'backtracking';
%options.step_alg = 'exact';
[x_opt, ~] = gd_nesterov(problem, options);
f_opt  = f(x_opt);

end

