function [f1 re lminf] = lines(aa)
a = ~aa;
[f c] = find(a);
lmaxf = max(f);
lminf = min(f);
aa = a(lminf:lmaxf,:);
r = size(aa,1);
for s=1:r
	if sum(aa(s,:)) == 0
		nm = aa(1:s-1,1:end);
		rm = aa(s:end,1:end);
		f1 = ~nm;
		re = ~rm;
                break;
	else
		f1 = ~aa;
		re = [];
	end
end

