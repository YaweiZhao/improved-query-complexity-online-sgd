function [x_seq, f_t_seq, f_seq, time_seq, loss_seq] = online_optimization(s_hyp)
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
loss_seq = zeros(T,1);
time_seq = zeros(T,1);
cpu_seconds = 0;
kappa= get_condition_number(s_hyp);
tic;
for i=1:T %n >> T
    s_hyp.D_1 =  s_hyp.scale_D*i;
    s_hyp.D_2 = s_hyp.scale_D*sqrt(i);
    if i>n
        fprintf('ERROR | T = %d  is larger than n = %d. \n', T, n);
    end
    %s_hyp.current_phase_id = fix(i/s_hyp.n_unit)+1;
    
    %ii = randi(n);
    ii = i;
    Ai = A(ii,:);
    yi = y(ii,:);
    %optimization modular
    if strcmp(modular, 'GD')
        if strcmp(ALGO, 'MOGD10')
            delta = 5;%larger step size
            eta2 = eta*delta;
            for j = 1:fix(kappa) % K: iterate n/10 for GD
                gradient = query_gradient(x_t, Ai, yi, s_hyp);
                x_t = x_t - eta2*gradient;
                x_t = get_projected_gradient(x_t, s_hyp.D_1, s_hyp.D_2,x_seq(1:i-1,:),i-1);%projected gradient
            end
        elseif strcmp(ALGO, 'OMGD')
            for j = 1:fix(kappa) % K: iterate n/10 for GD
                eta2 = eta;
                gradient = query_gradient(x_t, Ai, yi, s_hyp);
                x_t = x_t - eta2*gradient;
                x_t = get_projected_gradient(x_t, s_hyp.D_1, s_hyp.D_2,x_seq(1:i-1,:),i-1);%projected gradient
            end
        elseif strcmp(ALGO, 'OGD')
            %do nothing, yes! do nothing
            for j = 1:fix(kappa/5) %
                eta2 = eta;
                gradient = query_gradient(x_t, Ai, yi,s_hyp);
                x_t = x_t - eta2*gradient;
               x_t = get_projected_gradient(x_t, s_hyp.D_1, s_hyp.D_2,x_seq(1:i-1,:),i-1);%projected gradient
            end
        end
    elseif strcmp(modular, 'NAGM')%Nesterov accelerated gradient methods
        %use GDLibrary 
        [ x_t, ~ ] = nesterov_accelerated_gradient_method(x_t, Ai, yi,s_hyp); 
        %x_t = get_projected_gradient(x_t, s_hyp.D_1, s_hyp.D_2,x_seq(1:i-1,:),i-1);%projected gradient
    elseif strcmp(modular, 'STOCASTIC')
        begin_index = (s_hyp.current_phase_id-1)*s_hyp.n_unit+1;
        end_index = begin_index + s_hyp.n_unit-1;
        if strcmp(ALGO, 'MOGD-GD')%for compostional optimization
            %do nothing, yes! do nothing
            for j = 1:s_hyp.n_unit
                ii = randi([begin_index, end_index]);
                Ai = A(ii,:);
                yi = y(ii,:);
                gradient = query_gradient(x_t, Ai,yi,s_hyp);
                x_t = x_t - eta*gradient;
            end
        elseif strcmp(ALGO, 'MOGD-SGD')%for compostional optimization
        % decaying eta
            for j = 1:s_hyp.n_unit
                ii = randi([begin_index, end_index]);
                Ai = A(ii,:);
                gradient = query_stochastic_gradient(x_t, Ai,s_hyp);
                x_t = x_t - eta*gradient;
            end 
        elseif strcmp(ALGO, 'MOGD-SVRG')%for compositional optimization
            ii = randi([begin_index, end_index]);
            Ai = A(ii,:);
            x_t = svrg_method(x_t,  Ai, s_hyp);
        elseif strcmp(ALGO, 'MOGD-SVRG-BB')%for compositional optimization
            ii = randi([begin_index, end_index]);
            Ai = A(ii,:);
            x_t = svrg_method(x_t,  Ai, s_hyp);
            
        end
    end 
    %begin_index = (s_hyp.current_phase_id-1)*s_hyp.n_unit+1;
    %end_index = begin_index + s_hyp.n_unit-1;
    %ii = randi([begin_index, end_index]);
    %Ai = A(ii,:);
    if strcmp(ALGO, 'MOGD-GD') || strcmp(ALGO, 'MOGD-SGD') || strcmp(ALGO, 'MOGD-SVRG') || strcmp(ALGO, 'MOGD-SVRG-BB')
        
        direction = query_stochastic_gradient(x_t, Ai, s_hyp);
    else
        direction = query_gradient(x_t, Ai, yi, s_hyp);
    end
    x_t = x_t - eta*direction;
    x_t = get_projected_gradient(x_t, s_hyp.D_1, s_hyp.D_2,x_seq(1:i-1,:),i-1);%projected gradient
    
    % compute the local minimizer 
    %[x_seq(i,:), f_seq(i,:)] = get_local_minimizer(x_t, Ai, [],  s_hyp) ;
    %f_t_seq(i,:) = get_local_loss(x_t, Ai, [],  s_hyp) ;
    x_seq(i,:) = x_t';
    interval=1;
    if strcmp(ALGO, 'MOGD10') || strcmp(ALGO, 'OMGD')
        if mod(i,interval) == 0
            counter = fix(i/interval);
            time_seq(counter,:) = toc;%i
            fprintf('%s, begin recording...\n',s_hyp.ALGO);
            loss_seq(counter,:) = get_local_loss_weak_assumption(x_seq(1:i,:), s_hyp,i);
            fprintf('i = %d | kappa = %.2f | time %.2f| eta=%.10f  | regret = %.10f.  \n', i, kappa, sum(time_seq), eta, loss_seq(counter,:));
            tic;
        end
    elseif strcmp(ALGO, 'OGD')
        interval = interval*2; 
        if mod(i,interval) == 0
            counter = fix(i/interval);
            time_seq(counter,:) = toc;%i
            fprintf('%s, begin recording...\n',s_hyp.ALGO);
            loss_seq(counter,:) = get_local_loss_weak_assumption(x_seq(1:i,:), s_hyp,i);
            fprintf('i = %d | kappa = %.2f |time: %.2f | eta=%.10f | regret = %.10f.  \n', i, kappa, sum(time_seq), eta, loss_seq(counter,:));
            tic;
        end
    end
    %terminate the process
    %cpu_seconds = cpu_seconds + time_seq(i,:);
    if sum(time_seq)>206%
        break;
    end
    
    
    
    
