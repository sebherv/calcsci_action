
clear; close all;

global SV_REFLECT_TOP;
global SV_REFLECT_BOTTOM;
global SV_REFLECT_LEFT;
global SV_REFLECT_RIGHT;

global SV_DEBIT_U;
global SV_DEBIT_V;

global SV_FN_U0T;
global SV_FN_PERFORM;

SV_REFLECT_TOP = true;
SV_REFLECT_BOTTOM = true;
SV_REFLECT_LEFT = true;
SV_REFLECT_RIGHT = true;

 SV_DEBIT_U = 0;
 SV_DEBIT_V = 0;


 SV_FN_PERFORM = false;

% Discretisation

N = 40;
N2 = N*N; % nombre de mailles "physiques"

a = 0; % bord gauche du domaine
b = 10; % bord droit du domaine
c = b; % profondeur

%tn = zeros(0,1); % stocke les valeurs de tn (pas variable)
t = 0;
alpha = 0.9;

% Initialisation de u_n[i]
hn = ones(1,N2);

hn(N/4) = 20;
hn(N*3/4) = 20;

hun = zeros(1,N2);
hvn = zeros(1,N2);

u = [hn;hun;hvn];

deltax = b-a/N;

t = 0;

step = 1;


% Configurer le film
numberOfFrames = 600;
hFigure = figure;
% Set up the movie structure.
% Preallocate movie, which will be an array of structures.
% First get a cell array with all the frames.
allTheFrames = cell(numberOfFrames,1);
vidHeight = 1024;
vidWidth = 1024;
allTheFrames(:) = {zeros(vidHeight, vidWidth, 3, 'uint8')};
% Next get a cell array with all the colormaps.
allTheColorMaps = cell(numberOfFrames,1);
allTheColorMaps(:) = {zeros(256, 3)};
% Now combine these to make the array of structures.
myMovie = struct('cdata', allTheFrames, 'colormap', allTheColorMaps);
% Create a VideoWriter object to write the video out to a new, different file.
% writerObj = VideoWriter('problem_3.avi');
% open(writerObj);
% Need to change from the default renderer to zbuffer to get it to work right.
% openGL doesn't work and Painters is way too slow.
set(gcf, 'renderer', 'zbuffer');

frameIndex = 0;


for n = 1 : 600
    
    n
    frameIndex = frameIndex + 1;
    
u = finiteVolume2d(u,step, t, alpha, N, N, deltax);
%pause(0.1)
cla reset;

t = t + step

x = linspace(a,b,N);
y = linspace(a,b,N);
[X,Y] = meshgrid(x,y);

Z = [];
for i = 1:N
    Z = [Z; u(1,(i-1)*N+1:i*N)];
end
h = surf(X,Y,Z);
zlim([0 2]);
%view(135+n*0.5,30)
shading interp

hold on

drawnow;
	thisFrame = getframe(gca);
	% Write this frame out to a new video file.
%  	writeVideo(writerObj, thisFrame);
	myMovie(frameIndex) = thisFrame;

end



%==============================================================================================
% See if they want to replay the movie.
message = sprintf('Done creating movie\nDo you want to play it?');
button = questdlg(message, 'Continue?', 'Yes', 'No', 'Yes');
drawnow;	% Refresh screen to get rid of dialog box remnants.
close(hFigure);
if strcmpi(button, 'Yes')
	hFigure = figure;
	% Enlarge figure to full screen.
	% set(gcf, 'Units', 'Normalized', 'Outerposition', [0, 0, 1, 1]);
	title('Playing the movie we created', 'FontSize', 15);
	% Get rid of extra set of axes that it makes for some reason.
	axis off;
	% Play the movie.
	movie(myMovie);
	close(hFigure);
end

%==============================================================================================
% See if they want to save the movie to an avi file on disk.
promptMessage = sprintf('Do you want to save this movie to disk?');
titleBarCaption = 'Continue?';
button = questdlg(promptMessage, titleBarCaption, 'Yes', 'No', 'Yes');
if strcmpi(button, 'yes')
	% Get the name of the file that the user wants to save.
	% Note, if you're saving an image you can use imsave() instead of uiputfile().
	startingFolder = pwd;
	defaultFileName = {'*.avi';'*.mp4';'*.mj2'}; %fullfile(startingFolder, '*.avi');
	[baseFileName, folder] = uiputfile(defaultFileName, 'Specify a file');
	if baseFileName == 0
		% User clicked the Cancel button.
		return;
	end
	fullFileName = fullfile(folder, baseFileName);
	% Create a video writer object with that file name.
	% The VideoWriter object must have a profile input argument, otherwise you get jpg.
	% Determine the format the user specified:
	[folder, baseFileName, ext] = fileparts(fullFileName);
	switch lower(ext)
		case '.jp2'
			profile = 'Archival';
		case '.mp4'
			profile = 'MPEG-4';
		otherwise
			% Either avi or some other invalid extension.
			profile = 'Uncompressed AVI';
	end
	writerObj = VideoWriter(fullFileName, profile);
	open(writerObj);
	% Write out all the frames.
	%numberOfFrames = length(myMovie);
	for frameNumber = 1 : numberOfFrames 
	   writeVideo(writerObj, myMovie(frameNumber));
	end
	close(writerObj);
	% Display the current folder panel so they can see their newly created file.
	cd(folder);
	filebrowser;
	message = sprintf('Finished creating movie file\n      %s.\n\nDone with demo!', fullFileName);
	uiwait(helpdlg(message));
else
	uiwait(helpdlg('Done with demo!'));
end









