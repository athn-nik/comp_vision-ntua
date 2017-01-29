%%
clear all
close all
clc
%%
%------------1.1.1--------------------------------------------
Io=imread('edgetest_16.png');   %fortwsh eikonas
Id=im2double(Io);              %kanonikopoihsh kai metatroph se double
figure(40);
imshow(Id)
title('Original Image');
%------------1.1.2--------------------------------------------
Imax=max(max(Id));              %euresh megistou kai elaxistou timhs eikonas
Imin=min(min(Id));
psnr=20;
s_20=(Imax-Imin)/(10^(psnr/20));            %upologismos katallhlhs timhs ths apoklishs 8orubou wste to PSNR na parei tis epi8umhtes times
s_20=s_20*s_20;
psnr=10;
s_10=(Imax-Imin)/(10^(psnr/20));
s_10=s_10*s_10;
I_psnr20=imnoise(Id,'gaussian',0,s_20);         %efarmogh 8orubou sthn eikona
I_psnr10=imnoise(Id,'gaussian',0,s_10);        %h imnoise pairnei variance gi auto kai o tetragwnismos
figure(1);
subplot(1,3,1);imshow(Io,[]); title('Original Image');
subplot(1,3,2);imshow(I_psnr20,[]); title('PSNR = 20');
subplot(1,3,3);imshow(I_psnr10,[]); title('PSNR = 10');          %apeikonish arxikhs eikonas kai eikonwn me efarmogh 8orubou gia sugkrish

%%
%------------1.2.1---------------------------------------------
s1=1.5;                                         %efarmogh gaussian filtrou sthn eikona gia e3aleipsh 8orubou
n=2*ceil(3*s1)+1;                               %upologismos mege8ous filtrou gaussian pou antistoixei sth do8eisa diaspora
Gaussian=fspecial('gaussian',n,s1);         %upologismos purhna filtrou gaussian
LaplacianG=fspecial('log',n,s1);            %upologismos purhna filtrou LoG

%%
%-----------1.2.2----------------------------------------------
L1=imfilter(I_psnr20,LaplacianG,'symmetric','conv');       %proseggish laplacian eikonas me L1 grammikh me8odo kai L2 mh grammikh me8odo
B=strel('disk',1);
IG = imfilter(I_psnr20,Gaussian,'symmetric','conv');       %efarmogh filtrou LoG
L2=imdilate(IG,B)+imerode(IG,B)-2*IG;               %efarmogh mh grammikou filtrou
figure(2);
subplot(1,2,1);imshow(L1,[]); title('Laplacian approximation with linear method (laplacian of gaussian) PSNR = 20');         %apeikonish twn duo proseggisewn gia sugkrish, sumfwna me th 8ewria prepei na parathrhsoume mikres diafores
subplot(1,2,2);imshow(L2,[]); title('Laplacian approximation with non linear method (morphological filters) PSNR = 20');

%%
%----------1.2.3-----------------------------------------------
zero_crossing_boolean = (L2 >= 0);                    %metatroph eikonas se duadikh
Y=imdilate(zero_crossing_boolean,B)-imerode(zero_crossing_boolean,B);       %euresh perigrammatos antikeimenwn me afairesh ths dilate me thn erode eikona

%%
%----------1.2.4-----------------------------------------------
[Ix, Iy] = gradient(IG);                            %upologismos twn merikwn paragwgwn ths eikonas se dieu8unsh X kai Y
normI = sqrt(Ix.^2+Iy.^2);                          %upologismos metrou ths paragwgou
th = 0.2;
D=( (Y==1)&(normI > (max(max(normI))*th)) );               %efarmogh threshold sth paragwgo gia thn apporipsh shmeiwn pou den einai akmes


M = imdilate(Id,B) - imerode(Id,B);                 %upologismos "alh8inwn" akmwn apo thn arxikh eikona xwris pros8hkh 8orubou
T = M > 0.19;

figure(4)
imshow(D);  title('Edge detect (psnr=20,s=1.5, non linear,th=0.2)');               %apeikonish apotelesmantwn edgeDetect
print -djpeg NON_LINEAR_PSNR20.jpeg
Cnl20 = (sum(sum(D == T & T == 1)) / sum(D(:)) + sum(sum(D == T & T == 1)) / sum(T(:)))/2       %a3iologish me8odou EdgeDetect me upologismo posostou mesou orou

