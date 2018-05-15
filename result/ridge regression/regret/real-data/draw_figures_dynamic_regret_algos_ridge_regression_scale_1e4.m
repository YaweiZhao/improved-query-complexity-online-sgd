function[] = drqw_figures_orr_scale_1e4_kappa_1500()
% %scale: 1e0, cpu-small? kappa=1.5e5
% new_time_seq_OGD = [21 42 63 85 107 130];
% new_loss_seq_OGD = [ 8514 18256 26690 36539 44629 53216];
% 
% new_time_seq_OMGD = [21 43 65 88 110 133];
% new_loss_seq_OMGD = [785 1556 2323 3093 3811 4582];
% 
% new_time_seq_MOGD10 = [26 51 76 103 127];
% new_loss_seq_MOGD10 = [746 1474 2186 2912 3581 ];
% 
% %scale: 1e4, cpu-small,kappa=8e4
%new_time_seq_OGD = 100:100:800;
%new_loss_seq_OGD = [69316 108332 144153 179877 215213 250288 284156 317853];

new_time_seq_OMGD = [23 34 46 57 68 80 91 103 114 125 ];
new_loss_seq_OMGD = [4858 7228 9635 11856 14257 16725 19164 21553 23893 26351];

new_time_seq_MOGD10 = [11.28 22.21 33.7 44.8 56.5 67.27 79.16 90.14 100.72 111.57 122.24 ];
new_loss_seq_MOGD10 = [2384 4721 6999 9330 11469 13786 16149 18499 20799 23048 25401 ];



model_opt = 'ridge_regression';
if strcmp(model_opt,'ridge_regression')
    
    %var = 0.01
    %semilogy(new_time_seq_OGD, new_loss_seq_OGD, '-r','LineWidth', 2);
    %hold on;
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
    
    
    xlabel('CPU seconds', 'fontsize', 18);
    ylabel('Dynamic regret', 'fontsize', 18 );
    %set(gca,'ytick',[1e-9 1e-7 1e-5 1e-3 1e-1 1e1 1e3]);
    %set(gca,'yticklabel',{'Two','Four','Five','Seven'});
    axis([10 126 1e2 1e5]);
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
