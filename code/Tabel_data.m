%==========================================================================
% Compare the running time and the number of driver nodes among these algorithms,
% i.e. the heuristic algorithm, our OTaHa and the greedy algorithm in Table 2 and 3 in the paper
%==========================================================================

clear all
%% Ants
% ants_data = readtable('../datasets/ants/6-2 data.csv');
% ants_data = table2array(ants_data);
% ants_data = sortrows(ants_data,3);
% actor = ants_data(1:end,1);
% target = ants_data(1:end,2);
% time = ants_data(1:end,3);
% start_time = min(time);
% end_time = max(time);
% cnt = 0;
% tmp = inf;
% for i=1:length(actor)c
%     if time(i)~=tmp
%         cnt = cnt+1;
%     end
%     tmp = time(i);
%     time(i) = cnt;
% end
% time_layer = max(time);
% num = max(max(actor),max(target));
% 
% 
% tmp_A = zeros(num,num,time_layer);
% for i=1:length(actor)
%     tmp_A(actor(i),target(i),time(i)) = 1;
% end
% n = num;
% for i=1:time_layer
%     tmp_ = tmp_A(:,:,i);
%     tmp_(1:n+1:n^2) = 1;
%     tmp_A(:,:,i) = tmp_;
% end
% 
% 
% delta_t = time_layer;
% ants_edge = [];
% for i=1:time_layer
%     [row,col] = find(tmp_A(:,:,i)~=0);
%     ants_edge = [ants_edge;row+(i-1)*n,col+i*n];
% end

%% Email
% emailRaw = readtable('../datasets/enron-mail/number_data1.csv');
% emaildata = table2array(emailRaw);
% emaildata = sortrows(emaildata,3);
% actor = emaildata(1:5219,1);
% target = emaildata(1:5219,2);
% time = emaildata(1:5219,3);
% start_time = min(time);
% end_time = max(time);
% cnt = 0;
% tmp = inf;
% for i=1:length(actor)
%     if time(i)~=tmp
%         cnt = cnt+1;
%     end
%     tmp = time(i);
%     time(i) = cnt;
% end
% time_layer = max(time);
% member = unique([actor;target]);
% key_email(member) = 1:length(member);
% n = length(member);
% delta_t = time_layer;
% 
% tmp_A = zeros(n,n,time_layer);
% for i=1:length(actor)
%     tmp_A(key_email(actor(i)),key_email(target(i)),time(i)) = 1;
% end
% 
%  for i=1:time_layer
%     tmp_ = tmp_A(:,:,i);
%     tmp_(1:n+1:n^2) = 1;
%     tmp_A(:,:,i) = tmp_;
% end
% 
% email_edge = [];
% for i=1:time_layer
%     [row,col] = find(tmp_A(:,:,i)~=0);
%     email_edge = [email_edge;row+(i-1)*n,col+i*n];
% end
%% Protein
% dataRaw = load('../datasets/DPPIN-main/DPPIN-Hazbun/Dynamic_PPIN.txt');
% data = dataRaw(:,1:3);
% actor = data(1:end,1);
% target = data(1:end,2);
% time = data(1:end,3);
% actor = actor + 1;
% target = target +1;
% time = time + 1;
% 
% time_layer = max(time);
% num = max(max(actor),max(target));
% 
% 
% tmp_A = zeros(num,num,time_layer);
% for i=1:length(actor)
%     tmp_A(actor(i),target(i),time(i)) = 1;
% end
% n = num;
% delta_t = time_layer;
%  for i=1:time_layer
%     tmp_ = tmp_A(:,:,i);
%     tmp_(1:n+1:n^2) = 1;
%     tmp_A(:,:,i) = tmp_;
% end
% 
% 
% protein_edge = [];
% for i=1:time_layer
%     [row,col] = find(tmp_A(:,:,i)~=0);
%     protein_edge = [protein_edge;row+(i-1)*n,col+i*n];
% end

%% Infect
 infect = readtable('../datasets/sg_infectious_contact_list/listcontacts_2009_04_28.txt');
 infect = table2array(infect(:,[1:3]));
 infect = sortrows(infect,1);
 actor = infect(:,2);
 target = infect(:,3);
 time = infect(:,1);
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

member = unique([actor;target]);
n = length(member);
delta_t = time_layer;

key_infect(member) = 1:length(member);
tmp_A = zeros(n,n,time_layer);
for i=1:length(actor)
    tmp_A(key_infect(actor(i)),key_infect(target(i)),time(i)) = 1;
end

for i=1:time_layer
    tmp_ = tmp_A(:,:,i);
    tmp_(1:n+1:n^2) = 1;
    tmp_A(:,:,i) = tmp_;
end
infect_edge = [];
for i=1:time_layer
    [row,col] = find(tmp_A(:,:,i)~=0);
    infect_edge = [infect_edge;row+(i-1)*n,col+i*n];
end

%% high school
% high_school = readtable('../datasets/students/highschool_2011.csv');
% high_school = table2array(high_school(:,[1:3]));
% high_school = sortrows(high_school,1);
% actor = high_school(:,2);
% target = high_school(:,3);
% time = high_school(:,1);
% start_time = min(time);
% end_time = max(time);
% cnt = 0;
% tmp = inf;
% for i=1:length(actor)
%     if time(i)~=tmp
%         cnt = cnt+1;
%     end
%     tmp = time(i);
%     time(i) = cnt;
% end
% time_layer = max(time);
% 
% member = unique([actor;target]);
% n = length(member);
% num = n;
% delta_t = time_layer;
% key_high(member) = 1:length(member);
% 
% A_s = zeros(n,n,time_layer);
% for i=1:length(actor)
%     A_s(key_high(target(i)),key_high(actor(i)),time(i)) = 1;
% end
% 
% tmp_A = zeros(n,n,time_layer);
% for i=1:length(actor)
%     tmp_A(key_high(actor(i)),key_high(target(i)),time(i)) = 1;
% end
% for i=1:time_layer
%     tmp_ = tmp_A(:,:,i);
%     tmp_(1:n+1:n^2) = 1;
%     tmp_A(:,:,i) = tmp_;
% end
% 
% 
% high_edge = [];
% for i=1:time_layer
%     [row,col] = find(tmp_A(:,:,i)~=0);
%     high_edge = [high_edge;row+(i-1)*n,col+i*n];
% end
 

%%

allFun = Utils;

tic
D_TAG = allFun.OTaHa(high_edge,n,delta_t);
toc

tic
D_final = allFun.Heuristic(high_edge,n,delta_t);
toc

cnt_D = size(D_final,2);
col_D_final = cellfun(@(x) size(x,2),D_final);
min_ = min(col_D_final);
cnt_min = 0;
for i = 1:cnt_D
    if length(D_final{i}) > min_
        break;
    end
    cnt_min  = cnt_min +1;
end


tic
D_greedy = allFun.Greedy(infect_edge,n,delta_t);
toc
