function p = cimp(filename)
im = imread(filename);
im = im2bw(im,graythresh(im));
im = ~bwareaopen(~im, 30);
im = correctskew(im);
re = im;
p = [];
while 1
	[fl re] = lines(re);
	img = ~fl;
	L = bwlabel(img);
	mx = max(max(L));
	[imx imy] = size(img);
	for n = 1:mx
		[r, c] = find(L==n);
		rc = [r c];
		[sx sy] = size(rc);
		n1 = ones(imx, imy);
		for i = 1:sx
			x1 = rc(i,1);
			y1 = rc(i,2);
			n1(x1, y1) = 0;
		end
		n1 = ~clip(n1);
		img_r = imresize(n1, [50,50]);
		img_r = ~bwmorph(~img_r,'thin',Inf);
		ftr = feature_exth2(img_r);
		p = [p ftr];
	end
	if isempty(re)
		break;
	end
end

