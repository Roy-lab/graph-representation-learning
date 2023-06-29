function makeFig1()

[a1,b1] = makeAnova();
[a2,b2] = makeBar();

a=[a2,a1];
b=[b2,b1];
c=mean(b,2);
d=tiedrank(c);
ll = {'Hierarchical (Euclidean)','Hierarchical (Pearson)','Hierarchical (Spearman)','Hierarchical (Contact cout)','Hierarchical (log2 Contact count)','Kmeans (Euclidean)','Kmeans (Pearson)','Kmeans (Spearman)','Kmeans (Contact counts)','Kmeans (log2 Contact counts)','Spectral (Euclidean)','Spectral (Pearson>0)','Spectral (Spearman>0)','Spectral (Contact count)','Spectral (log2 Contact count)'};

for i=1:size(a,1)
	fprintf('%s',ll{i});
	for j=1:size(a,2)
		fprintf(' | %.3f (%.1f) ',a(i,j),b(i,j));
	end
	fprintf(' | %.1f | %.1f\n|-\n',c(i),d(i));
end

function [a,b] = makeBar()

mnames = {'hier_euc','hier_crr','hier_spear','hier_cnt','hier_lcnt','kmeans_euc','kmeans_crr','kmeans_spear','kmeans_cnt','kmeans_lcnt','spec_euc','spec_crr','spec_spearman','spec_cnt','spec_lcnt'};
ll = {'Hierarchical (Euclidean)','Hierarchical (Pearson)','Hierarchical (Spearman)','Hierarchical (Contact cout)','Hierarchical (log2 Contact count)','Kmeans (Euclidean)','Kmeans (Pearson)','Kmeans (Spearman)','Kmeans (Contact counts)','Kmeans (log2 Contact counts)','Spectral (Euclidean)','Spectral (Pearson>0)','Spectral (Spearman>0)','Spectral (Contact count)','Spectral (log2 Contact count)'};

features = importdata('../../../new_features/features/hESC_1M.txt');
%features = importdata('../../ferhat_march_30/features/hesc_26.txt');
fnames   = features.textdata(1,2:end);
features = features.data;
features = zscore(features);

load('../../../new_run_diff_res/data/mats/1M/hESC.mat');
c=1-corr(mat,'type','spearman');

enr = zeros(length(mnames),1);
dds = zeros(length(mnames),1);
sis = zeros(length(mnames),1);
dis = zeros(length(mnames),1);
k=10;
for i=1:length(mnames)
	cids = importdata(sprintf('../../../new_run_diff_res/clusters/1M/%s/hESC/clust.%d.txt',mnames{i},k));
	cids = cids.data;

	dds(i) = getDelta(log2(1+mat),cids);
	dis(i) = getDBI(c,cids);
	sis(i) = getSil(c,cids);
	enr(i) = countEnr(features,cids);
end
f=figure;bar(dds,'facecolor',[0.7451,0.7451,1.0000])
setXtick(ll)
set(gca,'position',[.1 .4 .8 .5])
title('Delta');
print(f,'delta.eps','-depsc');
f=figure;bar(dis,'facecolor',[0.7451,0.7451,1.0000])
ylim([0.8 .95])
setXtick(ll)
set(gca,'position',[.1 .4 .8 .5])
title('DBI');
print(f,'dbi.eps','-depsc');
f=figure;bar(sis,'facecolor',[0.7451,0.7451,1.0000])
setXtick(ll)
set(gca,'position',[.1 .4 .8 .5])
title('Silhouette')
print(f,'sil.eps','-depsc');
f=figure;bar(enr,'facecolor',[0.7451,0.7451,1.0000])
ylim([5 11])
setXtick(ll)
set(gca,'position',[.1 .4 .8 .5])
title('#Enriched')
print(f,'enr.eps','-depsc');
mnames'
a=[dds,dis,sis,enr];
b=[tiedrank(3-dds),tiedrank(dis),tiedrank(1-sis),tiedrank(10-enr)];

function xcount = countEnr(feats,cids)
xcount = 0;
ycount = 0;
for i=1:max(cids)
	ff = feats(cids==i,:);
	xxcount = 0;
	for j=1:size(feats,2)
		[~,p] = kstest2(feats(cids==i,j),feats(cids~=i,j),0.001,'smaller');
		ycount = ycount-log10(p);
		if p<=0.01
			xxcount = xxcount+1;
		end
	end
	if xxcount>0
		xcount = xcount+1;
	end
end


function d = getDelta(c,cids)

d=[];
for k=1:max(cids)
	id1 = cids==k;
	id2 = cids~=k;
	cin = c(id1,id1);
	cout = c(id1,id2);
	l1 = sum(id1);
	l2 = sum(id2);
	d1 = (sum(sum(cin))-sum(diag(cin)))/2;
	d1 = d1/(l1*(l1-1)/2);
	d2 = sum(sum(cout));
	d2 = d2/(l1*l2);

	d = [d;(d1-d2)];
end
d = mean(d(~isnan(d)));
%d = d/max(cids);

function db = getDBI(c,cids)
mk   = max(cids);
dis  = zeros(mk,1);
dijs = zeros(mk);

for i=1:mk
	ids = cids==i;
	cc = c(ids,ids);
	l = sum(ids)*(sum(ids)-1);
	s = (sum(sum(cc))-sum(diag(cc)))/2;
	d = s/l;
	if isnan(d)
		d = -inf;
	end
	dis(i) = d;
end
for i=1:mk
	for j=i+1:mk
		id1 = cids==i;
		id2 = cids==j;
		cc = c(id1,id2);
		l = sum(id1)*sum(id2);
		s = sum(sum(cc));
		dijs(i,j) = s/l;
		dijs(j,i) = s/l;
	end
