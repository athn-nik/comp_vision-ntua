%%
clear all
close all
clc
%%
%-------------2.1.1-------------------------
Iorig = imread('sunflowers.png');           %fortwsh eikonas
I = im2double(Iorig);                       %kanonikopoihsh kai metatroph se double
Is=rgb2gray(I);
sigma=2;
ro=2.5;
n1=ceil(3*sigma)*2+1;                      %upologismos mege8ous filtrou gaussian gia omalopoihsh eikonas
n2=ceil(3*ro)*2+1;                      %upologismos mege8ous filtrou gaussian gia omalopoihsh merikwn paragwgwn
GaussianS=fspecial('gaussian',[n1 n1],sigma);      %upologismos purhna filtrou omalopoihshs eikonas
Is = imfilter(Is, GaussianS);                    %omalopoihsh eikonas
[Isx, Isy] = gradient(Is);                      %upologismos merikwn paragwgwn eikonas
GaussianP=fspecial('gaussian',[n2 n2],ro);      %upologismos purhna filtrou omalopoihshs merikwn paragwgwn

J1=imfilter(Isx.*Isx, GaussianP);               %upologismos apaitoumenwn merikwn paragwgwn kai omalopoihsh tous
J2=imfilter(Isx.*Isy, GaussianP);
J3=imfilter(Isy.*Isy, GaussianP);

%%
%------------2.1.2--------------------------

Lplus=0.5*(J1+J3+sqrt((J1-J3).^2+4*(J2.^2)));       %upologismos gia ka8e pi3el telestwn L+ kai L-
Lminus=0.5*(J1+J3-sqrt((J1-J3).^2+4*(J2.^2)));

figure(1)
subplot(1,2,1); imshow(Lplus, []);title('Lplus') ;     %kanonikopoihsh telestwn L+ kai L- kai apeikonish tous
subplot(1,2,2); imshow(Lminus, []);title('Lminus');
print -djpeg Lplus_minus.jpeg

%%
%-----------2.1.3---------------------------
k = 0.05;
R=Lminus.*Lplus-k*(Lminus+Lplus).^2;                %upologismou krithriou gwniothtas apo tis times twn idiotimwn

th_corner = 0.005;
Rmax = max(R(:));
ns = ceil(3*sigma)*2 + 1;
B_sq = strel('disk',ns);
Cond1 = (R==imdilate(R,B_sq));                      %epilogh pixel pou antistoixoun se gwnia ta opoia ikanopoioun tis sun8hkes
Corners = Cond1 & R > th_corner*Rmax;               %efarmogh topikou megistou kai katwfliou

[corner_y, corner_x] = find(Corners);

interest_points_visualization(Iorig, [corner_x  corner_y  repmat(sigma, sum(Corners(:)), 1)]);        %xrhsh sunarthshs optikopoihshs twn gwniwn pou mas dinetai
CornerDetect( I, 1, 2.5, 0.05, 0.005, 1 );
CornerDetect( I, 2, 1.5,0.05, 0.005, 1 );
CornerDetect( I, 2, 2.5, 0.2, 0.005, 1 );
CornerDetect( I, 2, 2.5, 0.05, 0.015, 1 );

%%
%-----------2.2.1 & 2.2.2-------------------
sigma=2.5;                                                          %orismos parametrwn gia multiscale corner detect
ro=2;
k = 0.05;
th_corner = 0.005;
s = 1.5;
N = 4;
multiScaleCornerDetect(Iorig, sigma, ro, k, th_corner, s, N);     %efarmogh algori8mou;
%%
%-----------2.3.1 & 2.3.2-------------------
sigma=2;                                                          %orismos parametrwn gia blob detect
th_blob = 0.005;
BlobDetect(I, sigma, th_blob, 1);

%%
%-----------2.4.1---------------------------
sigma=2;                                                          %orismos parametrwn gia multiscale blob detect
th_blob = 0.005;
s = 1.5;
N = 4;
multiScaleBlobDetect(Iorig, sigma, th_blob, s, N,0);

