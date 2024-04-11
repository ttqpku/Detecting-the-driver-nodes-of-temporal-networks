function [f,edgeList,residualGraph] = onlineMaxflow(G,edgeList,driverNode,n,delta_t)
% Online Maximum flow in a directed graph
% Corresponds to Algorithm 2 in the paper
residualGraph = G;
if ~isempty(edgeList)
    residualGraph = rmedge(residualGraph,edgeList(:,1)',edgeList(:,2)');
    residualGraph = addedge(residualGraph,edgeList(:,2)',edgeList(:,1)');
end
for i = 1:length(driverNode)
    residualGraph = addedge(residualGraph,ones(1,delta_t+1), ...
        (driverNode(i):2*n:n*(2*delta_t+1))+1);
   
end
    [f,GF] = maxflow(residualGraph,1,n*(2*delta_t+1)+2);
    edgeList = table2array(GF.Edges);
end