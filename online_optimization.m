function [x_seq, f_t_seq, f_seq, time_seq] = online_optimization(s_hyp)
A = s_hyp.A;
y = s_hyp.y;
n = s_hyp.n;
d = s_hyp.d;
T = s_hyp.T;
eta = s_hyp.eta;
model_opt = s_hyp.model_opt;
modular = s_hyp.modular;
ALGO = s_hyp.ALGO;
alpha = s_hyp.alpha;

if strcmp(model_opt,'ridge_regression')
    A = [A ones(n,1)]; d = d+1; 
elseif strcmp(model_opt,'logistic_regression')
    % do nothing
end
x_t = zeros(d,1);

%record local minimizers
x_seq = zeros(T,d);
f_seq = zeros(T,1);
f_t_seq = zeros(T,1);
time_seq = zeros(T,1);
cpu_seconds = 0;
kappa= get_condition_number(s_hyp);

for i=1:T %n >> T
    
    if i>n
        fprintf('ERROR | T = %d  is larger than n = %d. \n', T, n);
    end
    s_hyp.current_phase_id = fix(i/s_hyp.n_unit)+1;
    
    if mod(i,1) == 0
        fprintf('i = %d | kappa = %.2f | eta=%.10f | cpu sec = %.2f | regret = %.10f.  \n', i, kappa, eta,cpu_seconds, sum(f_t_seq(1:i,:) - f_seq(1:i,:)));
    end
    tic;
    %ii = randi(n);
    %Ai = A(ii,:);
    %yi = y(ii,:);
    %optimization modular
    if strcmp(modular, 'GD')
        if strcmp(ALGO, 'MOGD')
            delta = 2;
            eta2 = eta*delta;
            for j = 1:fix(kappa) % K: iterate n/10 for GD
                gradient = query_gradient(x_t, Ai, yi, s_hyp);
                x_t = x_t - eta2*gradient;
            end
        elseif strcmp(ALGO, 'OMGD')
            for j = 1:fix(kappa) % K: iterate n/10 for GD
                eta2 = eta;
                gradient = query_gradient(x_t, Ai, yi, s_hyp);
                x_t = x_t - eta2*gradient;
            end
        elseif strcmp(ALGO, 'OGD')
            %do nothing, yes! do nothing
            for j = 1:fix(kappa/10) %
                eta2 = eta;
                gradient = query_gradient(x_t, Ai, yi,s_hyp);
                x_t = x_t - eta2*gradient;
            end
        end
    elseif strcmp(modular, 'NAGM')%Nesterov accelerated gradient methods
        %use GDLibrary 
        [ x_t, ~ ] = nesterov_accelerated_gradient_method(x_t, Ai, yi,s_hyp); 
    elseif strcmp(modular, 'STOCASTIC')
        begin_index = (s_hyp.current_phase_id-1)*s_hyp.n_unit+1;
        end_index = begin_index + s_hyp.n_unit-1;
        if strcmp(ALGO, 'MOGD-GD')%for compostional optimization
            %do nothing, yes! do nothing
            for j = 1:s_hyp.n_unit
                ii = randi([begin_index, end_index]);
                Ai = A(ii,:);
                yi = y(ii,:);
                eta2 = eta;
                gradient = query_gradient(x_t, Ai,yi,s_hyp);
                x_t = x_t - eta2*gradient;
            end
        elseif strcmp(ALGO, 'MOGD-SGD')%for compostional optimization
        % decaying eta
            eta2 = eta*2;
            for j = 1:s_hyp.n_unit
                ii = randi([begin_index, end_index]);
                Ai = A(ii,:);
                gradient = query_stochastic_gradient(x_t, Ai,s_hyp);
                x_t = x_t - eta2*gradient;
            end 
        elseif strcmp(ALGO, 'MOGD-SVRG')%for compositional optimization
            % decaying eta
            ii = randi([begin_index, end_index]);
            Ai = A(ii,:);
            x_t = svrg_method(x_t,  Ai, s_hyp);
            
        end
    end 
    begin_index = (s_hyp.current_phase_id-1)*s_hyp.n_unit+1;
    end_index = begin_index + s_hyp.n_unit-1;
    ii = randi([begin_index, end_index]);
    Ai = A(ii,:);
    if strcmp(ALGO, 'MOGD-GD') || strcmp(ALGO, 'MOGD-SGD') || strcmp(ALGO, 'MOGD-SVRG')
        
        direction = query_stochastic_gradient(x_t, Ai, s_hyp);
    else
        direction = query_gradient(x_t, Ai, yi, s_hyp);
    end
    x_t = x_t - eta*direction;
    time_seq(i,:) = toc;%record time for ploting lines
    % compute the local minimizer 
    [x_seq(i,:), f_seq(i,:)] = get_local_minimizer(x_t, Ai, [],  s_hyp) ;
    f_t_seq(i,:) = get_local_loss(x_t, Ai, [],  s_hyp) ;
    
    %terminate the process
    cpu_seconds = cpu_seconds + time_seq(i,:);
    if cpu_seconds > 306
        break;
    end
end


end


function [gradient] = query_gradient(x_t, Ai,yi, s_hyp)
alpha = s_hyp.alpha;
model_opt = s_hyp.model_opt;

if strcmp(model_opt,'ridge_regression')
    gradient = (Ai*x_t - yi)*Ai'+alpha*x_t;
