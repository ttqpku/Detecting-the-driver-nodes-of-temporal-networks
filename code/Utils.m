function A = Utils
A.Greedy = @Greedy;
A.Heuristic = @Heuristic;
A.OTaHa = @OTaHa;
A.Optimal = @Optimal;
A.OTaHa_imp = @OTaHa_imp;
end


function D = Greedy(time_edges,n,delta_t)
 delta_e = zeros(1,n);
 D = [];
 f_D_k = 0;
 for k = 1:n
    index_delta_eio = setdiff(1:n,D);
    for i = index_delta_eio
      delta_e(i) = increment(time_edges,f_D_k,D, ...
          i,n,delta_t);
    end
    [~,index_k] = findmax(delta_e,index_delta_eio);
    D = [D,index_k];
    [nodes_tf_1,~] = MCS_fun(time_edges,D,n,delta_t);
    f_D_k = size(nodes_tf_1,1);
    if f_D_k == n
        break
    end
 end
end





function D_final = Heuristic(time_edges,n,delta_t)
MCSs={};

for i=1:n
    driverNode = [i];
    [MCSs{i},edge] = MCS_fun(time_edges,driverNode,n,delta_t);
end

a= cellfun(@(x) size(x,1),MCSs);
[~,idx] = sort(a,'descend');
resMCSs = MCSs(:,idx);

% driver_nodes selection
P = {};
[D,C_stem,idx_stem ] = driver_selection(resMCSs,1,idx);
P{1} = D;
for i=1:size(C_stem,2)
   [D_stem,~,~] = driver_selection(C_stem{i},0,idx_stem{i});
   P{i+1}=  D_stem;
end
col_P = cellfun(@(x) size(x,2),P);
[~,idx_P] = sort(col_P,'ascend');
P_sorted = P(:,idx_P);
D_final = {};
cnt_D = 0;
for i=1:size(P_sorted,2)
    sourse_P = P_sorted{i};
    [nodes_tf_P,~] = MCS_fun(time_edges,sourse_P,n,delta_t);
    if size(nodes_tf_P,1) == n
        cnt_D = cnt_D+1;
        D_final{cnt_D} = P_sorted{i};
    end
end
end

