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
