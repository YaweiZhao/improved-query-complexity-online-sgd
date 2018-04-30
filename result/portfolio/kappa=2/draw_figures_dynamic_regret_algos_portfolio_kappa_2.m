sum_f_seq_SGD = load('./SGD/sum_f_seq.txt','-ascii');
sum_time_seq_SGD = load('./SGD/sum_time_seq.txt','-ascii');
sum_f_seq_GD = load('./GD/sum_f_seq.txt','-ascii');
sum_time_seq_GD = load('./GD/sum_time_seq.txt','-ascii');
sum_f_seq_SVRG = load('./SVRG/sum_f_seq.txt','-ascii');
sum_time_seq_SVRG = load('./SVRG/sum_time_seq.txt','-ascii');

model_opt = 'portfolio';
if strcmp(model_opt,'portfolio')
    
    %var = 0.01
    
    semilogy(sum_time_seq_SGD, sum_f_seq_SGD, '-r','LineWidth', 2);
    hold on;
    semilogy(sum_time_seq_GD, sum_f_seq_GD, '--b','LineWidth', 2);
    hold on;
    
    semilogy(sum_time_seq_SVRG, sum_f_seq_SVRG, '-.g','LineWidth', 2);
    hold on;
    
    
    xlabel('CPU seconds', 'fontsize', 18);
    ylabel('Dynamic regret', 'fontsize', 18 );
    %set(gca,'ytick',[1e-9 1e-7 1e-5 1e-3 1e-1 1e1 1e3]);
    %set(gca,'yticklabel',{'Two','Four','Five','Seven'});
    axis([1 32 1e0 1e4]);
    set(gca, 'ytick', [1e1 1e2 1e3 1e4]);
    h = legend('MOGD-SGD', ...
        'MOGD-GD', ...
        'MOGD-SVRG', ...
        'Location', 'southeast');
    
    set(h,'Interpreter','latex');
    
    set(gca,'FontSize',20);
    
    
    
    
end
