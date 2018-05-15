function[] = drqw_figures_orr_scale_1e0_kappa_1500()
%scale: 1e0, cpu-small
new_time_seq_OGD = 100:100:600;
new_loss_seq_OGD = [65073 97084 124151 152624 179976 208537];

new_time_seq_OMGD = 100:100:600;
new_loss_seq_OMGD = [26903 34847 38605 41199 44114 46617];

new_time_seq_MOGD10 = 100:100:600;
new_loss_seq_MOGD10 = [25871 33395 36775 38841 41264 43342];
% %scale: 1e-2
% new_time_seq_OGD = 100:100:800;
% new_loss_seq_OGD = [1.88 4 5.7 7.7 9.38 11.1 12.65 14.39];
% 
% new_time_seq_OMGD = 100:100:800;
% new_loss_seq_OMGD = [1.36 2.97 4.27 5.7 7.1 8.44 9.66 11];
% 
% new_time_seq_MOGD10 = 100:100:800;
% new_loss_seq_MOGD10 = [1 2.22 3.23 4.33 5.37 6.4 7.36 8.4];



model_opt = 'ridge_regression';
if strcmp(model_opt,'ridge_regression')
    
    %var = 0.01
    semilogy(new_time_seq_OGD, new_loss_seq_OGD, '-r','LineWidth', 2);
    hold on;
    semilogy(new_time_seq_OMGD, new_loss_seq_OMGD, '--b','LineWidth', 2);
    hold on;
    semilogy(new_time_seq_MOGD10, new_loss_seq_MOGD10, ':k','LineWidth', 2);
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
    axis([100 600 1e4 1e6]);
    %set(gca, 'ytick', [1e-1 1e-1 1e1 1e3]);
    h = legend('OGD', ...
        'OMGD', ...
        'MOGD', ...
        'Location', 'southeast');
    
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