% Online time-accelerated heuristic algorithm
function D_k = OTaHa(time_edges,n,delta_t)
new_edge = time_edges;
new_edge(:,1) = new_edge(:,1)+ceil(new_edge(:,1)/n)*n;
new_edge(:,2) = new_edge(:,2)+ceil(new_edge(:,2)/n-1)*n;
% Add the edge that restricts node flow to 1
node_limit_edge = [];
for i = 1:delta_t
node_limit_edge = [node_limit_edge;(1:n)'+n*2*(i-1),(1:n)'+n*(2*i-1)];
end
new_edge = [new_edge;node_limit_edge];
new_edge = [new_edge; ((n*2*delta_t+1):n*(2*delta_t+1))',ones(n,1)*(n*(2*delta_t+1)+1)];
new_edge = new_edge + 1;
 Edgetable = table(new_edge,'VariableNames',{'EndNodes'});
 G = digraph(Edgetable);
 delta_e = zeros(1,n);
 residualCell = cell(1,n);
 edgeCell = cell(1,n);
 for i =1:n
     source = [i];
     [delta_e(i),edgeCell{i},residualCell{i}] = onlineMaxflow(G,[],source,n,delta_t);
 end
 % update
 D_k = [];
 [max_num,index_k] = findmax(delta_e,1:n);
 D_k = [D_k index_k];
 last_index = index_k;
 if max_num ~= n
 for k=2:n
    index_delta_eio = setdiff(1:n,D_k);
    flag = zeros(1,n);
while 1
    [max_num,index_k] = findmax(delta_e,index_delta_eio);
    if flag(index_k) == 1
        break
    end
    flag(index_k) = 1;
    [delta_,edgeCell{index_k},residualCell{index_k}] = onlineMaxflow(residualCell{last_index}, ...
        edgeCell{last_index},[index_k],n,delta_t);
    delta_e(index_k) = delta_;
    [max_num,~] = findmax(delta_e,setdiff(index_delta_eio,index_k));
    if delta_ < max_num
        continue
    else 
        break
    end
end
last_index = index_k;
D_k = [D_k index_k];
[f,~,~] = onlineMaxflow(G,[],D_k,n,delta_t);
 if f == n
     break
 end
 end
 end
end


function MDS = Optimal(time_edges,n,delta_t)
    flag_ = 0;
    MDS = {};
    cnt_MDS = 0;
    for i = 1:n
        driverNodes = nchoosek([1:n],i);
        for j = 1:size(driverNodes,1)
            driverNode = driverNodes(j,:);
            [MCSs,~] = MCS_fun(time_edges,driverNode,n,delta_t);
            if length(MCSs)==n
                flag_ = 1;
                cnt_MDS = cnt_MDS+1;
                MDS{cnt_MDS} = driverNode;
            end
        end
        if flag_ == 1
            break
        end
    end
end








% Improved online time-accelerated heuristic algorithm
function D_k = OTaHa_imp(time_edges,n,D_k_random,delta_t)

new_edge = time_edges;
new_edge(:,1) = new_edge(:,1)+ceil(new_edge(:,1)/n)*n;
new_edge(:,2) = new_edge(:,2)+ceil(new_edge(:,2)/n-1)*n;


% Add the edge that restricts node flow to 1
node_limit_edge = [];
for i = 1:delta_t
node_limit_edge = [node_limit_edge;(1:n)'+n*2*(i-1),(1:n)'+n*(2*i-1)];
end
new_edge = [new_edge;node_limit_edge];
new_edge = [new_edge; ((n*2*delta_t+1):n*(2*delta_t+1))',ones(n,1)*(n*(2*delta_t+1)+1)];
new_edge = new_edge + 1;
Edgetable = table(new_edge,'VariableNames',{'EndNodes'});
G = digraph(Edgetable);
delta_e = zeros(1,n);
residualCell = cell(1,n);
edgeCell = cell(1,n);
% initialize
D_k = D_k_random;
[f,~,~] = onlineMaxflow(G,[],D_k,n,delta_t);
if f ~= n
    [~,edgeList_tmp,residual_tmp] = onlineMaxflow(G,[],D_k,n,delta_t);
    index_delta_eio = setdiff(1:n,D_k);
     for i =1:length(index_delta_eio)
     source = index_delta_eio(i);
     [delta_e(index_delta_eio(i)),edgeCell{index_delta_eio(i)},...
         residualCell{index_delta_eio(i)}] = onlineMaxflow(residual_tmp,edgeList_tmp,source,n,delta_t);
     end
     [~,index_k] = findmax(delta_e,index_delta_eio);
     D_k = [D_k index_k];
     last_index = index_k;
     [f,~,~] = onlineMaxflow(G,[],D_k,n,delta_t);
     if f ~= n
         for k=2:n
            index_delta_eio = setdiff(1:n,D_k);
            flag = zeros(1,n);
            while 1
                [max_num,index_k] = findmax(delta_e,index_delta_eio);
                if flag(index_k) == 1
                    break
                end
                flag(index_k) = 1;
                [delta_,edgeCell{index_k},residualCell{index_k}] = onlineMaxflow(residualCell{last_index}, ...
                    edgeCell{last_index},[index_k],n,delta_t);
                delta_e(index_k) = delta_;
                [max_num,~] = findmax(delta_e,setdiff(index_delta_eio,index_k));
                if delta_ < max_num
                    continue
                else 
                    break
                end
            end
        last_index = index_k;
        D_k = [D_k index_k];
        [f,~,~] = onlineMaxflow(G,[],D_k,n,delta_t);
         if f == n
             break
         end
         end
    end
 end

end




function [D,C_stem,idx_stem] =  driver_selection(resMCSs,stem_flag,idx)
C_stem = {};
point = 1;
idx_stem = {};
iter_MCSs = resMCSs(:,:);
for i=1:size(iter_MCSs,2)
    for j=i+1:size(iter_MCSs,2)
        if stem_flag ==1 && length(intersect(iter_MCSs{j},iter_MCSs{i}))>=1
            MCSs_tmp =  iter_MCSs(:,:);
            tmp_j = MCSs_tmp{j};
            MCSs_tmp{j} = [];
            MCSs_tmp{j} = MCSs_tmp{i};
            MCSs_tmp{i} = [];
            MCSs_tmp{i} = tmp_j;
            C_stem{point}= MCSs_tmp;
           
            idx_tmp = idx(1,:);
            tmp = idx_tmp(i);
            idx_tmp(i) = idx_tmp(j);
            idx_tmp(j) = tmp;
            idx_stem{point} = idx_tmp;
            point = point+1;
        end
  
        C = setdiff(iter_MCSs{j},iter_MCSs{i});
        iter_MCSs{j} = [];
        iter_MCSs{j} = C;
    end
end
len = cellfun(@length,iter_MCSs);
D = [];
 for i=1:size(iter_MCSs,2)
    if ~isempty(iter_MCSs{i})
        D = [D idx(i)];
    end
 end
end


function delta_ = increment(time_edges,f_D,S_k,index_k,n,delta_t)
    [nodes_tf,~] = MCS_fun(time_edges,[S_k index_k],n,delta_t);
     delta_ = length(nodes_tf)- f_D;
end




function [max_num,index_k] = findmax(delta_e,index_delta_eio)
      max_num = -1;
      index_k = -1;
      for i=1:size(index_delta_eio,2)
      if max_num < delta_e(index_delta_eio(i))
          max_num = delta_e(index_delta_eio(i));
          index_k = index_delta_eio(i);
      end
      end
end



