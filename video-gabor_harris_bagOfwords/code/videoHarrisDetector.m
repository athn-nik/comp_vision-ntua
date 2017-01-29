function [ points,binary_img ] = videoHarrisDetector( I, sxy, st, k, th, neighbor_sphear_kernel_size )

I = im2double(I);                                                               %metatroph eikonas se double

Ix = imfilter(I, [-1 0 1], 'replicate');                                        %upologismos paragwgou ws pros x me kerner [-1 0 1]
Iy = imfilter(I, [-1 0 1]', 'replicate');                                       %upologismos paragwgou ws pros y me kerner [-1 0 1]'

%Ix = convn(I, [-1 0 1], 'same');                                               %enallaktika mporoume na upologisoume tis paragwgous me suneli3h
%Iy = convn(I, [-1 0 1]', 'same');                                              %omws auto mas dhmiourgei stis akraies 8eseis sfalma dioti oi times ektws
%kernel(1,1,1:3) = [-1 0 1];                                                    %ths eikonas 8ewrountai ises me 0
%It = convn(I, kernel, 'same');

[~, ~, It] = gradient(I);                                                       %xrhsh ths sunarthshs gradient gia paragwgo ws pros to xrono prwths ta3hs

nxy=ceil(3*sxy)*2+1;                                                            %upologismos mege8ous para8urou xwrikou gaussian
nt=ceil(3*st)*2+1;                                                              %kai to idio gia to xroniko (ws pros diastash z)
gxy = fspecial('gaussian',[nxy nxy],sxy);                                       %upologismos gaussian filtrou 2D (xwriko)
gt(1,1,1:nt) = fspecial('gaussian',[1 nt],st);                                  %upologismos gaussian filtrou 1D kai topo8ethsh tou sth Z diastash

%sumfwna me thn ekfwnhsh 8ewroume L = [Ix Iy It]^T opote L*L^T mas dinei ton parakatw pinaka
% [ Ix^2  IxIy  IxIt ]
% [ IxIy  Iy^2  IyIt ]
% [ IxIt  IyIt  It^2 ]

%opws kaname kai sto 1o ergasthrio upologizoume to apotelesma ka8e stoixeiou autou tou pinaka me suneli3h me to 3d gaussian filtro mas

Jxx = imfilter(imfilter(Ix.*Ix, gxy, 'replicate'), gt,'replicate');             %efarmozoume ta filtra me 2 vhmata gia meiwsh twn pra3ewn
Jyy = imfilter(imfilter(Iy.*Iy, gxy, 'replicate'), gt,'replicate');             %(anti na upologisoume to teliko 3d kernel)
Jtt = imfilter(imfilter(It.*It, gxy, 'replicate'), gt,'replicate');

Jxy = imfilter(imfilter(Ix.*Iy, gxy, 'replicate'), gt,'replicate');
Jxt = imfilter(imfilter(Ix.*It, gxy, 'replicate'), gt,'replicate');
Jyt = imfilter(imfilter(Iy.*It, gxy, 'replicate'), gt,'replicate');

traceM = (Jxx + Jyy + Jtt);                                                             %upologisame tous tupous tou trace(M)
detM = Jxx.*Jyy.*Jtt + 2*Jxy.*Jxt.*Jyt - Jxx.*Jyt.^2 - Jyy.*Jxt.^2 - Jtt.*Jxy.^2;       %kai tou det(M)

%twra se auto to shmeio exoume to det kai to trace twn pinakwn M gia ola ta pixel tou video mas opote apo auto upologizoume to H

H = abs(detM - k*traceM.^3);                                                            %upologismos H (pairnoume apoluth timh giati htan arnhtiko)

b = ceil(neighbor_sphear_kernel_size);
[x,y,z] = ndgrid(-b:b);                                                                 %dhmiourgia grid 3d bxbxb
B = strel(sqrt(x.^2 + y.^2 + z.^2) <=b);                                                %kataskeuh sfairas 3d kernel geitonias

Hmax = max(H(:));
Cond1 = (H == imdilate(H, B));                                                          %efarmogh kernel gia thn euresh twn topikwn megistwn shmeiwn sto H
binary_img = Cond1 & H > th*Hmax;                                                       %xwroxronika kai epilogh twn megistwn me megalh timh apoluta

[py, px, pz] = ind2sub(size(binary_img),find(binary_img));                              %vriskoume ta indexes twn shmeiwn pou plhroun tis sun8hkes
points = [px py repmat(sxy, sum(binary_img(:)), 1) pz];                                 %kataskeush output me to epi8umhto format

end

