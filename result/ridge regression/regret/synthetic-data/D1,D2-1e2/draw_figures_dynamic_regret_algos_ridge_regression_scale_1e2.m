function[] = drqw_figures_orr_scale_1e2_kappa_4e4()
%scale=1e2, kappa=4e4
loss_seq_OGD = load('./OGD/loss_seq.txt','-ascii');
time_seq_OGD = load('./OGD/time_seq.txt','-ascii');
[new_time_seq_OGD, new_loss_seq_OGD] = get_new_seqs(time_seq_OGD,loss_seq_OGD);
loss_seq_OMGD = load('./OMGD/loss_seq.txt','-ascii');
time_seq_OMGD = load('./OMGD/time_seq.txt','-ascii');
[new_time_seq_OMGD, new_loss_seq_OMGD] = get_new_seqs(time_seq_OMGD,loss_seq_OMGD);
loss_seq_MOGD2 = load('./MOGD2/loss_seq.txt','-ascii');
%sum_f_seq_MOGD = [sum_f_seq_MOGD; sum_f_seq_MOGD(length(sum_f_seq_MOGD))*ones(2,1)];
time_seq_MOGD2 = load('./MOGD2/time_seq.txt','-ascii');
[new_time_seq_MOGD2, new_loss_seq_MOGD2] = get_new_seqs(time_seq_MOGD2,loss_seq_MOGD2);
loss_seq_MOGD4 = load('./MOGD4/loss_seq.txt','-ascii');
%sum_f_seq_NAGM = [sum_f_seq_NAGM; sum_f_seq_NAGM(length(sum_f_seq_NAGM))*ones(11,1)];
time_seq_MOGD4 = load('./MOGD4/time_seq.txt','-ascii');
[new_time_seq_MOGD4, new_loss_seq_MOGD4] = get_new_seqs(time_seq_MOGD4,loss_seq_MOGD4);


model_opt = 'ridge_regression';
if strcmp(model_opt,'ridge_regression')
    
    %var = 0.01
    
    semilogy(new_time_seq_OGD, new_loss_seq_OGD, '-r','LineWidth', 2);
    hold on;
    semilogy(new_time_seq_OMGD, new_loss_seq_OMGD, '--b','LineWidth', 2);
    hold on;
    
    semilogy(new_time_seq_MOGD2, new_loss_seq_MOGD2, '-.g','LineWidth', 2);
    hold on;
    semilogy(new_time_seq_MOGD4, new_loss_seq_MOGD4, ':k','LineWidth', 2);
    hold on;
    
    
    xlabel('CPU seconds', 'fontsize', 18);
    ylabel('Dynamic regret', 'fontsize', 18 );
    %set(gca,'ytick',[1e-9 1e-7 1e-5 1e-3 1e-1 1e1 1e3]);
    %set(gca,'yticklabel',{'Two','Four','Five','Seven'});
    axis([1 130 1e-1 1e3]);
    %set(gca, 'ytick', [1e-1 1e-1 1e1 1e3]);
    h = legend('OGD($10^{-6}$)', ...
        'OMGD($10^{-6}$)', ...
        'MOGD($2\times 10^{-6}$)', ...
        'MOGD($4\times 10^{-6}$)', ...
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
