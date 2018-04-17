function [x_seq, f_t_seq, f_seq, time_seq] = online_optimization(data, y, T, model_opt, modular, ALGO)
A = data;
[n,d] = size(A);
if strcmp(model_opt,'ridge_regression')
    A = [A ones(n,1)]; d = d+1; 
elseif strcmp(model_opt,'logistic_regression')
    % do nothing
end
x_t = zeros(d,1);
%alpha = 1e-3;%regularization constant
alpha = 100;%regularization constant
%record local minimizers
x_seq = zeros(T,d);
f_seq = zeros(T,1);
f_t_seq = zeros(T,1);
time_seq = zeros(T,1);
cpu_seconds = 0;
[kappa, beta]= get_condition_number(A,alpha, model_opt);
eta = 1/beta;%learning rate
for i=1:T %n >> T
    if i>n
        fprintf('ERROR | T = %d  is larger than n = %d. \n', T, n);
    end
    
    ii = randi(n);
    if mod(i,200) == 0
        fprintf('i = %d | kappa = %.2f | eta=%.10f | cpu sec = %.2f | regret = %.10f.  \n', i, kappa, eta,cpu_seconds, sum(f_t_seq(1:i,:) - f_seq(1:i,:)));
    end
    tic;
    Ai = A(ii,:);
    yi = y(ii,:);
    %optimization modular
    if strcmp(modular, 'GD')
        if strcmp(ALGO, 'MOGD')
            delta = 2;
            eta2 = eta*delta;
            for j = 1:fix(kappa) % K: iterate n/10 for GD
                gradient = query_gradient(x_t, Ai, yi, alpha,  model_opt);
                x_t = x_t - eta2*gradient;
            end
        elseif strcmp(ALGO, 'OMGD')
            for j = 1:fix(kappa) % K: iterate n/10 for GD
                eta2 = eta;
                gradient = query_gradient(x_t, Ai, yi, alpha,  model_opt);
                x_t = x_t - eta2*gradient;
            end
        elseif strcmp(ALGO, 'OGD')
            %do nothing, yes! do nothing
            for j = 1:fix(kappa/10) %
                eta2 = eta;
                gradient = query_gradient(x_t, Ai, yi, alpha,  model_opt);
                x_t = x_t - eta2*gradient;
            end
        end
    elseif strcmp(modular, 'NAGM')%Nesterov accelerated gradient methods
        %use GDLibrary 
        [ x_t, ~ ] = nesterov_accelerated_gradient_method(x_t, Ai, yi,alpha, d, model_opt);
        
        
    elseif strcmp(modular, 'SGD')%for compostional optimization
        % decaying eta
        
    elseif strcmp(modular, 'Katyusha')%for compostional optimization
        % decaying eta
        
    end
    
    gradient = query_gradient(x_t, Ai, yi, alpha, model_opt);
    x_t = x_t - eta*gradient;
    time_seq(i,:) = toc;%record time for ploting lines
    % compute the local minimizer 
    [x_seq(i,:), f_seq(i,:)] = get_local_minimizer(x_t, Ai, yi,  alpha, model_opt) ;
    f_t_seq(i,:) = get_local_loss(x_t, Ai, yi,  alpha, model_opt) ;
    
    %terminate the process
    cpu_seconds = cpu_seconds + time_seq(i,:);
    if cpu_seconds > 401
        break;
    end
end


end


function [gradient] = query_gradient(x_t, Ai, yi, alpha,  model_opt)

if strcmp(model_opt,'ridge_regression')
    gradient = (Ai*x_t - yi)*Ai'+alpha*x_t;
elseif strcmp(model_opt,'logistic_regression')
    gradient = -yi/(1+exp(yi*Ai*x_t))*Ai'+alpha*x_t;
end

end


function [x_t_opt, f_t_opt] = get_local_minimizer(x_t, Ai, yi,  alpha, model_opt) 

if strcmp(model_opt,'ridge_regression')
    options = optimoptions('fminunc','Algorithm','trust-region','GradObj','on', 'display','off');
    problem.options = options;
    problem.x0 = x_t;
    problem.objective = @(x)ridge_regression_with_grad(x, Ai, yi, alpha);
    problem.solver = 'fminunc';
    
    [x_t_opt, f_t_opt] = fminunc(problem);
elseif strcmp(model_opt,'logistic_regression')
    %use matlab optimization toolbox
    options = optimoptions('fminunc','Algorithm','trust-region','GradObj','on', 'display','off');
    problem.options = options;
    problem.x0 = x_t;
    problem.objective = @(x)logistic_regression_with_grad(x, Ai, yi, alpha);
    problem.solver = 'fminunc';

    [x_t_opt, f_t_opt] = fminunc(problem);
   
end
end

function [f_t_opt] = get_local_loss(x_t, Ai, yi,  alpha, model_opt)
if strcmp(model_opt,'ridge_regression')
    f_t_opt = (Ai*x_t-yi)*transpose(Ai*x_t-yi) + alpha/2*(x_t'*x_t);
elseif strcmp(model_opt,'logistic_regression')
    f_t_opt = log(1+exp(-yi*Ai*x_t)) + alpha/2*(x_t'*x_t);  
end

end



function[f, g] = ridge_regression_with_grad(x, Ai, yi, alpha)
f = (Ai*x-yi)*transpose(Ai*x-yi) + alpha/2*(x'*x);
g = (Ai*x - yi)*Ai'+alpha*x;
end

function[f, g] = logistic_regression_with_grad(x, Ai, yi, alpha)
f = log(1+exp(-yi*Ai*x)) + alpha/2*(x'*x);
g = -yi/(1+exp(yi*Ai*x))*Ai' + alpha*x;
end


function [kappa, beta ] = get_condition_number(A,alpha,model_opt)
[n,d] = size(A);
if strcmp(model_opt,'ridge_regression')
    A_temp = [A ones(n,1)];
    eigvalue_A = eig(A_temp'*A_temp);
    beta = 2*( max(eigvalue_A) + alpha/2 );%find the maximal eigen value
    kappa = beta/alpha;
elseif strcmp(model_opt,'logistic_regression')
    temp = max(sum(A .* A,2));
    beta = temp/4+alpha;
    kappa = beta/alpha;
end

end


