function create_input_table()
  
  methods = {'DeepWalk_64d', 'graphsage_64d', 'vgae_256d', 'node2vec_128d_p0.5_q1', 'spect'};
  methods_abbr = {'DeepWalk', 'Graphsage', 'VGAE', 'node2vec', 'spect'};
  folders = {'k5', 'k10'};
  
  for i = 1:length(methods)
    method = methods{i};
    method_abbr = methods_abbr{i};
    for j = 1:length(folders)
      folder = folders{j};
      count_mat = readtable(sprintf("/mnt/dv/wid/projects3/Roy-enhancer-promoter/Zhiwei_Work/GO_Enrichment/Undiffused_Networks/Results/Multi_Cell_Count_20percent/%s_q1e-5.txt", method), 'ReadRowNames', 1);
      cluster_cell = readtable(sprintf('/mnt/dv/wid/projects3/Roy-enhancer-promoter/Zhiwei_Work/GO_Enrichment/Undiffused_Networks/Results/Multi_Cell_Count_20percent_NMF/Paper_Specific/%s/%s_cellclust_maxdim.txt', folder, method_abbr), 'Delimiter', '\t', 'ReadVariableNames', 0);
      cluster_term = readtable(sprintf('/mnt/dv/wid/projects3/Roy-enhancer-promoter/Zhiwei_Work/GO_Enrichment/Undiffused_Networks/Results/Multi_Cell_Count_20percent_NMF/Paper_Specific/%s/%s_termclust_maxdim.txt', folder, method_abbr), 'Delimiter', '\t', 'ReadVariableNames', 0);
      cluster_term.Properties.VariableNames = {'Term', 'Assignments'};
      count_mat_new = [count_mat cluster_term(:,2)];
      disp(size(count_mat_new));
      load (sprintf("/mnt/dv/wid/projects3/Roy-enhancer-promoter/Zhiwei_Work/GO_Enrichment/Undiffused_Networks/Results/Multi_Cell_Count_20percent_NMF/Paper_Specific/%s/%s_outs.mat", folder, method_abbr))
      U = cell2mat(outs(1));
      V = cell2mat(outs(2));
      max_val = max(V', [], 2);
      max_val = array2table(max_val);
      count_mat_new = [count_mat_new max_val];
      
      count_mat_new = sortrows(count_mat_new, [size(count_mat_new,2)-1, -size(count_mat_new,2)]);
      count_mat_new.Assignments = int8(count_mat_new.Assignments);
      count_mat_new = groupfilter(count_mat_new, 'Assignments', @(x) ismember(x, maxk(x,10)), 'max_val');
      writetable(count_mat_new(:,size(count_mat_new,2)-1), sprintf('/mnt/dv/wid/projects3/Roy-enhancer-promoter/Zhiwei_Work/GO_Enrichment/Undiffused_Networks/Results/Multi_Cell_Count_20percent_NMF/Paper_Specific/%s/%s_term_clust.txt', folder, method_abbr), 'Delimiter', '\t', 'WriteRowNames', 1, 'WriteVariableNames', 0);
      count_mat_new = rows2vars(count_mat_new);
      count_mat_new = count_mat_new(1:size(count_mat_new,1)-2, :);
      disp(size(count_mat_new));
      
      cluster_cell.Properties.VariableNames = {'Cell', 'Assignments'};
      count_mat_new = [count_mat_new cluster_cell(:,2)];
      max_val = max(U, [], 2);
      max_val = array2table(max_val);
      count_mat_new = [count_mat_new max_val];
      count_mat_new = sortrows(count_mat_new, [size(count_mat_new,2)-1, -size(count_mat_new,2)]);
      writetable(count_mat_new(:,[1 size(count_mat_new,2)-1]), sprintf('/mnt/dv/wid/projects3/Roy-enhancer-promoter/Zhiwei_Work/GO_Enrichment/Undiffused_Networks/Results/Multi_Cell_Count_20percent_NMF/Paper_Specific/%s/%s_cell_clust.txt', folder, method_abbr), 'Delimiter', '\t', 'WriteRowNames', 0, 'WriteVariableNames', 0);
      count_mat_new = count_mat_new(:,[1:size(count_mat_new,2)-2]);
      
      count_mat_new = rows2vars(count_mat_new);
      writetable(count_mat_new, sprintf('/mnt/dv/wid/projects3/Roy-enhancer-promoter/Zhiwei_Work/GO_Enrichment/Undiffused_Networks/Results/Multi_Cell_Count_20percent_NMF/Paper_Specific/%s/%s_plot_mat.txt', folder, method_abbr), 'Delimiter', '\t','WriteVariableNames', 0);
    end
  end
end