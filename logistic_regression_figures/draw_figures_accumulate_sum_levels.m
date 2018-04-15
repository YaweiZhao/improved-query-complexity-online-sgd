%our method
sum_x_seq_2 = load('./levels=2(default)/var=0.01(default)/sum_x_seq.txt','-ascii');
sum_x_seq_4 = load('./levels=4/var=0.01(default)/sum_x_seq.txt','-ascii');
sum_x_seq_5 = load('./levels=5/var=0.01(default)/sum_x_seq.txt','-ascii');
%sum_x_seq_10 = load('./levels=10/var=0.0001(default)/sum_x_seq.txt','-ascii');
sum_squared_x_seq_2 = load('./levels=2(default)/var=0.01(default)/sum_squared_x_seq.txt','-ascii');
sum_squared_x_seq_4 = load('./levels=4/var=0.01(default)/sum_squared_x_seq.txt','-ascii');
sum_squared_x_seq_5 = load('./levels=5/var=0.01(default)/sum_squared_x_seq.txt','-ascii');
%sum_squared_x_seq_10 = load('./levels=10/var=0.01(default)/sum_squared_x_seq.txt','-ascii');
model_opt = 'logistic_regression';
index_x_seq = 20*(1:fix((T-1)/20));
if strcmp(model_opt,'logistic_regression')
    
    %var = 0.01
    semilogy(index_x_seq(:), sum_x_seq_2(index_x_seq(:),:), '-or'); 
    hold on;
    semilogy(index_x_seq, sum_x_seq_4(index_x_seq), '-+r'); 
    hold on;
    semilogy(index_x_seq, sum_x_seq_5(index_x_seq), '-dr'); 
    hold on;
    %plot(index_x_seq, sum_x_seq_10(index_x_seq), '-xr'); 
    %hold on;
    
    semilogy(index_x_seq, sum_squared_x_seq_2(index_x_seq), '-ob');
    hold on;
    semilogy(index_x_seq, sum_squared_x_seq_4(index_x_seq), '-+b'); 
    hold on;
    semilogy(index_x_seq, sum_squared_x_seq_5(index_x_seq), '-db'); 
    hold on;
    %plot(index_x_seq, sum_squared_x_seq_10(index_x_seq), '-xb'); 
    %hold on;
    
    
    xlabel('Iterations', 'fontsize', 18);
    ylabel('Accumulate sum of variations', 'fontsize', 18 );
    %$$ \mathcal{P}_T^{\ast} $$
    h = legend('$$ \mathcal{P}_T^{\ast},l = 2$$', ...
        '$$ \mathcal{P}_T^{\ast},l = 4$$', ...
        '$$ \mathcal{P}_T^{\ast},l = 5$$', ...
        '$$ \mathcal{WS}_T^{\ast},l = 2$$', ...
        '$$ \mathcal{WS}_T^{\ast},l = 4$$', ...
        '$$ \mathcal{WS}_T^{\ast},l = 5$$',  'Location', 'northwest');
    set(h,'Interpreter','latex');
    
    set(gca,'FontSize',20);
    
  
    
end