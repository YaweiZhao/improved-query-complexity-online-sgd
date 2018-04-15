%our method
sum_f_seq_var_1_level_2 = load('./levels=2(default)/var=1/sum_f_seq.txt','-ascii');
sum_f_seq_var_01_level_2 = load('./levels=2(default)/var=0.01(default)/sum_f_seq.txt','-ascii');
sum_f_seq_var_1_level_10 = load('./levels=10/var=1/sum_f_seq.txt','-ascii');
sum_f_seq_var_01_level_10 = load('./levels=10/var=0.01/sum_f_seq.txt','-ascii');

model_opt = 'ridge_regression';
index_x_seq = 20*(1:fix((T-1)/20));
if strcmp(model_opt,'ridge_regression')
    
    %var = 0.01
    semilogy(index_x_seq, sum_f_seq_var_1_level_2(index_x_seq), '-or'); 
    hold on;
    semilogy(index_x_seq, sum_f_seq_var_01_level_2(index_x_seq), '-+r'); 
    hold on;
    
    semilogy(index_x_seq, sum_f_seq_var_1_level_10(index_x_seq), '-ob');
    hold on;
    semilogy(index_x_seq, sum_f_seq_var_01_level_10(index_x_seq), '-+b'); 
    hold on;
    
    
    xlabel('Iterations', 'fontsize', 18);
    ylabel('Dynamic regret', 'fontsize', 18 );
    %$$ \mathcal{P}_T^{\ast} $$
    h = legend('$$l=2,\nu = 10^0$$', ...
        '$$ l=2,\nu = 10^{-2}$$', ...
        '$$l=10,\nu = 10^0$$', ...
        '$$ l=10,\nu = 10^{-2}$$', ...
        'Location', 'southeast');
    
    set(h,'Interpreter','latex');
    
    set(gca,'FontSize',20);
    
    
    
elseif strcmp(model_opt,'logistic_regression')
    
end