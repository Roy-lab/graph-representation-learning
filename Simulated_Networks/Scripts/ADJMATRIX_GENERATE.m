function ADJMATRIX_GENERATE()
    edgelists = {'/mnt/dv/wid/projects3/Roy-enhancer-promoter/Zhiwei_Work/Simulated_Networks//Data//t1_2_t2_1//k_10//network.dat',...
        '/mnt/dv/wid/projects3/Roy-enhancer-promoter/Zhiwei_Work/Simulated_Networks//Data//t1_2_t2_1//k_25//network.dat',...
        '/mnt/dv/wid/projects3/Roy-enhancer-promoter/Zhiwei_Work/Simulated_Networks//Data//t1_2_t2_1//k_50//network.dat',...
        '/mnt/dv/wid/projects3/Roy-enhancer-promoter/Zhiwei_Work/Simulated_Networks//Data//t1_2_t2_1//k_100//network.dat'};
    filename = {'/mnt/dv/wid/projects3/Roy-enhancer-promoter/Zhiwei_Work/Simulated_Networks//Data//t1_2_t2_1//k_10//network.txt',...
        '/mnt/dv/wid/projects3/Roy-enhancer-promoter/Zhiwei_Work/Simulated_Networks//Data//t1_2_t2_1//k_25//network.txt',...
        '/mnt/dv/wid/projects3/Roy-enhancer-promoter/Zhiwei_Work/Simulated_Networks//Data//t1_2_t2_1//k_50//network.txt',...
        '/mnt/dv/wid/projects3/Roy-enhancer-promoter/Zhiwei_Work/Simulated_Networks//Data//t1_2_t2_1//k_100//network.txt'};
    for i = 1:4
        edgelist = importdata(edgelists{i});
        edgelist = unique(edgelist, 'rows');
        sz = max(max(edgelist(:, 1:2)));
        A = sparse(edgelist(:,1), edgelist(:,2), edgelist(:,3), sz, sz);
        adj = full(A);
        dlmwrite(filename{i},adj, 'delimiter','\t');
    end
end
