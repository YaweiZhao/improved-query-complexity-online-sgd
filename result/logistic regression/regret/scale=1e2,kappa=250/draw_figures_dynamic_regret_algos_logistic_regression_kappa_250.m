

model_opt = 'logistic_regression';
if strcmp(model_opt,'logistic_regression')
%     %scale = 1e2, synthetic
%     sum_time_seq_OGD = 100:100:1000;
%     sum_f_seq_OGD = [0.3277 1.83 5.37 11.78 21.46 33.8 49.78 68.12 89.35 112.78];
%     
%     sum_time_seq_OMGD = 100:100:1000;
%     sum_f_seq_OMGD = [0.3222 1.77 5.11 11.02 19.66 30.28 43.46 57.82 73.49 89.63];
%     
%     sum_time_seq_MOGD = 100:100:1000;
%     sum_f_seq_MOGD = [0.2967 1.513 4.0338 8.021 13.10 18.34 23.76 28.43 32.39 35.44];
%     
%     semilogy(sum_time_seq_OGD, sum_f_seq_OGD, '-r','LineWidth', 2);
%     hold on;
%     semilogy(sum_time_seq_OMGD, sum_f_seq_OMGD, '--b','LineWidth', 2);
%     hold on;
%     
%     semilogy(sum_time_seq_MOGD, sum_f_seq_MOGD, ':k','LineWidth', 2);
%     hold on;
%scale = 1e2, real dataset: skin
    sum_time_seq_OGD = 100:100:800;
    sum_f_seq_OGD = [0.0311 0.0339 0.036 0.038 0.0387 0.0406 0.0408 0.0424];
    
    sum_time_seq_OMGD = 100:100:800;
    sum_f_seq_OMGD = [0.00619 0.0068 0.0072 0.0076 0.00786 0.0082 0.0084 0.0087];
    
    sum_time_seq_MOGD = 100:100:800;
    sum_f_seq_MOGD = [0.001 0.0013 0.0014 0.0016 0.00175 0.00187 0.00206 0.002156];
    
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
    axis([100 800 1e-4 1e-1]);
    %$$ \mathcal{P}_T^{\ast} $$
    h = legend('OGD', ...
        'OMGD', ...
        'MOGD', ...
        'Location', 'southeast');
    
    set(h,'Interpreter','latex');
    
    set(gca,'FontSize',20);
    
    
    
    
end
