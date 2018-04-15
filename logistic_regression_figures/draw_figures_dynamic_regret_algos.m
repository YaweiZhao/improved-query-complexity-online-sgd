%our method
sum_f_seq_var_01_level_2_MOGD = load('./levels=2(default)/MOGD/var=0.01(default)/sum_f_seq.txt','-ascii');
time_seq_var_01_level_2_MOGD =  load('./levels=2(default)/MOGD/var=0.01(default)/time_seq.txt','-ascii');
sum_f_seq_var_01_level_2_OMGD = load('./levels=2(default)/OMGD/var=0.01(default)/sum_f_seq.txt','-ascii');
time_seq_var_01_level_2_OMGD = load('./levels=2(default)/OMGD/var=0.01(default)/time_seq.txt','-ascii');
%sum_f_seq_var_01_level_5 = load('./levels=5/var=0.01(default)/sum_f_seq.txt','-ascii');
%sum_f_seq_var_01_level_5 = load('./levels=5/var=0.0001/sum_f_seq.txt','-ascii');

model_opt = 'logistic_regression';

index_x_seq_OMGD = 20*(1:4000/20);
index_x_seq_MOGD = 20*(1:10000/20);
if strcmp(model_opt,'logistic_regression')
    
    %var = 0.01
    semilogy(time_seq_var_01_level_2_MOGD(index_x_seq), sum_f_seq_var_01_level_2_MOGD(index_x_seq), '-or'); 
    hold on;
    %semilogy(index_x_seq, sum_f_seq_var_0001_level_2(index_x_seq), '-+r'); 
    %hold on;
    
    semilogy(time_seq_var_01_level_2_OMGD(index_x_seq), sum_f_seq_var_01_level_2_OMGD(index_x_seq), '-ob');
    hold on;
    %semilogy(index_x_seq, sum_f_seq_var_0001_level_5(index_x_seq), '-+b'); 
    %hold on;
    
    
    xlabel('CPU seconds', 'fontsize', 18);
    ylabel('Dynamic regret', 'fontsize', 18 );
    %$$ \mathcal{P}_T^{\ast} $$
    h = legend('MOGD', ...
        'OMGD', ...
        'Location', 'southwest');
    
    set(h,'Interpreter','latex');
    
    set(gca,'FontSize',20);
    
    
    
    
end