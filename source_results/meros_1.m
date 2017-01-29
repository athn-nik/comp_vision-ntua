close all; 
clearvars;

resultsFolder = 'results_plots';
if ~exist(resultsFolder, 'dir')
  mkdir(resultsFolder);
end
resultsPath = strcat(resultsFolder, '/');

Samplesrgb=load('skinSamplesRGB');                 %fortwsh arxeiou deigmatwn dermatos
Samplesrgb = Samplesrgb.skinSamplesRGB;            %fortwsh xrwmatwn rgb

currentFigure = figure();
imshow(Samplesrgb);
title('Deigmata dermatos');
set(gcf,'PaperPositionMode','auto');
print(currentFigure, strcat(resultsPath,'skin_samples.png'), '-dpng', '-r0');

SamplesYcbcr=im2double(rgb2ycbcr(Samplesrgb));     %metatroph xrwmatwn sto xwro YCbCr kai 
Icb=reshape(SamplesYcbcr(:,:,2),[],1);             %reshape dusdiastaths eikonas se dianusma
Icr=reshape(SamplesYcbcr(:,:,3),[],1);
mcb=mean(mean(SamplesYcbcr(:,:,2)));               %upologismos mesou orou kanaliou Cb
mcr=mean(mean(SamplesYcbcr(:,:,3)));               %upologismos mesou orou kanaliou Cr
M=[mcb, mcr];                                      %kataskeuh dianusmatos mesou orou kanaliwn Cb kai Cr
S=cov(Icb,Icr);                                    %upologismos sundiakumanshs kanaliwn Cb kai Cr

X = linspace(0.35, 0.7, 100);                       %apeikonish gkaousianhs e3iswshs upologismou dermatos
Y = linspace(0.3, 0.6, 100);
Pgauss = zeros(100);
for i = 1:100
    for j = 1:100
        distance = ([Y(i) X(j)] - M);
        Pgauss(i, j) = exp(-0.5 * distance * (S \ distance')) / (2*pi * sqrt(det(S)));
    end
end
Pgauss = Pgauss / max(max(Pgauss));
currentFigure = figure();
surf(X, Y, Pgauss);
title('Gkaousianh katanomh anixneuth dermatos');
set(gcf,'PaperPositionMode','auto');
print(currentFigure, strcat(resultsPath,'gaussian_distribution_color_space.png'), '-dpng', '-r0');

cd Chalearn;
Iframeycbcr=im2double(rgb2ycbcr(imread('1.png')));  %metatroph eikonas sto xrwmatiko xwro YCbCr kai kanonikopoihsh
cd ..;

cd ChalearnUser;
KinectMask = imread('U1.png');
cd ..;

Iframecb=reshape(Iframeycbcr(:,:,2),[],1);          %reshape se dianusma
Iframecr=reshape(Iframeycbcr(:,:,3),[],1);
ImSize = size(Iframeycbcr(:,:,1));                %upologismos mege8ous eikonas
Pskin =mvnpdf([Iframecb,Iframecr],M,S);           %efarmogh gkaousianhs sunarthshs upologismou pi8anothtas na einai derma ta stoixeia
Pskin = Pskin / max(max(Pskin));                  %kanonikopoihsh apotelesmatos
Pskin = reshape(Pskin,ImSize(1),ImSize(2) );      %reshape eikonas se dusdiastato pinaka

currentFigure = figure();
imshow(Pskin);
title('Eikona pi8anothtwn dermatos');
set(gcf,'PaperPositionMode','auto');
print(currentFigure, strcat(resultsPath,'skin_probability.png'), '-dpng', '-r0');

Pskin = Pskin > 0.22;                              %efarmogh filtou kai metatroph eikonas se duadikh

currentFigure = figure();
subplot(1,2,1); imshow(Pskin);                    %apotelesma efarmoghs anixneuth dermatos
title('Apotelesma anixneuth dermatos');
Pskin = Pskin.*KinectMask;                        %xrhsh maska apo kinect gia thn aporipsh perioxwn pou den anhkoun sto xrhsth
subplot(1,2,2); imshow(Pskin);
title('Efarmogh maskas kinect');

set(gcf,'PaperUnits','points');
set(gcf,'PaperPositionMode','manual');
set(gcf,'PaperPosition',[0 0 700 400]);
print(currentFigure, strcat(resultsPath,'skin_threshold_kinect_mask.png'), '-dpng', '-r0');

s_open = strel('disk',2);                         %upologismos mikrou kai megalou purhna gia open kai close
s_close = strel('disk',13);
Pskin_open = imopen(Pskin, s_open);                %open me mikro purhna gia afairesh mikrwn perioxwn
Pskin_close = imclose(Pskin_open, s_close);        %close gia sunenwsh geitwnikwn perioxwn kai trupwn

currentFigure = figure();                                       %apeikonish vhmatwn openclose
subplot(1,3,1); imshow(Pskin);
title('Arxikh eikona');
subplot(1,3,2); imshow(Pskin_open);
title('open me mikro purhna');
subplot(1,3,3); imshow(Pskin_close);
title('close me megalo purhna');

set(gcf,'PaperUnits','points');
set(gcf,'PaperPositionMode','manual');
set(gcf,'PaperPosition',[0 0 900 400]);
print(currentFigure, strcat(resultsPath,'skin_morfological_processing.png'), '-dpng', '-r0');

BW = logical(Pskin_close);                          %xwrismos antikeimenwn eikonas
stats = regionprops(BW, 'area', 'boundingBox');     %euresh stoxeiwn gia ta antikeimena (emvadon kentro klp)
stats_cells = struct2cell(stats);                   %metatroph struct ths sunarthshs regionprops se double
coordinate = cell2mat(stats_cells(2,:)');           %e3agwgh suntetagmenwn plaisiwn kai rotate wste ka8e sthlh na
                                                    %exei thn idia parametro gia ola ta plaisia
[~, indx_hand] = min(coordinate(:,1));   %euresh perioxhs sto aristerotero meros ths eikonas

currentFigure = figure();                                          %apeikonish telikhs eikonas me plaisio
imshow(Pskin_close);
hold on;
rect = rectangle('Position', stats(indx_hand).BoundingBox);
set(rect, 'EdgeColor', 'g');
title('Hand detection result');
set(gcf,'PaperPositionMode','auto');
print(currentFigure, strcat(resultsPath,'skin_final_hand_detected.png'), '-dpng', '-r0');