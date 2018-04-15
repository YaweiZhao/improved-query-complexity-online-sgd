%our method
sum_f_seq_var_01_level_2 = load('./levels=2(default)/var=0.01(default)/sum_f_seq.txt','-ascii');
sum_f_seq_var_0001_level_2 = load('./levels=2(default)/var=0.0001/sum_f_seq.txt','-ascii');
sum_f_seq_var_01_level_5 = load('./levels=5/var=0.01(default)/sum_f_seq.txt','-ascii');
sum_f_seq_var_0001_level_5 = load('./levels=5/var=0.0001/sum_f_seq.txt','-ascii');

model_opt = 'logistic_regression';
index_x_seq = 20*(1:fix((T-1)/20));
if strcmp(model_opt,'logistic_regression')
    
    %var = 0.01
    semilogy(index_x_seq, sum_f_seq_var_01_level_2(index_x_seq), '-or'); 
    hold on;
    semilogy(index_x_seq, sum_f_seq_var_0001_level_2(index_x_seq), '-+r'); 
    hold on;
    
    semilogy(index_x_seq, sum_f_seq_var_01_level_5(index_x_seq), '-ob');
    hold on;
    semilogy(index_x_seq, sum_f_seq_var_0001_level_5(index_x_seq), '-+b'); 
    hold on;
    
    
    xlabel('Iterations', 'fontsize', 18);
    ylabel('Dynamic regret', 'fontsize', 18 );
    %$$ \mathcal{P}_T^{\ast} $$
    h = legend('$$l=2,\nu = 10^{-2}$$', ...
        '$$ l=2,\nu = 10^{-4}$$', ...
        '$$l=5,\nu = 10^{-2}$$', ...
        '$$ l=5,\nu = 10^{-4}$$', ...
        'Location', 'southwest');
    
    set(h,'Interpreter','latex');
    
    set(gca,'FontSize',20);
    
    
    
    
end