end


end

function [x_t] = get_projected_gradient(x_t, D_1, D_2,X,i)
Q_temp = eye(i) - diag(ones(i-1,1),1);
Q = Q_temp(1:i-1,:);
consumed_D_1 = sum(norms(Q*X,2,2));
consumed_D_2 = sum(transpose(norms(Q*X,2,2))*norms(Q*X,2,2));
if norm(x_t) > D_1 - consumed_D_1  %project gradient
    x_t = x_t*D_1/norm(x_t);
end
if x_t'*x_t > D_2 - consumed_D_2%project gradient
    x_t = x_t*sqrt(D_2)/norm(x_t);
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

function[loss] = get_local_loss_weak_assumption(X, s_hyp,i) 
alpha = s_hyp.alpha;
model_opt = s_hyp.model_opt;
d = s_hyp.d;
A_temp = s_hyp.A;
y_temp = s_hyp.y;
if strcmp(model_opt,'ridge_regression')
    A_temp = [A_temp(1:i,:) ones(i,1)];
elseif strcmp(model_opt,'logistic_regression')
    A_temp = A_temp(1:i,:);
end
y_temp = y_temp(1:i,:);
Q_temp = eye(i) - diag(ones(i-1,1),1);
Q = Q_temp(1:i-1,:);
if strcmp(model_opt,'ridge_regression')
    cvx_begin quiet
        variable X_opt(i,d+1)
        temp1 = (sum(A_temp .* X_opt,2) - y_temp);
        obj_opt = temp1' * temp1 + alpha/2*sum(sum(X_opt .* X_opt,2));
        minimize (obj_opt)
        subject to 
            [sum(norms(Q*X_opt,2,2)); sum(sum((Q*X_opt) .* (Q*X_opt)))] <= [s_hyp.D_1; s_hyp.D_2]
    cvx_end
    temp2 = (sum(A_temp .* X,2) - y_temp);
    obj_our = temp2' * temp2 + alpha/2*sum(sum(X .* X,2));
    loss = obj_our - cvx_optval;
elseif strcmp(model_opt,'logistic_regression')
    cvx_begin quiet
        variable X_opt(i,d)
        obj_opt = sum(log(1+exp(-y_temp .* sum(A_temp .* X_opt,2)))) + alpha/2*sum(sum(X_opt .* X_opt));
        minimize (obj_opt)
        subject to 
            [sum(norms(Q*X_opt,2,2)); sum(sum((Q*X_opt) .* (Q*X_opt)))] <= [s_hyp.D_1; s_hyp.D_2]
    cvx_end
    obj_our = sum(log(1+exp(-y_temp .* sum(A_temp .* X,2)))) + alpha/2*sum(sum(X .* X));
    loss = obj_our - cvx_optval;
elseif strcmp(model_opt,'portfolio')
    f_t_opt = -Ai*x_t+(Ai*x_t - ones(1,n)*A*x_t/n)^2 + alpha/2*(x_t'*x_t);
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


