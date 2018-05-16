%scale = 1e2



model_opt = 'logistic_regression';
if strcmp(model_opt,'logistic_regression')
    sum_time_seq_OGD = 100:100:800;
    sum_f_seq_OGD = [0.325 1.807 5.268 11.565 21.09 33.23 49 67];
    
    sum_time_seq_OMGD = 100:100:800;
    sum_f_seq_OMGD = [0.3196 1.749 5.01 10.8 19.29 29.71 42.68 56.8 ];
    
    sum_time_seq_MOGD = 100:100:800;
    sum_f_seq_MOGD = [0.294 1.487 3.94 7.8 12.7 18.12 25.4 33.89 ];
    
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
    axis([100 800 0.2 100]);
    %$$ \mathcal{P}_T^{\ast} $$
    h = legend('OGD', ...
        'OMGD', ...
        'MOGD', ...
        'Location', 'southeast');
    
    set(h,'Interpreter','latex');
    
    set(gca,'FontSize',20);
    
    
    
    
end
