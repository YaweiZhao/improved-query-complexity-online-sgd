function [ x_opt ] = svrg_method(x_t,  Ai, s_hyp)
A = s_hyp.A;
eta = s_hyp.eta;
alpha = s_hyp.alpha;
n = s_hyp.n;
d = s_hyp.d;


%portolio optimization
f = @(x) -Ai*x+(Ai*x - ones(1,n)*A*x/n)^2+alpha/2*(x'*x);
g = @(x)-Ai'+ 2*(Ai*x - ones(1,n)*A*x/n)*(Ai' - A'*ones(n,1)/n)+alpha*x;


problem = general(f, g, [], [], d);
clear options;
% general options for optimization algorithms
options.w_init = x_t;
options.step_init = eta;
options.verbose = false;
options.store_w = false;
[x_opt, ~] = svrg_bb(problem, options);
%[x_opt, ~] = svrg(problem, options);

















end

