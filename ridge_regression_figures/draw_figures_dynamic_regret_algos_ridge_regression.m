%dynamic regret for algos
%% var = 0.01, levels = 10.
%%

sum_f_seq_OGD = load('./OGD/sum_f_seq.txt','-ascii');
sum_time_seq_OGD = load('./OGD/sum_time_seq.txt','-ascii');
sum_f_seq_OMGD = load('./OMGD/sum_f_seq.txt','-ascii');
sum_time_seq_OMGD = load('./OMGD/sum_time_seq.txt','-ascii');
sum_f_seq_MOGD = load('./MOGD/sum_f_seq.txt','-ascii');
sum_time_seq_MOGD = load('./MOGD/sum_time_seq.txt','-ascii');
sum_f_seq_NAGM = load('./NAGM/sum_f_seq.txt','-ascii');
sum_time_seq_NAGM = load('./NAGM/sum_time_seq.txt','-ascii');

model_opt = 'ridge_regression';
if strcmp(model_opt,'ridge_regression')
    
    %var = 0.01
    semilogy(sum_time_seq_OGD, sum_f_seq_OGD, '-r','LineWidth', 2); 
    hold on;
    semilogy(sum_time_seq_OMGD, sum_f_seq_OMGD, '--b','LineWidth', 2); 
    hold on;
    
    semilogy(sum_time_seq_MOGD, sum_f_seq_MOGD, '-.g','LineWidth', 2);
    hold on;
    semilogy(sum_time_seq_NAGM, sum_f_seq_NAGM, ':k','LineWidth', 2); 
    hold on;
    
    
    xlabel('CPU seconds', 'fontsize', 18);
    ylabel('Dynamic regret', 'fontsize', 18 );
    axis([1 400 1e-2 100000]);
    %$$ \mathcal{P}_T^{\ast} $$
    h = legend('OGD', ...
        'OMGD', ...
        'MOGD-GD', ...
        'MOGD-NAGM', ...
        'Location', 'southeast');
    
    set(h,'Interpreter','latex');
    
    set(gca,'FontSize',20);
    
    
    
    
end