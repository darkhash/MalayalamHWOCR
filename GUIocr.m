%contains GUI callback functions

function varargout = GUIocr(varargin)
gui_skelton = 1;
gui_State = struct('gui_Name',mfilename, ...
		   'gui_Singleton', gui_Singleton, ...
		   'gui_OpeningFcn', @GUIocr_OpeningFcn, ...
		   'gui_OutputFcn', @GUIocr_OutputFcn, ...
		   'gui_LayoutFcn', [] , ...
		   'gui_Callback', []);
if nargin && ischar(varargin{1})
	gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
	[varargout{1:nargout}] = gui_mainfcn(gui_State,varargin{:});
else
  	gui_mainfcn(gui_State, varargin{:});
end

%executes just before GUI is made visible
function GUIocr_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;
guidata(hObject, handles);
clc; clear all;
imshow('preview.bmp');
	
function varargout = GUIocr_OutputFcn(hObject, eventdata, handles)
varargout{1} = handles.output;


function open_Callback(hObject, eventdata, handles)
[filename, pathname] = uigetfile({'*.bmp;*.jpg;*.gif'}, 'Open image file');
if isequal(filename, 0)
	return
end
global im
global inputfile
inputfile = [pathname, filename];
try
	im = imread([pathname, filename]);
catch ME
	errordlg('Please select image files only', 'Error');
	return;
end
imshow(im);
function recognise_Callback(hObject, eventdata, handles)
global im 
if size(im) == 0
	errordlg('Please load an image file', 'Error');
	return;
end
[filename, pathname] = uiputfile({'*.doc;*.rtf','Document files'} ...
		,'Save as', 'newfile.doc');
if isequal(filename,0)
	return
end
[path name ext] = fileparts(filename);
if strcmp(ext, '')
	filename = strcat(name, '.doc');
end

load net.matl
net = network(net);
load karthika.mat;

if ~islogical(im)
	im = rgb2gray(im);
	im = medfilt2(im);
	im = im2bw(im,graythresh(im));
end

im = ~bwareaopen(~im,30);
im = correct_skew(im);
re = im
word = [];
fid = fopen([pathname, filename, 'wt']);
str1 = ['{\rtf1\ansi\ansicpg1252\deff0\deflang1033{\fonttb{\f0\fdecor\'...
'fprq2\fcarset0 MLW-TTKarthika;}}'];

str2 = ['{\*\generator Msftedit 5.41.15.1515;}\viewkind4\uc1\pard\f0\fs24'];
fprintf(fid, str1, str2);

while 1
	[f1 re rmin] = lines(re)
	rmin = floor(rmin/50);
	if rmin > 0
		for i=1:rmin
			fprintf(fid,'%s\n','\par');
		end
	end
	img = ~f1;
	L = bwlabel(img);
	mx = max(max(L));
	[imx imy] = size(img);
	lc = 0;
	letterp =0;
	for n=1:mx
		[r,c] find(L==n);
		rc = [r c];
		[sx sy] = size(rc);
		n1 = ones(imx, imy);
		for i = 1:sx
			x1 = rc(i,1);
			y1 = rc(i,2);
			n1(x1,y1) = 0;
		end
		pc = min(rc(:,2));
		x = pc - lc;
		x = floor(x/20);
		if x>0 
			for 1= 1:x
				word = [word ' '];
			end
		end
		lc = max(rc(:,2));
		n1 = ~clip(n1);
		img_r = imresize(n1,[50,50]);
		img_r = ~bwmorph(~img_r,'thin',Inf);
		ftr = extract_features(img_r);
		x = sim(net,ftr);
		y = compet(x);
		letter = find(y);
		if ((letter == 60 || letter ==61) && (letterp==60 || letterp==61) )
			word = word(1:end-1);
			letter = 61;
		elseif letter == 61
			letter = 60;
		end
		letterp = letter;
		letter = larthika(letter);
		letter = char(letter);
		word = [word letter];
	end
	fprintf(fid, '%s%s\n', word, '\par');
	word =[];
	if isempty(re)
		break;
	end
end
fprintf(fid,'%s','}');
fclose(fid);
try
	winopen([pathname, filename]);

catch ME
	return;
end

function help_CallBack(hObject, eventdata, handles)
try
	winopen('help.txt');
catch ME
	return;
end

function view_Callback(hObject, eventdata, handles)
global inputfile;
try
	winopen(inputfile);
catch ME
	return;
end


