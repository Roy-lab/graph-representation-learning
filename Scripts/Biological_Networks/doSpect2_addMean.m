function cids = doSpect2_addMean()

filename = {'h1_bmp4_derived_mesendoderm_cultured_cells.txt', 'h1_bmp4_derived_trophoblast_cultured_cells.txt', 'h1_cells.txt', ...
    'h1_derived_mesenchymal_stem_cells.txt', 'h1_derived_neuronal_progenitor_cultured_cells.txt', 'h9_cells.txt', 'imr90_fetal_lung_fibroblasts_cell_line.txt', 'keratinocyte.txt', ...
    'melanocyte.txt', 'ovary.txt', 'pancreas.txt', 'placenta.txt', 'psoas_muscle.txt', ...
    'small_bowel_mucosa.txt', 'testes.txt'};

cells = {'h1_bmp4_derived_mesendoderm_cultured_cells', 'h1_bmp4_derived_trophoblast_cultured_cells', 'h1_cells', ...
    'h1_derived_mesenchymal_stem_cells', 'h1_derived_neuronal_progenitor_cultured_cells', 'h9_cells', 'imr90_fetal_lung_fibroblasts_cell_line', 'keratinocyte', ...
    'melanocyte', 'ovary', 'pancreas', 'placenta', 'psoas_muscle', ...
    'small_bowel_mucosa', 'testes'};

for y = 1:length(filename)
    mat = importdata(filename{y});
    disp(size(mat));
    cell = cells{y};
    disp(cells{y});
    
    for k=10:10:100
        rng('shuffle');
        newmat = mat + mat';
        for i=1:length(mat)
            newmat(i,i)=0;
        end
        dd=sum(newmat);
        dd=sum(newmat)+mean(dd);
        dd(dd==0)=1;
        D = diag(dd);
        L = eye(size(D,1)) - (D^-.5)*newmat*(D^-.5);
        [V,D] = eig(L);
        %[~,idx] = sort(abs(diag(D)),'descend');
        %dd = diag(D);
        %dd = sort(dd);
        %dd(1:10)
        [~,idx] = sort(abs(diag(D)));

        TEV = V(:,idx(1:k));
        EV  = TEV;
        for j=1:size(TEV,1)
            EV(j,:) = TEV(j,:)/norm(TEV(j,:));
        end
        try
            cidx = kmeans(EV,k,'replicates',100);
            cidx = cidx';
            figure;
            hold on
            tmat = [];
            llen = [];
            for m=min(cidx):max(cidx)
                tmat = [tmat;EV(cidx==m,:)];
                llen = [llen;size(tmat,1)];
            end
            imagesc(tmat);
            colormap(redgreencmap)
            colorbar;
            for m=1:size(llen,1)-1
                plot([0.5, k+.5],[llen(m),llen(m)],'y','linewidth',3);
            end
            xlim([0.5, k+.5])
            ylim([0 size(tmat,1)])
        catch err
            cidx = zeros(1,size(EV,1));
            disp(err)
            disp('ERROR in kmeans!')
        end
        cids=cidx;
        writetable(table(cids), sprintf('/mnt/dv/wid/projects3/Roy-enhancer-promoter/Zhiwei_Work/RoadMap_Networks/Results/spect_kmeans/%s/%d_cluster_spect_kmeans.txt', cell, k),'delimiter',',','writerownames',false,'writevariablenames',false)
    end
end

