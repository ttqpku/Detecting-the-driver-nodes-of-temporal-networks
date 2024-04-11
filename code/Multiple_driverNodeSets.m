
%==========================================================================
% Select one or two random driver nodes and obtain the relaxed sets of 
% driver nodes by the improved online time-accelerated heuristic algorithm
%==========================================================================

%--------------------------------------------------------------------------
% MAIN CODE
% clear all
ants_data = readtable('../datasets/ants/1-1 data.csv');
ants_data = table2array(ants_data);
ants_data = sortrows(ants_data,3);
actor = ants_data(1:end,1);
target = ants_data(1:end,2);
time = ants_data(1:end,3);
start_time = min(time);
end_time = max(time);
cnt = 0;
tmp = inf;
for i=1:length(actor)
    if time(i)~=tmp
        cnt = cnt+1;
    end
    tmp = time(i);
    time(i) = cnt;
end
time_layer = max(time);
num = max(max(actor),max(target));




n = num;
delta_t = time_layer;

tmp_A = zeros(num,num,time_layer);
for i=1:length(actor)
    tmp_A(actor(i),target(i),time(i)) = 1;
end

 for i=1:time_layer
     tmp_ = tmp_A(:,:,i);
     tmp_(1:n+1:n^2) = 1;
     tmp_A(:,:,i) = tmp_;
 end


ants_edge = [];
for i=1:time_layer
    [row,col] = find(tmp_A(:,:,i)~=0);
    ants_edge = [ants_edge;row+(i-1)*n,col+i*n];
end
allFun = Utils;
D_k_random_all = nchoosek((1:n),2);
result_all = cell(1,size(D_k_random_all,1));
for i = 1:size(D_k_random_all,1)
D_k_random = D_k_random_all(i,:);
result_all{i} = allFun.OTaHa_imp(ants_edge,n,D_k_random,delta_t);
end
save('OTaHa_imp_1_1.mat','result_all');