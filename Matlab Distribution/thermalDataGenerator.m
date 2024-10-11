clc;
clear;
close all;

%%
laptop = 1;
videoWrite = 1;
noisy = 0;
%% Load true data
if  laptop == 1
    path='C:\MCHA Workspace\firespreadfyp\Cellular Automata\CA Estimator with Spotting\data';
else
    path='T:\MCHA Tool Chain 2.0\firespreadfyp\Cellular Automata\CA Estimator with Spotting\data';
end
J = 1000;
JJ = J;
JJJ = 250;
M = zeros(J,JJ,JJJ);

for i = 1:JJJ
    textfilename = ['MsC' num2str(i) '.csv'];
    path_format = fullfile(path, textfilename);
    M(:,:,i) = readmatrix(path_format);
end
%% Convert true data to thermal data and write to files
tic
M_therm = zeros(J,JJ,JJJ);
                
%if fuel
% xlen = length(M(M==2));
% lambda = 0.1;
% b = 35;
% a = 25;
% p = 0.75;
% U = rand(xlen,1) < p;
% nA = sum(U);
% nB = xlen - nA;
% X = zeros(xlen,1);
% X(U) = normalize(rand(nA,1), 'range', [25,35]);
% X(~U) = normalize(((lambda*b - log(rand(nB,1)/lambda))/lambda), 'range', [b, 100]);
% M(M==2) = X;

%guassian distribution
xlen = length(M(M==2));
x = randn(xlen,1);
guass2 = normalize(x, 'range', [25 35]);
M(M==2) = guass2;
                
%if burning
xlen = length(M(M==3));
x = randn(xlen,1);
guass3 = normalize(x, 'range', [300 1200]);
M(M==3) = guass3;

%if out
xlen = length(M(M==1));
x = randn(xlen,1);
guass1 = normalize(x, 'range', [25 600]);
M(M==1) = guass1;
M_therm(:,:,:) = M;
toc
%% 
for i= 1:JJJ
    %%%%%% WRITE TIMESTEP TO FILES %%%%%
    textfilename = ['MsC_t' num2str(i) '.csv'];
    path_format = fullfile(path, textfilename);
    writematrix(M_therm(:,:,i),path_format);
end

%% Visualise analogue map
figure1 = figure(1);
set(gcf, 'Position',  [250, 0, 1000, 1000])
colormap gray
for i = 1:JJJ
    image(M_therm(:,:,i),'CDataMapping','scaled'); %display timestep graphically 
    colorbar
    Mff(i) = getframe(gcf);
    pause(0.05);
    figure1filename = [path '\figures\trueData' num2str(i) '.fig'];
    savefig(figure1, figure1filename);
end

%% Write to video

if (videoWrite == 1)
    writerObj = VideoWriter('MCsC.avi');
    writerObj.FrameRate = 10; % sets the fps
    open(writerObj);

    for t = 1:length(Mff)
        % convert the image to a frame
        frame = Mff(t);
        writeVideo(writerObj, frame);
    end

    close(writerObj);
end