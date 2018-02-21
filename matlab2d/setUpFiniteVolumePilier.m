function [ output_args ] = setUpFiniteVolume( length, width, resolution, du, dv, tmax )
%SETUPFINITEVOLUME 
% Configure et démarre la simulation , affiche des données à l'écran
% - lenght: longueur du domaine (m)
% - width: largeur du domaine (m)
% - resolution: mailles sur la largeur
% - du: débit dans la direction u
% - dv: débit dans la direction v
% - tmax: durée maximale de la simulation


% Vérifier la configuration des bords:
global SV_REFLECT_TOP;
global SV_REFLECT_BOTTOM;
global SV_REFLECT_LEFT;
global SV_REFLECT_RIGHT;

global SV_DEBIT_U;
global SV_DEBIT_V;

global SV_TITLE;
global SV_DROP_AT

if ~exist('SV_REFLECT_TOP','var')
    SV_REFLECT_TOP=true;
end

if ~exist('SV_REFLECT_BOTTOM','var')
    SV_REFLECT_BOTTOM=true;
end

if ~exist('SV_REFLECT_LEFT','var')
    SV_REFLECT_LEFT=true;
end

if ~exist('SV_REFLECT_RIGHT','var')
    SV_REFLECT_RIGHT=true;
end

SV_DEBIT_U = du
if du ~= 0.0
    SV_REFLECT_LEFT = false;
    SV_REFLECT_RIGHT = false;
end

SV_DEBIT_V = dv
if dv ~= 0.0
    SV_REFLECT_TOP = false;
    SV_REFLECT_BOTTOM = false;
end

% Monter le domaine
deltax = width / resolution;
Nu = length / deltax;
Nv = width / deltax;

N2 = Nu * Nv

alpha = 0.9;

% Configurer le fluide
hn = ones(1,N2);

hun = du * ones(1,N2);
hvn = dv * ones(1,N2);

u = [hn;hun;hvn];

t = 0;
dt = 0.01;

if exist('SV_DROP_AT', 'var')
    drop_at = SV_DROP_AT;
else
    drop_at = tmax+1;
end


% Configurer le film
numberOfFrames = tmax / dt;
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

while t < tmax
    
    frameIndex = frameIndex + 1;
    
    if (t > drop_at -dt) & (t < drop_at + dt)
        u(1, (Nv + 1) * Nu/2 ) = 5;
    end
    u = finiteVolume2dPilier(u,dt,t,alpha, Nu, Nv, deltax);
    %pause(0.1)
    t = t + dt
    cla reset;

    x = linspace(0,length,Nu);
    y = linspace(0,width,Nv);
    [X,Y] = meshgrid(x,y);
    
    Z = [];
    PU = [];
    PV = [];
    for i = 1:Nv
        Z = [Z; u(1,(i-1)*Nu+1:i*Nu)];
        PU = [PU; u(2,(i-1)*Nu+1:i*Nu)];
        PV = [PV; u(3,(i-1)*Nu+1:i*Nu)];
    end
    
    hold on
    h = surf(X,Y,Z);
    axis('tight')
    %quiver(X,Y,PU,PV);
    zlim([0 2.5]);
    daspect([1 1 1]);
    %view(135- 30 * t,30-20 * sin(t))
    view(135,30)
    shading interp
    
    title({SV_TITLE sprintf("t = %.2f s", t)});
    
    drawnow;
	thisFrame = getframe(gca);
	% Write this frame out to a new video file.
%  	writeVideo(writerObj, thisFrame);
	myMovie(frameIndex) = thisFrame;
    
end;
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


end

