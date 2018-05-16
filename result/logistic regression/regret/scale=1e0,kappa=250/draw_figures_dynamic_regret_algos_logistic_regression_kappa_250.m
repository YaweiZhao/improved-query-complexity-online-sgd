%scale = 1e0



model_opt = 'logistic_regression';
if strcmp(model_opt,'logistic_regression')
    sum_time_seq_OGD = [100 200 300 400 500 700 800 900];
    sum_f_seq_OGD = [ 0.0312 0.034 0.036 0.038 0.0388 0.04 0.042 0.0426];
    
    sum_time_seq_OMGD = [100 200 300 400 500 700 800 900];
    sum_f_seq_OMGD = [0.0062 0.0068 0.0071 0.0076 0.00784 0.0084 0.0087 0.0089];
    
    sum_time_seq_MOGD = [100 200 300 400 500 700 800 900];
    sum_f_seq_MOGD = [0.001 0.0013 0.0014 0.0016 0.00172 0.002 0.00215 0.0023];
    
    semilogy(sum_time_seq_OGD, sum_f_seq_OGD, '-r','LineWidth', 2);
    hold on;
    semilogy(sum_time_seq_OMGD, sum_f_seq_OMGD, '--b','LineWidth', 2);
    hold on;
    
    semilogy(sum_time_seq_MOGD, sum_f_seq_MOGD, ':k','LineWidth', 2);
    hold on;

    
    
    xlabel('Iterations', 'fontsize', 18);
    ylabel('Dynamic regret', 'fontsize', 18 );
    %set(gca,'ytick',[1e-9 1e-7 1e-5 1e-3 1e-1 1e1 1e3]);
    %set(gca,'yticklabel',{'Two','Four','Five','Seven'});
    axis([100 900 1e-4 1e-1]);
    %$$ \mathcal{P}_T^{\ast} $$
    h = legend('OGD', ...
        'OMGD', ...
        'MOGD', ...
        'Location', 'southeast');
    
    set(h,'Interpreter','latex');
    
    set(gca,'FontSize',20);
    
    
    
    
end
