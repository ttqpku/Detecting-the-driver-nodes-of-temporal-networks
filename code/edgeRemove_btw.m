
%% Example
% G = digraph([1,1,2,3,3,4,4,5,5],[2,3,4,4,5,7,8,7,6]);
% plot(G)
% [EBC, BC]=edge_betweenness_num(G);

%% An exampple of removing edges in the colony 1-1
clear all
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


tmp_A = zeros(num,num,time_layer);
for i=1:length(actor)
    tmp_A(actor(i),target(i),time(i)) = 1;
end
n = num;


delta_t = time_layer;
ants_edge = [];
for i=1:time_layer
    [row,col] = find(tmp_A(:,:,i)~=0);
    ants_edge = [ants_edge;row+(i-1)*n,col+i*n];
end
len_edge = size(ants_edge,1);

load('../results/OTaHa_imp_1_1.mat');
len_ = cellfun(@(x) size(x,2),result_all);
[~,idx] = sort(len_,'ascend');
D_final = {};
for i = 1:length(result_all)
    D_final{i} = result_all{idx(i)};
end
D_final_diff = {};
cnt_D_diff = 0;
for i = 1:length(D_final)
    if cnt_D_diff == 0
        cnt_D_diff = cnt_D_diff + 1;
        D_final_diff{cnt_D_diff} = D_final{i};
        continue;
    end
    flag_ = 0;
    for j = 1:cnt_D_diff

        if isempty(setdiff(D_final_diff{j},D_final{i}))
            flag_ = 1;
            break
        end
    end
    if flag_ == 0
        cnt_D_diff = cnt_D_diff + 1;
        D_final_diff{cnt_D_diff} = D_final{i};
    end

end
min_ = min(len_);
D_min = {};
cnt_D_min = 0;
for i = 1:length(D_final_diff)
if length(D_final_diff{i}) > min_
    break
else
    cnt_D_min = cnt_D_min +1 ;
    D_min{cnt_D_min} = D_final_diff{i};
end
end



flowRemove =zeros(20,cnt_D_min);
po = parpool(10);
parfor p = 1:20
for i = 1:cnt_D_min
    remove_num = round(len_edge*0.05*p);
    tmp_edge = ants_edge;
    % Add the edges from the source node to the driver nodes
    for j = 1:length(D_min{i})
    tmp_edge = [zeros(delta_t+1,1),[D_min{i}(j):n:n*(delta_t+1)]';tmp_edge];
    end
    tmp_edge = tmp_edge + 1;
    Edgetable = table(tmp_edge,'VariableNames',{'EndNodes'});
    G = digraph(Edgetable);

     cnt = edge_betweenness_num(G);
     % -----------------------------
     random_index = randperm(size(cnt,1),size(cnt,1));
     cnt = cnt(random_index,:);
     % -----------------------------
     [row,~] = find(cnt(:,1)==1);
     % targeted attacks in descending order of edge betweenness
     cnt(row,3) = 0;
     [a,idx_cnt] = sort(cnt(:,3),'descend');

     % targeted attacks in ascending order of edge betweenness
     % cnt(row,3) = inf;
     % [a,idx_cnt] = sort(cnt(:,3),'ascend');
     
     G = rmedge(G, ...
         cnt(idx_cnt(1:remove_num),1), ...
         cnt(idx_cnt(1:remove_num),2));
    for j = 1:delta_t
        G = addedge(G,1:n+(j-1)*n+1,1:n+j*n+1);
    end
    rest_edge = table2array(G.Edges);
    rest_edge(rest_edge(:,1)==1,:) = [];
    rest_edge = rest_edge -1;
    len2 = MCS_fun(rest_edge,D_min{i},n,delta_t);
    flowRemove(p,i) = length(len2);
end
disp(["i: ",num2str(i)]);
disp(["p: ",num2str(p)]);
end
delete(po);
save('edge_btw_1_1_descend.mat','flowRemove');
% save('edge_btw_1_1_ascend.mat','flowRemove');



