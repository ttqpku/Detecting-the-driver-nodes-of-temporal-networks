function [EBC,BC]=edge_betweenness_num(G)


%   Edge betweenness centrality is the fraction of all shortest paths in 
%   the network that contain a given edge. Edges with high values of 
%   betweenness centrality participate in a large number of shortest paths.
%
%   Input:       a directed graph G
%
%   Output:     EBC,    the first column: the source node of an edge
%                       the second column : the target node of an edge
%                       the third column: the number of shortest paths in the graph that contain the edge
%               BC,     the number of shortest paths in the graph that pass through the node
%
%   Reference: Brandes (2001) J Math Sociol 25:163-177.

%   Based on the function "edge_betweenness" written by Mika Rubinov, UNSW, 2007-2010




Edge_array = table2array(G.Edges);
EBC=zeros(size(Edge_array,1),1);                   %edge betweenness

n=numnodes(G);
BC=zeros(n,1);                  %vertex betweenness

for u=1:n
    D=zeros(1,n); D(u)=0;      	%distance from u
    NP=zeros(1,n); NP(u)=1;     %number of paths from u
    % P=cell(n,1);                 %predecessors
    Q=zeros(1,n); q=n;          %order of non-increasing distance

    Gu=G;
    V=u;
    while V
      
%         Gu(:,V)=0;     
      
        %remove remaining in-edges
        % if there exist some selfloops, we should remove the remaining
        % in-edges,but here in time unfold graph, we don't need to remove
%         for i = 1:length(V)
%         Gu = Gu.rmedge(Gu.inedges(V(i)));  
%         end
        for i = 1:length(V)
            
            Q(q)=V(i); q=q-1;
%             W=find(Gu(v,:));               
            %neighbours of v
            W = successors(Gu,V(i));
            if ~isempty(W)
            for j = 1:length(W)
                if ~D(W(j))
                    D(W(j))= D(V(i)) +1;
                    NP(W(j))=NP(V(i));            %NP(u->w) = NP of new path
                    % P(W(j),V(i))=1;                %v is a predecessor
                elseif D(W(j))== D(V(i))+1
                    NP(W(j))=NP(W(j))+NP(V(i));      %NP(u->w) sum of old and new
                    %P(W(j),V(i))=1;              
                %v is a predecessor
            
                else
                    continue;
                end
            end
            end
        end
%         V=find(any(Gu(V,:),1));
          V_tmp = [];
          for i = 1:length(V)
          V_tmp = [V_tmp;successors(Gu,V(i))];
          end
          V = unique(V_tmp);
    end
%     if ~all(D)                              %if some vertices unreachable,
%         Q(1:q)=find(~D);                    %...these are first-in-line
%     end

    DP=zeros(n,1);                          %dependency
    for w=Q(q+1:n-1)
        BC(w)=BC(w)+DP(w);
        P = predecessors(G,w);
        P = intersect(P,Q(q+1:n));
        for k = 1:length(P)
            DPvw= DP(w)*NP(P(k))/NP(w)+NP(P(k));
            DP(P(k))=DP(P(k))+DPvw;
            [~,ind] = ismember([P(k),w],Edge_array,'rows');
            EBC(ind) = EBC(ind) +DPvw;
        end
    end
end
EBC = [Edge_array EBC];
end