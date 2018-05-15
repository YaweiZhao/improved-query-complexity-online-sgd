function[] = drqw_figures_orr_scale_1e0_kappa_1500()
%scale: 1e0, cpu-small
new_time_seq_OGD = 100:100:600;
new_loss_seq_OGD = [65073 97084 124151 152624 179976 208537];

new_time_seq_OMGD = 100:100:600;
new_loss_seq_OMGD = [26903 34847 38605 41199 44114 46617];

new_time_seq_MOGD10 = 100:100:600;
new_loss_seq_MOGD10 = [25871 33395 36775 38841 41264 43342];
% 
% %scale: 1e2, cpu-small
% new_time_seq_OGD = 100:100:800;
% new_loss_seq_OGD = [69316 108332 144153 179877 215213 250288 284156 317853];
% 
% new_time_seq_OMGD = 100:100:800;
% new_loss_seq_OMGD = [35404 68463 102184 135872 169792 203045 235843 269783];
% 
% new_time_seq_MOGD10 = 100:100:800;
% new_loss_seq_MOGD10 = [32236 64014 96196 128676 161190 193264 225063 257446];



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
    axis([100 600 1e4 2.5e5]);
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
