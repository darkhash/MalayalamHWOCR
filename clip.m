function imgn = clip(imagen)
a = ~imagen;
[f c] = find(a);
lmaxc = max(c);
lminc = min(c);
lmaxf = max(f);
lminf = min(f);
imgn = a(lminf:lmaxf,lminc:lmaxc);

