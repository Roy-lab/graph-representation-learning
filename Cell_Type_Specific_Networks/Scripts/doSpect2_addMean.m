function cids = doSpect2_addMean()

filename = {'breast_variant_human_mammary_epithelial_cells_vhmec.txt', 'cd14_primary_cells.txt', 'cd19.txt', 'cd34_primary_cells.txt', 'cd3_primary_cells.txt', ...
    'cd4_primary_cells.txt', 'cd56_primary_cells.txt', 'cd8_primary_cells.txt', 'fetal_adrenal_gland.txt', 'fetal_brain.txt', 'fetal_heart.txt', 'fetal_intestine_large.txt', ...
    'fetal_intestine_small.txt', 'fetal_kidney.txt', 'fetal_lung.txt', 'fetal_muscle.txt', 'fetal_muscle_arm.txt', 'fetal_muscle_back.txt', ...
    'fetal_muscle_leg.txt', 'fetal_muscle_lower_limb.txt', 'fetal_muscle_trunk.txt', 'fetal_ovary.txt', 'fetal_renal_cortex.txt', ...
    'fetal_renal_pelvis.txt', 'fetal_skin.txt', 'fetal_spinal_cord.txt', 'fetal_stomach.txt', 'fetal_testes.txt', 'fetal_thymus.txt', 'fibroblast.txt', ...
    'fibroblasts_fetal_skin_abdomen.txt', 'fibroblasts_fetal_skin_back.txt', 'fibroblasts_fetal_skin_biceps_left.txt', 'fibroblasts_fetal_skin_biceps_right.txt', ...
    'fibroblasts_fetal_skin_quadriceps_left.txt', 'fibroblasts_fetal_skin_quadriceps_right.txt', 'fibroblasts_fetal_skin_scalp.txt', ...
    'fibroblasts_fetal_skin_upper_back.txt', 'gastric_mucosa.txt', 'heart.txt', 'h1_bmp4_derived_mesendoderm_cultured_cells.txt','h1_bmp4_derived_trophoblast_cultured_cells.txt', ...
    'h1_cells.txt', 'h1_derived_mesenchymal_stem_cells.txt', 'h1_derived_neuronal_progenitor_cultured_cells.txt', 'h9_cells.txt', ...
    'imr90_fetal_lung_fibroblasts_cell_line.txt', 'keratinocyte.txt', 'melanocyte.txt', 'ovary.txt', 'pancreas.txt', 'placenta.txt', ...
    'psoas_muscle.txt', 'small_bowel_mucosa.txt', 'testes.txt'};

cells = {'breast_variant_human_mammary_epithelial_cells_vhmec', 'cd14_primary_cells', 'cd19', 'cd34_primary_cells', 'cd3_primary_cells', ...
    'cd4_primary_cells', 'cd56_primary_cells', 'cd8_primary_cells', 'fetal_adrenal_gland', 'fetal_brain', 'fetal_heart', 'fetal_intestine_large', ...
    'fetal_intestine_small', 'fetal_kidney', 'fetal_lung', 'fetal_muscle', 'fetal_muscle_arm', 'fetal_muscle_back', ...
    'fetal_muscle_leg', 'fetal_muscle_lower_limb', 'fetal_muscle_trunk', 'fetal_ovary', 'fetal_renal_cortex', ...
    'fetal_renal_pelvis', 'fetal_skin', 'fetal_spinal_cord', 'fetal_stomach', 'fetal_testes', 'fetal_thymus', 'fibroblast', ...
    'fibroblasts_fetal_skin_abdomen', 'fibroblasts_fetal_skin_back', 'fibroblasts_fetal_skin_biceps_left', 'fibroblasts_fetal_skin_biceps_right', ...
    'fibroblasts_fetal_skin_quadriceps_left', 'fibroblasts_fetal_skin_quadriceps_right', 'fibroblasts_fetal_skin_scalp', ...
    'fibroblasts_fetal_skin_upper_back', 'gastric_mucosa', 'heart', 'h1_bmp4_derived_mesendoderm_cultured_cells','h1_bmp4_derived_trophoblast_cultured_cells', ...
    'h1_cells', 'h1_derived_mesenchymal_stem_cells', 'h1_derived_neuronal_progenitor_cultured_cells', 'h9_cells', ...
    'imr90_fetal_lung_fibroblasts_cell_line', 'keratinocyte', 'melanocyte', 'ovary', 'pancreas', 'placenta', ...
    'psoas_muscle', 'small_bowel_mucosa', 'testes'};

for y = 1:length(filename)
    mat = importdata(filename{y});
    disp(size(mat));
    cell = cells{y};
    disp(cells{y});
    
    for k=10:10:100
        rng('shuffle');
        newmat = mat + mat';
        dmat = squareform(pdist(newmat));
        smat = exp(-(dmat).^2 ./ (2*(std2(dmat))^2));
        newmat = smat;
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
        writetable(table(cids), sprintf('/mnt/dv/wid/projects3/Roy-enhancer-promoter/Zhiwei_Work/RoadMap_Networks_Org/Results/spect_kmeans/%s/%d_cluster_spect_kmeans_dsd.txt', cell, k),'delimiter',',','writerownames',false,'writevariablenames',false)
    end
end

