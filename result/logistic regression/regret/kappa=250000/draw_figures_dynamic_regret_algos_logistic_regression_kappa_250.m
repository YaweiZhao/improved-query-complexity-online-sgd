% sum_f_seq_OGD = load('./OGD/sum_f_seq.txt','-ascii');
% sum_time_seq_OGD = load('./OGD/sum_time_seq.txt','-ascii');
% sum_f_seq_OMGD = load('./OMGD/sum_f_seq.txt','-ascii');
% sum_time_seq_OMGD = load('./OMGD/sum_time_seq.txt','-ascii');
% sum_f_seq_MOGD = load('./MOGD/sum_f_seq.txt','-ascii');
% %sum_f_seq_MOGD = [sum_f_seq_MOGD; sum_f_seq_MOGD(length(sum_f_seq_MOGD))*ones(2,1)];
% sum_time_seq_MOGD = load('./MOGD/sum_time_seq.txt','-ascii');
% sum_f_seq_NAGM = load('./NAGM/sum_f_seq.txt','-ascii');
% %sum_f_seq_NAGM = [sum_f_seq_NAGM; sum_f_seq_NAGM(length(sum_f_seq_NAGM))*ones(11,1)];
% sum_time_seq_NAGM = load('./NAGM/sum_time_seq.txt','-ascii');
%kappa = 2.5e4, real dataset: skin
sum_time_seq_OGD = [30 63 100 138 181 227];
sum_f_seq_OGD = [0.23 0.27 0.289 0.31 0.322 0.332];

sum_time_seq_OMGD = [73 150 231 ];
sum_f_seq_OMGD = [0.035 0.044 0.0486];

sum_time_seq_MOGD = [ ];
sum_f_seq_MOGD = [0.08 0.1 0.11 0.12 0.126 0.13];

model_opt = 'logistic_regression';
if strcmp(model_opt,'logistic_regression')
    
    %var = 0.01
    
    semilogy(sum_time_seq_OGD, sum_f_seq_OGD, '-r','LineWidth', 2);
    hold on;
    semilogy(sum_time_seq_OMGD, sum_f_seq_OMGD, '--b','LineWidth', 2);
    hold on;
    
    semilogy(sum_time_seq_MOGD, sum_f_seq_MOGD, ':k','LineWidth', 2);
    hold on;
    %semilogy(sum_time_seq_NAGM, sum_f_seq_NAGM, ':k','LineWidth', 2);
    %hold on;
    
    
    xlabel('CPU seconds', 'fontsize', 18);
    ylabel('Dynamic regret', 'fontsize', 18 );
    %set(gca,'ytick',[1e-9 1e-7 1e-5 1e-3 1e-1 1e1 1e3]);
    %set(gca,'yticklabel',{'Two','Four','Five','Seven'});
    axis([14 109 1e-2 10]);
    %$$ \mathcal{P}_T^{\ast} $$
    h = legend('OGD', ...
        'OMGD', ...
        'MOGD', ...
        'Location', 'southeast');
    
    set(h,'Interpreter','latex');
    
    set(gca,'FontSize',20);
    
    
    
    
end
