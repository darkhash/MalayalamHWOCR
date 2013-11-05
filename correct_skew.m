function im = correct_skew(ims)
im = ims;
y = sum(~im,2)
dev = std(y);
angle = 0;
for i=1:20
		im = ~imrotate(~im, 1, 'bilinear');
		angle = angle + 1;
		y = sum(~im, 2);
		devn = std(y);
		if devn<dev
			im = ~imrotate(~im, -1, 'bilinear');
			angle = angle - 1;
			break;
		end
		dev = devn;
end

if angle == 0
	im = ims;
	y = sum(~im, 2);
	dev = std(y);
	for i=1:20
		im = imrotate(~im, -1);
		angle = angle - 1;
		y = sum(~im, 2);
		devn = std(y);
		if devn < dev
			im= ~imrotate(~im, +1);
			angle = angle + 1'
			break;
		end
		dev = devn;
	end
end
im = ~imrotate(~ims, angle);

		
