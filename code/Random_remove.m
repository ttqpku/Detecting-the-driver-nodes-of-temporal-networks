clear all
dataRaw = load('../datasets/DPPIN-main/DPPIN-Hazbun/Dynamic_PPIN.txt');
data = dataRaw(:,1:3);
actor = data(1:end,1);
target = data(1:end,2);
time = data(1:end,3);
actor = actor + 1;
target = target +1;
time = time + 1;

time_layer = max(time);
num = max(max(actor),max(target));


tmp_A = zeros(num,num,time_layer);
for i=1:length(actor)
    tmp_A(actor(i),target(i),time(i)) = 1;
end
n = num;
delta_t = time_layer;
protein_edge = [];
for i=1:time_layer
    [row,col] = find(tmp_A(:,:,i)~=0);
    protein_edge = [protein_edge;row+(i-1)*n,col+i*n];
end

len_edge = size(protein_edge,1);

load('../data/OTaHa_imp_protein.mat');
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
randomRemove = cell(20,1);

po = parpool(10);
parfor p = 1:20
randomRemove{p} = removeEdge(D_min,n,delta_t,p*0.05,len_edge,protein_edge);
p
end
delete(po);
save('randomRemove_protein.mat','randomRemove');

% -------------------------------------------------------------------------
% Function
function randomRemove = removeEdge(nodeSet,n,delta_t,p,len_,time_edges)

remove_num = round(len_*p);
randomRemove = zeros(length(nodeSet),100);
for k = 1:length(nodeSet)
    Node = nodeSet{k};
    for repeat = 1:100
    idx_tmp = randperm(len_,remove_num);
    tmp_edge = time_edges;
    tmp_edge(idx_tmp,:) = [];
    for j = 1:delta_t
        tmp_edge = [tmp_edge;[1:n]'+(j-1)*n,[1:n]'+j*n];
    end
    len1 = length(MCS_fun(tmp_edge,Node,n,delta_t));
    randomRemove(k,repeat) = len1;
    disp(["repeat: ",num2str(repeat)]);
    disp(["repeat: ",num2str(k)]);
    end
end

end