%%
%-----------2.5.1 & 2.5.2-------------------
sigma=2;                                                                %sugkrish R me gaussian kai box filters
th_blob = 0.005;
[gaussianBlobs, R_hessian_gaussian] = BlobDetect(I, sigma, th_blob, 1);
%[boxfilterBlobs, R_hessian_box_filters] = integralImagesBlobDetect( Is, sigma, th_blob );

    n = 2*ceil(3*sigma) + 1;                                                                    %kataskeuh twn Lxx, Lyy kai Lxy me box filters proseggistika
    s_large = 4*floor(n/6) + 1;                                                                 %upologmos diastasewn twn box filters
    s_small = 2*floor(n/6) + 1;
    Lxx = (1/(s_large*s_small*4))*(integral_image_local_sum(Is,3*s_small,s_large, 0, 0)...       %upologismos kai kanonikopoihshs tou Lxx me box filter, xrhsimopoioume
        - 3*integral_image_local_sum(Is,s_small,s_large, 0, 0));                                 %para8uro pou perilamvanei ta kentrika pixel kai ta afairoume sth sunexeia
    Lyy = (1/(s_large*s_small*4))*(integral_image_local_sum(Is,s_large,3*s_small, 0, 0)...       %omoiws gia to Lyy
        - 3*integral_image_local_sum(Is,s_large,s_small, 0, 0));
    Lxy = (1/(s_small*s_small*4))*(integral_image_local_sum(Is,s_small,s_small, s_small+1, s_small+1)...       %omoiws gia to Lxy
        + integral_image_local_sum(Is,s_small,s_small, -s_small-1, -s_small-1)...
        - integral_image_local_sum(Is,s_small,s_small, s_small+1, -s_small-1)...
        - integral_image_local_sum(Is,s_small,s_small, -s_small-1, s_small+1));
    R_hessian_box_filters = Lxx.*Lyy - 0.81*Lxy.^2;
    Rmax = max(R(:));                                           %megisth timh krithriou
    ns = ceil(3*sigma)*2 + 1;
    B_sq = strel('disk',ns);                                    %kataskeuh purhna gia dilate ths eikonas
    Cond1 = (R_hessian_box_filters==imdilate(R_hessian_box_filters,B_sq));                              %euresh twn shmeiwn pou einai topika megista
    blob_binary_img = Cond1 & R > th_blob*Rmax;                 %dexomaste mono topika megista kai osa pernane to katofli th_blob
    
imshowpair(R_hessian_gaussian, R_hessian_box_filters,'montage');


for sigma = 3:3:9       %paragwgh 3 zeugwn eikonwn me stoxo thn a3iologhsh ths xrhshs box filters sthn anixneush blob
    [gaussianBlobs, ~] = BlobDetect(I, sigma, th_blob, 0);
    [boxfilterBlobs, ~] = integralImagesBlobDetect( Is, sigma, th_blob );
    [blob_y, blob_x] = find(gaussianBlobs);
    interest_points_visualization(Iorig, [blob_x  blob_y  repmat(sigma, sum(gaussianBlobs(:)), 1)]);
    [blob_y, blob_x] = find(boxfilterBlobs);
    interest_points_visualization(Iorig, [blob_x  blob_y  repmat(sigma, sum(boxfilterBlobs(:)), 1)]);
end
%pause(50);


%%
%------------------------------------------
sigma=2;                                                          %orismos parametrwn gia multiscale blob detect
th_blob = 0.025;
s = 1.5;
N = 5;
multiScaleBlobDetect(Iorig, sigma, th_blob, s, N,1); 

sigma=3;                                                          %orismos parametrwn gia multiscale blob detect
th_blob = 0.025;
s = 1.35;
N = 5;
multiScaleBlobDetect(Iorig, sigma, th_blob, s, N,1);
