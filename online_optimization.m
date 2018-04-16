function [x_seq, f_t_seq, f_seq, time_seq] = online_optimization(data, y, T, model_opt, modular, ALGO)
A = data;
[n,d] = size(A);
if strcmp(model_opt,'ridge_regression')
    A = [A ones(n,1)]; d = d+1; 
elseif strcmp(model_opt,'logistic_regression')
    % do nothing
end
x_t = zeros(d,1);
eta = 1e-6;%learning rate
gamma = 1e1;%regularization constant
%record local minimizers
x_seq = zeros(T,d);
f_seq = zeros(T,1);
f_t_seq = zeros(T,1);
time_seq = zeros(T,1);
cpu_seconds = 0;
for i=1:T %n >> T
    if i>n
        fprintf('ERROR | T = %d  is larger than n = %d. \n', T, n);
    end
    ii = randi(n);
    if mod(i,200) == 0
        fprintf('T = %d | i = %d  | ii = %d | accumulated time = %f | regret = %f.  \n', T, i, ii, cpu_seconds, sum(f_t_seq(1:i,:) - f_seq(1:i,:)));
    end
    tic;
    Ai = A(ii,:);
    yi = y(ii,:);
    %optimization modular
    if strcmp(modular, 'GD')
        if strcmp(ALGO, 'MOGD')
            delta = 1e1;
            eta2 = eta*delta;
            for j = 1:fix(n/100) % K: iterate n/10 for GD
                gradient = query_gradient(x_t, Ai, yi, gamma,  model_opt);
                x_t = x_t - eta2*gradient;
            end
        elseif strcmp(ALGO, 'OMGD')
            for j = 1:fix(n/100) % K: iterate n/10 for GD
                eta2 = eta;
                gradient = query_gradient(x_t, Ai, yi, gamma,  model_opt);
                x_t = x_t - eta2*gradient;
            end
        elseif strcmp(ALGO, 'OGD')
            %do nothing, yes! do nothing
            
        end
    elseif strcmp(modular, 'NAGM')%Nesterov accelerated gradient methods
        
    elseif strcmp(modular, 'SGD')%for compostional optimization
        % decaying eta
        
    elseif strcmp(modular, 'Katyusha')%for compostional optimization
        % decaying eta
        
    end
    
    gradient = query_gradient(x_t, Ai, yi, gamma, model_opt);
    x_t = x_t - eta*gradient;
    time_seq(i,:) = toc;%record time for ploting lines
    % compute the local minimizer 
    [x_seq(i,:), f_seq(i,:)] = get_local_minimizer(x_t, Ai, yi,  gamma, model_opt) ;
    f_t_seq(i,:) = get_local_loss(x_t, Ai, yi,  gamma, model_opt) ;
    
    %terminate the process
    cpu_seconds = cpu_seconds + time_seq(i,:);
    if cpu_seconds > 60
        break;
    end
end


end


function [gradient] = query_gradient(x_t, Ai, yi, gamma,  model_opt)

if strcmp(model_opt,'ridge_regression')
    gradient = (Ai*x_t - yi)*Ai'+gamma*x_t;
elseif strcmp(model_opt,'logistic_regression')
    gradient = -yi/(1+exp(yi*Ai*x_t))*Ai';
end

end


function [x_t_opt, f_t_opt] = get_local_minimizer(x_t, Ai, yi,  gamma, model_opt) 

if strcmp(model_opt,'ridge_regression')
    options = optimoptions('fminunc','Algorithm','trust-region','GradObj','on', 'display','off');
    problem.options = options;
    problem.x0 = x_t;
    problem.objective = @(x)ridge_regression_with_grad(x, Ai, yi, gamma);
    problem.solver = 'fminunc';
    
    [x_t_opt, f_t_opt] = fminunc(problem);
elseif strcmp(model_opt,'logistic_regression')
    %use matlab optimization toolbox
    options = optimoptions('fminunc','Algorithm','trust-region','GradObj','on', 'display','off');
    problem.options = options;
    problem.x0 = x_t;
    problem.objective = @(x)logistic_regression_with_grad(x, Ai, yi, gamma);
    problem.solver = 'fminunc';

    [x_t_opt, f_t_opt] = fminunc(problem);
   
end
end

function [f_t_opt] = get_local_loss(x_t, Ai, yi,  gamma, model_opt)
if strcmp(model_opt,'ridge_regression')
    f_t_opt = (Ai*x_t-yi)*transpose(Ai*x_t-yi) + gamma/2*(x_t'*x_t);
elseif strcmp(model_opt,'logistic_regression')
    f_t_opt = log(1+exp(-yi*Ai*x_t)) + gamma/2*(x_t'*x_t);  
end

end



function[f, g] = ridge_regression_with_grad(x, Ai, yi, gamma)
f = (Ai*x-yi)*transpose(Ai*x-yi) + gamma/2*(x'*x);
g = (Ai*x - yi)*Ai'+gamma*x;
end

function[f, g] = logistic_regression_with_grad(x, Ai, yi, gamma)
f = log(1+exp(-yi*Ai*x)) + gamma/2*(x'*x);
g = -yi/(1+exp(yi*Ai*x))*Ai' + gamma*x;
end