figure()
D = EdgeDetect(I_psnr20, 0,1.5, 0.2);
imshow(D);  title('Edge detect (psnr=20,s=1.5, linear,th=0.2)');
print -djpeg LINEAR_PSNR20.jpeg
Cl20 = (sum(sum(D == T & T == 1)) / sum(D(:)) + sum(sum(D == T & T == 1)) / sum(T(:)))/2      %a3iologish me8odou EdgeDetect me upologismo posostou mesou orou

figure()
D = EdgeDetect(I_psnr10, 1,3, 0.2);
imshow(D);  title('Edge detect (psnr=10,s=3, non linear,th=0.2)');
print -djpeg NON_LINEAR_PSNR10.jpeg
Cnl10 = (sum(sum(D == T & T == 1)) / sum(D(:)) + sum(sum(D == T & T == 1)) / sum(T(:)))/2       %a3iologish me8odou EdgeDetect me upologismo posostou mesou orou

figure()
D = EdgeDetect(I_psnr10, 0,3, 0.2);
imshow(D);  title('Edge detect (psnr=10,s=3, linear,th=0.2)');
print -djpeg LINEAR_PSNR10.jpeg
Cl10 = (sum(sum(D == T & T == 1)) / sum(D(:)) + sum(sum(D == T & T == 1)) / sum(T(:)))/2    %a3iologish me8odou EdgeDetect me upologismo posostou mesou orou


%C = (sum(sum(D == T & T == 1)) / sum(D(:)) + sum(sum(D == T & T == 1)) / sum(T(:)))/2;       %a3iologish me8odou EdgeDetect me upologismo posostou mesou orou
pause (20);


%%
%----------1.3.1-----------------------------------------------
M = imdilate(Id,B) - imerode(Id,B);                 %upologismos "alh8inwn" akmwn apo thn arxikh eikona xwris pros8hkh 8orubou
T = M > 0.19;                                       %efarmogh threshold sthn eikona kai tautoxrona metatroph ths se duadikh morfh
figure(3)
%plot(1,2,1); 
imshow(T,[]);  title('Real edges');                     %apeikonish alh8inwn akmwn
%%
%----------1.3.2-----------------------------------------------
disp('Precision - recall percentage: ');
figure(4)
imshow(D);  title('Edge detect (psnr=20,s=1.5, non linear,th=0.2)');               %apeikonish apotelesmantwn edgeDetect
print -djpeg NON_LINEAR_PSNR20.jpeg
Cnl20 = (sum(sum(D == T & T == 1)) / sum(D(:)) + sum(sum(D == T & T == 1)) / sum(T(:)))/2       %a3iologish me8odou EdgeDetect me upologismo posostou mesou orou

figure()
D = EdgeDetect(I_psnr20, 0,1.5, 0.2);
imshow(D);  title('Edge detect (psnr=20,s=1.5, linear,th=0.2)');
print -djpeg LINEAR_PSNR20.jpeg
Cl20 = (sum(sum(D == T & T == 1)) / sum(D(:)) + sum(sum(D == T & T == 1)) / sum(T(:)))/2      %a3iologish me8odou EdgeDetect me upologismo posostou mesou orou

figure()
D = EdgeDetect(I_psnr10, 1,3, 0.2);
imshow(D);  title('Edge detect (psnr=10,s=3, non linear,th=0.2)');
print -djpeg NON_LINEAR_PSNR10.jpeg
Cnl10 = (sum(sum(D == T & T == 1)) / sum(D(:)) + sum(sum(D == T & T == 1)) / sum(T(:)))/2       %a3iologish me8odou EdgeDetect me upologismo posostou mesou orou

figure()
D = EdgeDetect(I_psnr10, 0,3, 0.2);
imshow(D);  title('Edge detect (psnr=10,s=3, linear,th=0.2)');
print -djpeg LINEAR_PSNR10.jpeg
Cl10 = (sum(sum(D == T & T == 1)) / sum(D(:)) + sum(sum(D == T & T == 1)) / sum(T(:)))/2    %a3iologish me8odou EdgeDetect me upologismo posostou mesou orou


%C = (sum(sum(D == T & T == 1)) / sum(D(:)) + sum(sum(D == T & T == 1)) / sum(T(:)))/2;       %a3iologish me8odou EdgeDetect me upologismo posostou mesou orou
   
%%
%----------1.3.3-----------------------------------------------
disp('Searching for best parameters (PSNR = 20)...');
disp('Percentage complete:');
fprintf('\n');
n = 0;
s = linspace(0.8,6,25);                  %anazhthsh veltistwn parametrwn me dokimh pollwn test cases kai sugkrish tou posostou
th = linspace(0.05,0.75,25);

Clinear = zeros(numel(s), numel(th));
Cnonlinear = zeros(numel(s), numel(th));

