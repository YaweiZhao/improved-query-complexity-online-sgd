function [ s_hyp ] = load_data( filename, s_hyp)

data = load(filename);
data = data.data;
y=data(:,1);
[~,d] = size(data);
A = data(:,2:d);
[n,d] = size(A);
s_hyp.A = A;
s_hyp.y = y;
s_hyp.n = n;
s_hyp.d =d;



end

