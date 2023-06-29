function a = calcA(c,i,cids,k)
ids = cids==k;
ids(i) = 0;
ids = find(ids);
cc = c(i,ids);
a = mean(cc);
