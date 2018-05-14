function[] = drqw_figures_orr_scale_1e2_kappa_4e4()
%scale=1e2, kappa=4e4
% loss_seq_OGD = load('./OGD/loss_seq_OGD.txt','-ascii');
% time_seq_OGD = load('./OGD/time_seq_OGD.txt','-ascii');
% [new_time_seq_OGD, new_loss_seq_OGD] = get_new_seqs(time_seq_OGD,loss_seq_OGD);
% loss_seq_OMGD = load('./OMGD/loss_seq_OMGD.txt','-ascii');
% time_seq_OMGD = load('./OMGD/time_seq_OMGD.txt','-ascii');
% [new_time_seq_OMGD, new_loss_seq_OMGD] = get_new_seqs(time_seq_OMGD,loss_seq_OMGD);
% loss_seq_MOGD2 = load('./MOGD2/loss_seq_MOGD2.txt','-ascii');
% %sum_f_seq_MOGD = [sum_f_seq_MOGD; sum_f_seq_MOGD(length(sum_f_seq_MOGD))*ones(2,1)];
% time_seq_MOGD2 = load('./MOGD2/time_seq_MOGD2.txt','-ascii');
% [new_time_seq_MOGD2, new_loss_seq_MOGD2] = get_new_seqs(time_seq_MOGD2,loss_seq_MOGD2);
% loss_seq_MOGD10 = load('./MOGD10/loss_seq.txt','-ascii');
% %sum_f_seq_NAGM = [sum_f_seq_NAGM; sum_f_seq_NAGM(length(sum_f_seq_NAGM))*ones(11,1)];
% time_seq_MOGD10 = load('./MOGD10/time_seq.txt','-ascii');
% [new_time_seq_MOGD10, new_loss_seq_MOGD10] = get_new_seqs(time_seq_MOGD10,loss_seq_MOGD10);
% %scale: 1e-1
% new_time_seq_OGD = 100:100:800;
% new_loss_seq_OGD = [2.17 4.7 6.72 9 11 13 15 17.2];
% 
% new_time_seq_OMGD = 100:100:800;
% new_loss_seq_OMGD = [1.65 3.65 5.29 7 8.8 10.5 12.07 13.8];
% 
% new_time_seq_MOGD10 = 100:100:800;
% new_loss_seq_MOGD10 = [0.64 1.46 2.14 2.87 3.6 4.32 4.95 5.67];
% %scale: 1e-2
% new_time_seq_OGD = 100:100:800;
% new_loss_seq_OGD = [1.88 4 5.7 7.7 9.38 11.1 12.65 14.39];
% 
% new_time_seq_OMGD = 100:100:800;
% new_loss_seq_OMGD = [1.36 2.97 4.27 5.7 7.1 8.44 9.66 11];
% 
% new_time_seq_MOGD10 = 100:100:800;
% new_loss_seq_MOGD10 = [1 2.22 3.23 4.33 5.37 6.4 7.36 8.4];

% %scale: 1e0
new_time_seq_OGD = 100:100:800;
new_loss_seq_OGD = [2.17 4.69 6.7 9 11.14 13.24 15 17.17];

new_time_seq_OMGD = 100:100:800;
new_loss_seq_OMGD = [1.65 3.65 5.29 7 8.85 10.56 12.07 14];

new_time_seq_MOGD10 = 100:100:800;
new_loss_seq_MOGD10 = [1.3 2.9 4.25 5.64 7.13 8.54 9.77 11.19];



model_opt = 'ridge_regression';
if strcmp(model_opt,'ridge_regression')
    
    %var = 0.01
    plot(new_time_seq_OGD, new_loss_seq_OGD, '-r','LineWidth', 2);
    hold on;
    plot(new_time_seq_OMGD, new_loss_seq_OMGD, '--b','LineWidth', 2);
    hold on;
    plot(new_time_seq_MOGD10, new_loss_seq_MOGD10, ':k','LineWidth', 2);
    hold on;
%     semilogy(new_time_seq_OGD, new_loss_seq_OGD, '-r','LineWidth', 2);
%     hold on;
%     semilogy(new_time_seq_OMGD, new_loss_seq_OMGD, '--b','LineWidth', 2);
%     hold on;
%     
%     semilogy(new_time_seq_MOGD2, new_loss_seq_MOGD2, '-.g','LineWidth', 2);
%     hold on;
%     semilogy(new_time_seq_MOGD10, new_loss_seq_MOGD10, ':k','LineWidth', 2);
%     hold on;
    
    
    xlabel('Iterations', 'fontsize', 18);
    ylabel('Dynamic regret', 'fontsize', 18 );
    %set(gca,'ytick',[1e-9 1e-7 1e-5 1e-3 1e-1 1e1 1e3]);
    %set(gca,'yticklabel',{'Two','Four','Five','Seven'});
    axis([100 800 1e-1 20]);
    %set(gca, 'ytick', [1e-1 1e-1 1e1 1e3]);
    h = legend('OGD', ...
        'OMGD', ...
        'MOGD', ...
        'Location', 'northwest');
    
    set(h,'Interpreter','latex');
    
    set(gca,'FontSize',20);
    
    
    
    
end
end



function[sum_time_seq, loss_seq] = get_new_seqs(time_seq,loss_seq)
nonzero_index = find(time_seq);
last_nonzero_index_time_seq = nonzero_index(length(nonzero_index));
loss_seq = loss_seq(1:last_nonzero_index_time_seq);
time_seq = time_seq(1:last_nonzero_index_time_seq);
n_t = length(time_seq);
sum_time_seq = zeros(n_t,1);
for i=1:n_t
    sum_time_seq(i,:) = sum(time_seq(1:i));
end
end
