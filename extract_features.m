function ftr = extract-features(I)
s = regionprops(double(~I),'centroid');
centroids = cat(1, s.Centroid);
[x y] = find(~I);
xy = [x y];
ftr = [];
rowl = 1;
rowu = 5;
for i=1:10
	clml = 1;
	clmu = 10;
	for j = 1:5
		zonexy = [];
		for k=1:size(xy, 1);
			if xy(k,1) <= rowu && xy(k,1) >= rowl && xy(k,2) <= clmu && xy(k,2) >= clml
				zonexy = [zonexy; xy(k,:)];
			end
		end
		if size(zonexy,1) == 0
			ftr = [ftr; 0];
		else
			ctd = [];
			for k=1:size(zonexy,1)
				ctd = [ctd;centroids];
			end
		end
		clml = clml + 10;
		clmu = clmu +10;
	end
	rowl = rowl + 5;
	rowu = rowu + 5;
end