end

D = zeros(mk);

for i=1:mk
	D(i,i) = -inf;
	for j=i+1:mk
		dif=(dis(i)+dis(j))/dijs(i,j);
		D(i,j) = dif;
		D(j,i) = dif;
	end
end

m = max(D,[],2);
%db = sum(m)/mk;
db = mean(m(~isinf(m)));


function ms = getSil(c,cids)
mk = max(cids);
si = zeros(size(c,1),1);
for i=1:size(c,1)
	a = 0;
	b = 0;
	bv = zeros(mk,1);
	for k=1:mk
		bv(k) = calcA(c,i,cids,k);
	end
	k = cids(i);
	a = bv(k);
	bv(k) = [];
	b = min(bv);
	si(i) = (b-a)/max(a,b);
end
ms = [];
ss = [];
for k=1:mk
	ss = [ss;sort(si(cids==k))];
	ms = [ms;mean(si(cids==k))];
end
%[mean(ms),mean(si)]
ms = mean(ms(~isnan(ms)));

function a = calcA(c,i,cids,k)
ids = cids==k;
ids(i) = 0;
ids = find(ids);
cc = c(i,ids);
a = mean(cc);



function [a,b] = makeAnova()

%mnames = {'hier_euc','hier_crr','hier_spear','kmeans_euc','kmeans_crr','kmeans_spear','kmeans_cnt2','spec_spearman','spec_cnt','spec_lcnt','spec_euc'};
%ll = {'Hierarchical (Euclidean)','Hierarchical (Pearson)','Hierarchical (Spearman)','Kmeans (Euclidean)','Kmeans (Pearson)','Kmeans (Spearman)','Kmeans (contact counts)','Spectral (Spearman>0)','Spectral (Contact count)','Spectral (log2 Contact count)','Spectral (Euclidean)'};
mnames = {'hier_euc','hier_crr','hier_spear','hier_cnt','hier_lcnt','kmeans_euc','kmeans_crr','kmeans_spear','kmeans_cnt','kmeans_lcnt','spec_euc','spec_crr','spec_spearman','spec_cnt','spec_lcnt'};
ll = {'Hierarchical (Euclidean)','Hierarchical (Pearson)','Hierarchical (Spearman)','Hierarchical (Contact cout)','Hierarchical (log2 Contact count)','Kmeans (Euclidean)','Kmeans (Pearson)','Kmeans (Spearman)','Kmeans (Contact counts)','Kmeans (log2 Contact counts)','Spectral (Euclidean)','Spectral (Pearson>0)','Spectral (Spearman>0)','Spectral (Contact count)','Spectral (log2 Contact count)'};
features = importdata('../../../new_features/features/hESC_1M.txt');
fnames   = features.textdata(1,2:end);
features = features.data;

v1=1:-0.01:0;
cm=[ones(size(v1')),v1',v1'];

for k=10%[2,5,10,15]

	anovanal = zeros(length(mnames),size(features,2));

	for i=1:length(mnames)
		cids = importdata(sprintf('../../../new_run_diff_res/clusters/1M/%s/hESC/clust.%d.txt',mnames{i},k));
		cids = cids.data;
		for j=1:size(features,2)
			anovanal(i,j)=anova1(features(:,j),cids,'off');
		end
	end

	f=figure('paperunit','inches','paperposition',[0 0 8 2.5 ]);
	aa=-1*log(anovanal);
	rvals = zeros(length(mnames),1);
	for j=1:size(aa,1)
		aaa=aa(j,:);
		rvals(j) = mean(aaa(~isinf(aaa)));
	end
	[~,ids] = sort(rvals,'descend');
	for j=1:size(aa,1)
		jj = ids(j);
		aaa=aa(jj,:);
		fprintf('%s\t%d\t%f\t%d\n',ll{jj},j,mean(aaa(~isinf(aaa))),sum(isinf(aaa)));
	end
	imagesc(-1*log10(anovanal));
	set(gca,'ytick',[1:length(mnames)]);
	%set(gca,'yticklabel',mnames);
	set(gca,'yticklabel',ll);
	set(gca,'xtick',[1:size(features,2)]);
	set(gca,'xticklabel',fnames);
	setXtick(fnames)
	set(gca,'position',[.3 .3 .7 .6]);
	colormap(cm)
	colorbar

	title(sprintf('neg log Anova P, k=%d',k));
	print(f,sprintf('k_%d.eps',k),'-depsc');
	print(f,sprintf('k_%d.png',k),'-dpng');
	%print(f,sprintf('../calculate_cluster_fit/new_fig_1/k_%d.png',k),'-dpng');
	%print(f,sprintf('../calculate_cluster_fit/new_fig_1/k_%d.eps',k),'-depsc');
	lanova=-log10(anovanal);
	lanova(isinf(lanova))=324;
	a=mean(lanova,2);
	b=tiedrank(sum(log10(anovanal),2));
	f=figure;bar(a,'facecolor',[0.7451,0.7451,1.0000])
	setXtick(ll)
	set(gca,'position',[.1 .4 .8 .5])
	title('ANOVA')
	print(f,'anova_bar.eps','-depsc');
end

function setXtick(names)

set(gca,'xtick',1:length(names),'xticklabel','');
h=get(gca,'xlabel');
p=get(h,'position');
y=p(2);
for i=1:length(names)
	t=text(i,y,names{i},'verticalAlignment','middle');
	set(t,'Rotation',90,'HorizontalAlignment','right')
end