elseif strcmp(model_opt,'logistic_regression')
    gradient = -yi/(1+exp(yi*Ai*x_t))*Ai'+alpha*x_t;
elseif strcmp(model_opt,'portfolio')
    begin_index = (s_hyp.current_phase_id-1)*s_hyp.n_unit+1;
    end_index = begin_index + s_hyp.n_unit-1;
    A = s_hyp.A;
    temp = Ai*x_t - ones(1,s_hyp.n_unit)*A(begin_index:end_index,:)*x_t/s_hyp.n_unit;
    gradient = -Ai'+ 2*temp*(Ai' - transpose(A(begin_index:end_index,:))*ones(s_hyp.n_unit,1)/s_hyp.n_unit) + alpha*x_t;
end

end


function [stoc_grad] = query_stochastic_gradient(x_t, Ai, s_hyp)
A = s_hyp.A;
alpha = s_hyp.alpha;
model_opt = s_hyp.model_opt;
begin_index = (s_hyp.current_phase_id-1)*s_hyp.n_unit+1;
end_index = begin_index + s_hyp.n_unit-1;
     
if strcmp(model_opt,'portfolio')
    j1=randi([begin_index,end_index]);
    j2=randi([begin_index,end_index]);
    Aj1 = A(j1,:);
    Aj2 = A(j2,:);
    temp = Ai*x_t - Aj1*x_t;
    stoc_grad = -Ai'+ 2*temp*(transpose(Ai - Aj2))+alpha*x_t;
end

end



function [x_t_opt, f_t_opt] = get_local_minimizer(x_t, Ai, yi,  s_hyp) 
alpha = s_hyp.alpha;
model_opt = s_hyp.model_opt;

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
    
elseif strcmp(model_opt,'portfolio')
    %use matlab optimization toolbox
    options = optimoptions('fmincon','Algorithm','trust-region-reflective','GradObj','on', 'display','off');
    x0 = x_t;
    fun = @(x)mean_variance_portfolio_with_grad(x, Ai, s_hyp );
%     A = [];
%     b = [];
%     Aeq = [];
%     beq = [];
    d = s_hyp.d;
    lb = zeros(1,d);

    [x_t_opt, f_t_opt] = fmincon(fun, x0, [], [], [], [], lb, [], [], options);
    

% %tempariary matrix
%     begin_index = (s_hyp.current_phase_id-1)*s_hyp.n_unit+1;
%     end_index = begin_index + s_hyp.n_unit-1;
%     n = s_hyp.n_unit;
%     d = s_hyp.d;
%     alpha = s_hyp.alpha;
%     A_temp = s_hyp.A;
%     A = A_temp(begin_index:end_index,:);
%     
%     P = -Ai';
%     Q = Ai' - transpose(ones(1,n)*A)/n;
%     temp = Q*Q'+ alpha*eye(d);
%     disp(cond(temp));
%     x_t_opt = -1/2*temp\P;
%     f_t_opt = get_local_loss(x_t_opt, Ai, yi,  s_hyp);
end


end

function [f_t_opt] = get_local_loss(x_t, Ai, yi,  s_hyp)
alpha = s_hyp.alpha;
model_opt = s_hyp.model_opt;
begin_index = (s_hyp.current_phase_id-1)*s_hyp.n_unit+1;
end_index = begin_index + s_hyp.n_unit-1;
n = s_hyp.n_unit;
A_temp = s_hyp.A;
A = A_temp(begin_index:end_index,:);


if strcmp(model_opt,'ridge_regression')
    f_t_opt = (Ai*x_t-yi)*transpose(Ai*x_t-yi) + alpha/2*(x_t'*x_t);
elseif strcmp(model_opt,'logistic_regression')
    f_t_opt = log(1+exp(-yi*Ai*x_t)) + alpha/2*(x_t'*x_t);  
elseif strcmp(model_opt,'portfolio')
    f_t_opt = -Ai*x_t+(Ai*x_t - ones(1,n)*A*x_t/n)^2 + alpha/2*(x_t'*x_t);
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

%used to evaluate the loss
function [f, g] = mean_variance_portfolio_with_grad(x,Ai,s_hyp )
begin_index = (s_hyp.current_phase_id-1)*s_hyp.n_unit+1;
end_index = begin_index + s_hyp.n_unit-1;
n = s_hyp.n_unit;
alpha = s_hyp.alpha;
A_temp = s_hyp.A;
A = A_temp(begin_index:end_index,:);
f = -Ai*x+(Ai*x - ones(1,n)*A*x/n)^2 + alpha/2*(x'*x);
g = -Ai'+ 2*(Ai*x - ones(1,n)*A*x/n)*(Ai' - A'*ones(n,1)/n) + alpha*x;

end


function [kappa] = get_condition_number(s_hyp)
A = s_hyp.A;
alpha = s_hyp.alpha;
model_opt = s_hyp.model_opt;
n = s_hyp.n;
d = s_hyp.d;

if strcmp(model_opt,'ridge_regression')
    A_temp = [A ones(n,1)];
    eigvalue_A = eig(A_temp'*A_temp);
    beta = 2*( max(eigvalue_A) + alpha/2 );%find the maximal eigen value
    kappa = beta/alpha;
elseif strcmp(model_opt,'logistic_regression')
    %temp = max(sum(A .* A,2));
    temp=1;
    beta = temp/4+alpha;
    kappa = beta/alpha;
elseif strcmp(model_opt,'portfolio')
    kappa = s_hyp.kappa;
    
    
    
end









end