for i = 1:size(s,2)
    for j = 1:size(th,2)
        D = EdgeDetect(I_psnr20, 0, s(i), th(j));       %efarmogh sunarthshs mas EdgeDetect linear
        Clinear(i,j) = (sum(sum(D == T & T == 1)) / sum(D(:)) + sum(sum(D == T & T == 1)) / sum(T(:)))/2;       %upologismos posostou
        D = EdgeDetect(I_psnr20, 1, s(i), th(j));       %efarmogh sunarthshs mas EdgeDetect non linear
        Cnonlinear(i,j) = (sum(sum(D == T & T == 1)) / sum(D(:)) + sum(sum(D == T & T == 1)) / sum(T(:)))/2;       %upologismos posostou  
    end
    fprintf(repmat('\b',1,n));  %%tupwnoume pososto
    if((i*100)/size(s,2) > 10)
        n = 6;
    else
        n = 5;
    end
    fprintf('%.2f%%', (i*100)/size(s,2));
end
fprintf('\n');

[i_max_linear, j_max_linear] = find(Clinear==max(Clinear(:)));
[i_max_nonlinear, j_max_nonlinear] = find(Cnonlinear==max(Cnonlinear(:)));
s1l=s(i_max_linear);
th1l= th(j_max_linear);
s1nl=s(i_max_nonlinear);
th1nl= th(j_max_nonlinear);
disp('Maximum recall - precision percentage for linear edge detect was ');
disp(Clinear(i_max_linear, j_max_linear));
fprintf('Settings used s = %f, th = %f\n', s(i_max_linear), th(j_max_linear));
figure(4)
imshow(EdgeDetect(I_psnr20, 0, s(i_max_linear), th(j_max_linear))); %veltista apotelesmata psnr 20
title('Best results linear edge detect PSNR = 20');
figure(5)
imagesc(th,s,Clinear);
title('Recall - precision for linear edge detect PSNR = 20');
ylabel('sigma');
xlabel('theta');
colormap(bone);
print -djpeg image_psnr_20_linear.jpeg

disp('Maximum recall - precision percentage for non linear edge detect was ');
disp(Cnonlinear(i_max_nonlinear, j_max_nonlinear));
fprintf('Settings used s = %f, th = %f\n', s(i_max_nonlinear), th(j_max_nonlinear));
figure(6)
imshow(EdgeDetect(I_psnr20, 1, s(i_max_nonlinear), th(j_max_nonlinear))); %veltista apotelesmata psnr 20
title('Best results non linear edge detect PSNR = 20');
figure(7)
imagesc(th,s,Cnonlinear);
title('Recall - precision for non linear edge detect PSNR = 20');
ylabel('sigma');
xlabel('theta');
colormap(bone);
print -djpeg image_psnr_20_non_linear.jpeg

%%------------------------------------PSNR = 10----------------------------
disp('Searching for best parameters (PSNR = 10)...');
disp('Percentage complete:');
fprintf('\n');
n = 0;
for i = 1:size(s,2)
    for j = 1:size(th,2)
        D = EdgeDetect(I_psnr10, 0, s(i), th(j));       %efarmogh sunarthshs mas EdgeDetect linear
        Clinear(i,j) = (sum(sum(D == T & T == 1)) / sum(D(:)) + sum(sum(D == T & T == 1)) / sum(T(:)))/2;       %upologismos posostou
        D = EdgeDetect(I_psnr10, 1, s(i), th(j));       %efarmogh sunarthshs mas EdgeDetect non linear
        Cnonlinear(i,j) = (sum(sum(D == T & T == 1)) / sum(D(:)) + sum(sum(D == T & T == 1)) / sum(T(:)))/2;       %upologismos posostou  
    end
    fprintf(repmat('\b',1,n));  %%tupwnoume pososto
    if((i*100)/size(s,2) > 10)
        n = 6;
    else
        n = 5;
    end
    fprintf('%.2f%%', (i*100)/size(s,2));
end
fprintf('\n');

[i_max_linear, j_max_linear] = find(Clinear==max(Clinear(:)));
[i_max_nonlinear, j_max_nonlinear] = find(Cnonlinear==max(Cnonlinear(:)));
s2l=s(i_max_linear);
th2l=th(j_max_linear);
s2nl=s(i_max_nonlinear);
th2nl=th(j_max_nonlinear);
disp('Maximum recall - precision percentage for linear edge detect was ');
disp(Clinear(i_max_linear, j_max_linear));
fprintf('Settings used s = %f, th = %f\n', s(i_max_linear), th(j_max_linear));
figure(8)
imshow(EdgeDetect(I_psnr10, 0, s(i_max_linear), th(j_max_linear))); %veltista apotelesmata psnr 10
title('Best results linear edge detect PSNR = 10');
figure(9)
imagesc(th,s,Clinear);
title('Recall - precision for linear edge detect PSNR = 10');
ylabel('sigma');
xlabel('theta');
colormap(bone);
print -djpeg image_psnr_10_linear.jpeg

