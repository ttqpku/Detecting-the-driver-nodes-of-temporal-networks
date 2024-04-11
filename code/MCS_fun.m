function [nodes_tf,edgelist] = MCS_fun(edge,driverNode,n,delta_t)
if isempty(driverNode)
    nodes_tf = [];
    edgelist = [];
else
% Obtain the time layer corresponding to each node, 
% for the first column, ceil(x/n), and for the second column, that is, ceil(x/n)-1
new_edge = edge;
new_edge(:,1) = new_edge(:,1)+ceil(new_edge(:,1)/n)*n;
new_edge(:,2) = new_edge(:,2)+ceil(new_edge(:,2)/n-1)*n;


% Add the edge that restricts node flow to 1
node_limit_edge = [];
for i = 1:delta_t
node_limit_edge = [node_limit_edge;(1:n)'+n*2*(i-1),(1:n)'+n*(2*i-1)];
end
new_edge = [new_edge;node_limit_edge];

% Add the edges from the source node to the driver node
for i = 1:length(driverNode)
    new_edge = [zeros(delta_t+1,1),(driverNode(i):2*n:n*(2*delta_t+1))';new_edge];
end
new_edge = [new_edge; ((n*2*delta_t+1):n*(2*delta_t+1))',ones(n,1)*(n*(2*delta_t+1)+1)];
new_edge = new_edge+1;
Edgetable = table(new_edge,'VariableNames',{'EndNodes'});
G = digraph(Edgetable);
[~,GF] = maxflow(G,1,n*(2*delta_t+1)+2,'augmentpath');
edgelist = table2array(GF.Edges);


[nodes_tf,~ ] = find (edgelist(:,2) == n*(2*delta_t+1)+2 );
nodes_tf = edgelist(nodes_tf,1)-1-n*2*delta_t;
end
end


