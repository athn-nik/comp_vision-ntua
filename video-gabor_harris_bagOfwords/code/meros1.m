close all;
clearvars;
clc;

videoFolder = './samples';
outputFolder = './output';
preprocessedFolder = './videos';

default_xy_scale = 2;
default_harris_time_scale = 0.7;
default_gabor_time_scale = 1.6;
default_th_harris= 0.00048;
default_th_gabor= 0.047;

default_k = 0.0047;
default_neighbor_sphere_maxima = 2;
xy_gaussian_scale = [1 4];%linspace(1.5, 4.5, 6);
time_gaussian_scale_harris = [0.4 2];%linspace(0.2, 3, 6);
time_gaussian_scale_gabor = [0.8 2.5];%linspace(1, 3.5, 6);
th = [0.001 0.01];%linspace(0.001, 0.02, 8);
% neighbor_sphere_maxima = [1 3];

nframes = 200;

if ~exist(outputFolder,'dir')
    mkdir(outputFolder);
end

if ~exist(preprocessedFolder,'dir')
    mkdir(preprocessedFolder);
    fileList = getAllFiles('./samples');
    for i = 1:size(fileList, 1)
        vid = readVideo(fileList{i,:}, nframes, 0);
        save(strcat(preprocessedFolder, '/', int2str(i), '.mat'),'vid');
    end
end

[~, labels] = getAllFiles(videoFolder);

selected_frames_idx = [0 0 ; 0 0 ;30 70;10 118 ; 0 0 ; 0 0;0 0 ; 0 0 ;62 64];

cd(preprocessedFolder);
I3 = load('3.mat');
I4 = load('4.mat');
I8 = load('8.mat');
cd ..;
points = multiScaleHarrisDetect(I3, 2, 0.7,0.0047,0.00048, 3, 1.5, 4);
showDetection(I3.vid, points, 10, 1, outputFolder, 'multi_scale', 'boxing');
points = multiScaleHarrisDetect(I4, 2, 0.7,0.0047,0.00048, 3, 1.5, 4);
showDetection(I4.vid, points, 11, 1, outputFolder, 'multi_scale', 'running');
points = multiScaleHarrisDetect(I8, 0.7, 0.7,0.0047,0.00048, 3, 1.5, 4);
showDetection(I8.vid, points, 30, 1, outputFolder, 'multi_scale', 'walking');

points = multiScaleGaborDetect(I3, 0.7, 1.6,0.05, 3, 1.5, 4);
showDetection(I3.vid, points, 12, 1, outputFolder, 'multi_scale_gabor_', 'boxing');
points = multiScaleGaborDetect(I4, 0.7, 1.6,0.05, 3, 1.5, 4);
showDetection(I4.vid, points, 6, 1, outputFolder, 'multi_scale_gabor_', 'running');
points = multiScaleGaborDetect(I8, 0.7, 1.6,0.05, 3, 1.5, 4);
showDetection(I8.vid, points, 30, 1, outputFolder, 'multi_scale_gabor_', 'walking')



for i = [3 4 9]%1:numel(labels)
    cd(preprocessedFolder);
    I = load(strcat(num2str(i), '.mat'));
    cd ..;

    vidName = strcat('vid_', num2str(i));
    DisplVideoInterestPoints( I, 1, default_xy_scale, default_harris_time_scale, default_k, default_th_harris, default_neighbor_sphere_maxima, selected_frames_idx(i,:), outputFolder, vidName );
    DisplVideoInterestPoints( I, 0, default_xy_scale, default_gabor_time_scale, 0, default_th_gabor, default_neighbor_sphere_maxima, selected_frames_idx(i,:), outputFolder, vidName );
    
    for k = xy_gaussian_scale
        DisplVideoInterestPoints( I, 1, k, default_harris_time_scale, default_k, default_th_harris, default_neighbor_sphere_maxima, selected_frames_idx(i,:), outputFolder, vidName );
        DisplVideoInterestPoints( I, 0, k, default_gabor_time_scale, 0, default_th_gabor, default_neighbor_sphere_maxima, selected_frames_idx(i,:), outputFolder, vidName );
    end
    
    for k = time_gaussian_scale_harris
        DisplVideoInterestPoints( I, 1, default_xy_scale, k, default_k, default_th_harris, default_neighbor_sphere_maxima, selected_frames_idx(i,:), outputFolder, vidName );
    end
    
    for k = time_gaussian_scale_gabor
        DisplVideoInterestPoints( I, 0, default_xy_scale, k, 0, default_th_gabor, default_neighbor_sphere_maxima, selected_frames_idx(i,:), outputFolder, vidName );
    end
    
end

