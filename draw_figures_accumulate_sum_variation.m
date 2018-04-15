%our method
sum_x_seq_1 = load('./var=1/sum_x_seq.txt','-ascii');
sum_x_seq_01 = load('./var=0.01(default)/sum_x_seq.txt','-ascii');
sum_x_seq_0001 = load('./var=0.0001/sum_x_seq.txt','-ascii');
sum_squared_x_seq_1 = load('./var=1/sum_squared_x_seq.txt','-ascii');
sum_squared_x_seq_01 = load('./var=0.01(default)/sum_squared_x_seq.txt','-ascii');
sum_squared_x_seq_0001 = load('./var=0.0001/sum_squared_x_seq.txt','-ascii');
model_opt = 'ridge_regression';
index_x_seq = 20*(1:fix((T-1)/20));
if strcmp(model_opt,'ridge_regression')
    
    %var = 0.01
    plot(index_x_seq(:), sum_x_seq_1(index_x_seq(:),:), '-or'); 
    hold on;
    plot(index_x_seq, sum_x_seq_01(index_x_seq), '-+r'); 
    hold on;
    plot(index_x_seq, sum_x_seq_0001(index_x_seq), '-dr'); 
    hold on;
    
    plot(index_x_seq, sum_squared_x_seq_1(index_x_seq), '-ob');
    hold on;
    plot(index_x_seq, sum_squared_x_seq_01(index_x_seq), '-+b'); 
    hold on;
    plot(index_x_seq, sum_squared_x_seq_0001(index_x_seq), '-db'); 
    hold on;
    
    
    xlabel('Iterations', 'fontsize', 18);
    ylabel('Accumulate sum of variations', 'fontsize', 18 );
    %$$ \mathcal{P}_T^{\ast} $$
    h = legend('$$ \mathcal{P}_T^{\ast},\nu = 10^0$$', ...
        '$$ \mathcal{P}_T^{\ast},\nu = 10^{-2}$$', ...
        '$$ \mathcal{P}_T^{\ast},\nu = 10^{-4}$$', ...
        '$$ \mathcal{WS}_T^{\ast},\nu=10^0$$', ...
        '$$ \mathcal{WS}_T^{\ast},\nu=10^{-2}$$', ...
        '$$ \mathcal{WS}_T^{\ast},\nu=10^{-4}$$', 'Location', 'northwest');
    set(h,'Interpreter','latex');
    
    set(gca,'FontSize',20);
    
    
    
elseif strcmp(model_opt,'logistic_regression')
    
end