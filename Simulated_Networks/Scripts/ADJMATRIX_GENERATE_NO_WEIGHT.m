function ADJMATRIX_GENERATE_NO_WEIGHT()
    edgelists = {'/mnt/dv/wid/projects3/Roy-enhancer-promoter/Zhiwei_Work/Simulated_Networks//Data//t1_2_t2_1//k_10//network_no_weight.dat',...
        '/mnt/dv/wid/projects3/Roy-enhancer-promoter/Zhiwei_Work/Simulated_Networks//Data//t1_2_t2_1//k_25//network_no_weight.dat',...
        '/mnt/dv/wid/projects3/Roy-enhancer-promoter/Zhiwei_Work/Simulated_Networks//Data//t1_2_t2_1//k_50//network_no_weight.dat',...
        '/mnt/dv/wid/projects3/Roy-enhancer-promoter/Zhiwei_Work/Simulated_Networks//Data//t1_2_t2_1//k_100//network_no_weight.dat'};
    filename = {'/mnt/dv/wid/projects3/Roy-enhancer-promoter/Zhiwei_Work/Simulated_Networks//Data//t1_2_t2_1//k_10//network_no_weight.txt',...
        '/mnt/dv/wid/projects3/Roy-enhancer-promoter/Zhiwei_Work/Simulated_Networks//Data//t1_2_t2_1//k_25//network_no_weight.txt',...
        '/mnt/dv/wid/projects3/Roy-enhancer-promoter/Zhiwei_Work/Simulated_Networks//Data//t1_2_t2_1//k_50//network_no_weight.txt',...
        '/mnt/dv/wid/projects3/Roy-enhancer-promoter/Zhiwei_Work/Simulated_Networks//Data//t1_2_t2_1//k_100//network_no_weight.txt'};
    filename_Nodenames = {'/mnt/dv/wid/projects3/Roy-enhancer-promoter/Zhiwei_Work/Simulated_Networks//Data//t1_2_t2_1//k_10//network_no_weight_Nodenames.txt',...
        '/mnt/dv/wid/projects3/Roy-enhancer-promoter/Zhiwei_Work/Simulated_Networks//Data//t1_2_t2_1//k_25//network_no_weight_Nodenames.txt',...
        '/mnt/dv/wid/projects3/Roy-enhancer-promoter/Zhiwei_Work/Simulated_Networks//Data//t1_2_t2_1//k_50//network_no_weight_Nodenames.txt',...
        '/mnt/dv/wid/projects3/Roy-enhancer-promoter/Zhiwei_Work/Simulated_Networks//Data//t1_2_t2_1//k_100//network_no_weight_Nodenames.txt'};
    
    for i = 1:4
        edgelist = importdata(edgelists{i});
        edgelist = unique(edgelist, 'rows');
        sz = max(max(edgelist(:, 1:2)));
        node_num = [1:1:sz];
        node_num = node_num';
        A = sparse(edgelist(:,1), edgelist(:,2), 1, sz, sz);
        adj = full(A);
        idx2keep_rows = sum(abs(adj),2)>0;
        idx2keep_cols = sum(abs(adj),1)>0;
        disp(sum(idx2keep_rows ~= idx2keep_cols'));
        node_num = node_num(idx2keep_rows, :);
        adj = adj(idx2keep_rows, idx2keep_cols);
        dlmwrite(filename_Nodenames{i},node_num);
        dlmwrite(filename{i},adj, 'delimiter','\t');
    end
end