disp('Maximum recall - precision percentage for non linear edge detect was ');
disp(Cnonlinear(i_max_nonlinear, j_max_nonlinear));
fprintf('Settings used s = %f, th = %f\n', s(i_max_nonlinear), th(j_max_nonlinear));
figure(10)
imshow(EdgeDetect(I_psnr10, 1, s(i_max_nonlinear), th(j_max_nonlinear))); %veltista apotelesmata psnr 10
title('Best results non linear edge detect PSNR = 10');
figure(11)
imagesc(th,s,Cnonlinear);
title('Recall - precision for non linear edge detect PSNR = 10');
ylabel('sigma');
xlabel('theta');
colormap(bone);
print -djpeg image_psnr_10_non_linear.jpeg



%% gia diafores parametrous meleth eikonw

% PSNR = 20 

% for best deviation and various theta
I1= EdgeDetect(I_psnr20,0,s1l,0.3); %
I2= EdgeDetect(I_psnr20,0,s1l,0.05); % 
I3= EdgeDetect(I_psnr20,1,s1nl,0.3); % 
I4= EdgeDetect(I_psnr20,1,s1nl,0.05); %

% for best theta and various sn
I5= EdgeDetect(I_psnr20,0,2,th1l); % 
I6= EdgeDetect(I_psnr20,0,0.7,th1l); % 
I7= EdgeDetect(I_psnr20,1,2,th1nl); % 
I8= EdgeDetect(I_psnr20,1,0.7,th1nl); % 
figure();
subplot(2,2,1),imshow(I1,[]),title('deviation best,theta higher(0.3),linear');
subplot(2,2,2),imshow(I2,[]),title('deviation best and for theta lower(0.05) ,linear');
subplot(2,2,3),imshow(I3,[]),title('deviation best,theta higher(0.3) ,non-linear');
subplot(2,2,4),imshow(I4,[]),title('deviation best,theta lower(0.05) ,non-linear');
print -djpeg subplotTHETA10_th.jpeg


figure();
subplot(2,2,1),imshow(I5,[]),title('theta best ,deviation higher(2),linear');
subplot(2,2,2),imshow(I6,[]),title('theta best ,deviation lower(0.7) ,linear');
subplot(2,2,3),imshow(I7,[]),title('theta best ,deviation higher(2) ,non-linear');
subplot(2,2,4),imshow(I8,[]),title('theta best ,deviation lower(0.7),non-linear');
print -djpeg subplotSN10_th.jpeg



% PSNR = 10


% for best deviation and various theta
I1= EdgeDetect(I_psnr10,0,s2l,0.5); %
I2= EdgeDetect(I_psnr10,0,s2l,0.05); % 
I3= EdgeDetect(I_psnr10,1,s2nl,0.5); % 
I4= EdgeDetect(I_psnr10,1,s2nl,0.05); %

% for best theta and various sn
I5= EdgeDetect(I_psnr10,0,2.5,th2l); % 
I6= EdgeDetect(I_psnr10,0,1.1,th2l); % 
I7= EdgeDetect(I_psnr10,1,2.5,th2nl); % 
I8= EdgeDetect(I_psnr10,1,1.1,th2nl); % 

figure();
subplot(2,2,1),imshow(I1,[]),title('deviation best,theta higher(0.5),linear');
subplot(2,2,2),imshow(I2,[]),title('deviation best,theta lower(0.05),linear');
subplot(2,2,3),imshow(I3,[]),title('deviation best,deviation higher(0.5),non-linear');
subplot(2,2,4),imshow(I4,[]),title('deviation best,deviation lower(0.05),non-linear');
print -djpeg subplotTHETA20_th.jpeg


figure();
subplot(2,2,1),imshow(I5,[]),title('theta best,deviation higher(2.5),linear');
subplot(2,2,2),imshow(I6,[]),title('theta best,deviation lower(1.1),non-linear');
subplot(2,2,3),imshow(I7,[]),title('theta best,deviation higher(2.5),non-linear');
subplot(2,2,4),imshow(I8,[]),title('theta best,deviation lower(1.1),non-linear');
print -djpeg subplotSN20_th.jpeg

