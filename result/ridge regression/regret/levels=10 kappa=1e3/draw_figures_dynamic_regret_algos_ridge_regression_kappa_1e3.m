sum_f_seq_OGD = load('./OGD/sum_f_seq.txt','-ascii');
sum_time_seq_OGD = load('./OGD/sum_time_seq.txt','-ascii');
sum_f_seq_OMGD = load('./OMGD/sum_f_seq.txt','-ascii');
sum_time_seq_OMGD = load('./OMGD/sum_time_seq.txt','-ascii');
sum_f_seq_MOGD = load('./MOGD/sum_f_seq.txt','-ascii');
%sum_f_seq_MOGD = [sum_f_seq_MOGD; sum_f_seq_MOGD(length(sum_f_seq_MOGD))*ones(2,1)];
sum_time_seq_MOGD = load('./MOGD/sum_time_seq.txt','-ascii');
sum_f_seq_NAGM = load('./NAGM/sum_f_seq.txt','-ascii');
%sum_f_seq_NAGM = [sum_f_seq_NAGM; sum_f_seq_NAGM(length(sum_f_seq_NAGM))*ones(11,1)];
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
    %set(gca,'ytick',[1e-9 1e-7 1e-5 1e-3 1e-1 1e1 1e3]);
    %set(gca,'yticklabel',{'Two','Four','Five','Seven'});
    axis([1 302 1e-5 1e3]);
    set(gca, 'ytick', [1e-5 1e-3 1e-1 1e1 1e3]);
    h = legend('OGD', ...
        'OMGD', ...
        'MOGD-GD', ...
        'MOGD-NAGM', ...
        'Location', 'southeast');
    
    set(h,'Interpreter','latex');
    
    set(gca,'FontSize',20);
    
    
    
    
end
