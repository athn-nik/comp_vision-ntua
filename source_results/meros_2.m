close all;
clearvars;
clc;

%orismos fakelwn kai parametrwn
resultsFolderFrames = 'results_frames/';
resultsFolderQuiver = 'results_quiver/';
resultsFolderEnergy = 'results_energy/';

ro = 15.125;
epsilon = 0.05;
pyramid_scales = 4;
energy_thresh = 0.575;

if ~exist(resultsFolderFrames, 'dir')
  mkdir(resultsFolderFrames);
end

if ~exist(resultsFolderQuiver, 'dir')
  mkdir(resultsFolderQuiver);
end
if ~exist(resultsFolderEnergy, 'dir')
  mkdir(resultsFolderEnergy);
end
addpath(pwd);

[M, S] = init_skin_filter();    %kataskeuh filtrou dermatos opws egine sto meros 1

cd Chalearn;
names = dir('*.png');           %dhmiourgia listas olwn twn arxeiwn eikonas png
numIcons = length(names);       %upologismos ari8mou frame
I = zeros(480,640,numIcons);    %arxikopoihsh pinaka dedomenwn video
file_names = char(names(:).name);   %kataskeuh pinaka char me ta onomata
[~, order] = sortrows(ParseFileName2Num(file_names));
names = names(order);           %allagh seiras frame

for k = 1:numIcons
  I(:,:,k) = im2double(rgb2gray(imread(names(k).name)));   %fortwsh arxeiwn eikonas kai metatroph se gkri klimaka
end
first_image = imread(names(1).name);   %fortwsh prwths eikonas se egxrwmh morfh
cd ..;

cd ChalearnUser;
names = dir('*.png');           %dhmiourgia listas olwn twn arxeiwn eikonas png
numIcons = length(names);       %upologismos ari8mou frame
KinectMask = zeros(480,640,numIcons);    %arxikopoihsh pinaka kinect
file_names = char(names(:).name);   %kataskeuh pinaka char me ta onomata
[~, order] = sortrows(ParseFileName2Num(file_names));
names = names(order);           %allagh seiras frame

for k = 1:numIcons
  KinectMask(:,:,k) = im2double(imread(names(k).name));   %fortwsh arxeiwn
end
first_kinect = repmat(uint8(imread(names(1).name)),1,1,3);
cd ..;

%I = I.*KinectMask;        %efarmogh kinect mask se ola ta frames

coord = boundingBox(first_image.*first_kinect, M, S);   %upologismos plaisiou prwswpou
coord = coord + int16([-10 -10 20 20]);         %au3hsh plaisiou me stoxo thn apofugh la8wn

zer_d = zeros(coord(4)+1, coord(3)+1);    %arxikopoihsh arxikwn sun8hkwn optikhs rohs
handx = double(coord(1));                 %arxikopoihsh dianusmatos 8eshs proswpou
handy = double(coord(2));

delete *.avi;
writerObj = VideoWriter(strcat('hand_ro_', num2str(ro), '_e_', num2str(epsilon), '_thr_', num2str(energy_thresh),'.avi'));
writerObj.FrameRate = 8;                 %epilogh xamhlou frame rate gia eukoloterh meleth apotelesmatos
open(writerObj);                         %anoigma arxeio video e3odou

DispFrame(I(:,:,1).*KinectMask(:,:,1), coord,1, true, strcat(resultsFolderFrames, num2str(1)));

for k = 1:numIcons - 1
    Iw1 = get_box(I(:,:,k), coord);      %epilogh perioxhs xeriou sth prwth eikona kai antistoixwn
    Iw2 = get_box(I(:,:,k+1), coord);    %stoixeiwn apo th deuterh eikona

    %[dx, dy] = LK(Iw1, Iw2, ro, epsilon, zer_d, zer_d);
    [dx, dy] = LK_Pyramid(Iw1, Iw2, ro, epsilon,pyramid_scales);     %epilogh epi8umhtou algori8mou (aplou h puramidas)
    
    d_x_r = imresize(dx,0.5);                   %upodeigmatolhpsia optikhs rohs gia thn apeikonish ths
    d_y_r = imresize(dy,0.5);
    currentFigure = figure(2);
    quiver(-d_x_r,-d_y_r);                       %apeikonish optikhs rohs
    print(currentFigure, strcat(resultsFolderQuiver, num2str(k), '-', num2str(k+1)), '-dpng', '-r0');
    
    currentFigure = figure(3);
    energy = dx.^2 + dy.^2;
    imshow(energy,[]);
    print(currentFigure, strcat(resultsFolderEnergy, num2str(k), '-', num2str(k+1)), '-dpng', '-r0');
    
    [displ_x,displ_y] = displ(dx,dy,energy_thresh);    %upologismos telikou dianismatos metatopishs
    handx = handx + displ_x;             %ananewsh dianusmatos 8eshs proswpou
    handy = handy + displ_y;
    coord(1) = int16(handx);             %ananewsh 8eshs suntetagmenwn plaisiou
    coord(2) = int16(handy);
    DispFrame(I(:,:,k+1).*KinectMask(:,:,k+1), coord,1,true, strcat(resultsFolderFrames, num2str(k+1)));
    frame = getframe;                    %apo8hkeush frame sto video
    writeVideo(writerObj,frame);
end
close(writerObj);                        %kleisimo arxeiou video