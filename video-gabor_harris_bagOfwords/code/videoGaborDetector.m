function [ points,H, binary_img ] = videoGaborDetector( I, sxy, tau, th, neighbor_sphear_kernel_size )

I = im2double(I);                                                           %metatroph eikonas se double
%I = I - repmat(mean(mean(I)), size(I,1), size(I,2));

nxy=ceil(3*sxy)*2+1;                                                        %upologismos mege8ous para8urou xwrikou gaussian
gxy = fspecial('gaussian',[nxy nxy],sxy);                                   %upologismos gaussian filtrou 2D (xwriko)

Igaussian = imfilter(I, gxy, 'replicate');                                  %efarmozoume to filtro gaussian stis diastaseis xwrou
wmega = 4 / tau;                                                            %upologismos suxnothtas gabor
nt = ceil(2*tau);                                                           %upologismos akraias timhs tou t sto gabor filtro

t = -nt:nt;                                                                 %euros xronou sto gabor filtro
hev = -cos(2*pi*t*wmega).*exp((-t.^2)/(2*tau^2));                             %upologismos kroustikhs apokrishs sto gabor
hod = -sin(2*pi*t*wmega).*exp((-t.^2)/(2*tau^2));

hev_z(1,1,1:2*nt+1) = hev/norm(hev, 1);                                     %kanonikopoihsh kai topo8ethsh ws pros diastash z
hod_z(1,1,1:2*nt+1) = hod/norm(hod, 1);

%hev_z = hev_z - mean(hev_z);                                                %afairesh dc sunistwsas apo th kroustikh apokrish me to sunhmitono

%auto htan aparaithto dioti diaforetika h e3odos ths suneli3hs tou hev me to video e3artontan apo th fwteinothta kai oxi apo tis apotomes kinhseis

H1 = imfilter(Igaussian, hev_z, 'replicate');                               %efarmogh gabor filtrwn
H2 = imfilter(Igaussian, hod_z, 'replicate');

%H1 = convn(Igaussian, hev_z);                                              %enalaktika ginetai kai me suneli3h
%H2 = convn(Igaussian, hod_z);

H = H1.^2 + H2.^2;                                                          %upologismos energeias

b = ceil(neighbor_sphear_kernel_size);
[x,y,z] = ndgrid(-b:b);                                                                 %dhmiourgia grid 3d bxbxb diastashs
B = strel(sqrt(x.^2 + y.^2 + z.^2) <=b);                                                %kataskeuh sfairas 3d kernel geitonias

Hmax = max(H(:));
Cond1 = (H == imdilate(H, B));                                                          %efarmogh kernel gia thn euresh twn topikwn megistwn shmeiwn sto H
binary_img = Cond1 & H > th*Hmax;                                                       %xwroxronika kai epilogh twn megistwn me megalh timh apoluta

[py, px, pz] = ind2sub(size(binary_img),find(binary_img));                              %vriskoume ta indexes twn shmeiwn pou plhroun tis sun8hkes
points = [px py repmat(sxy, sum(binary_img(:)), 1) pz];                                 %kataskeush output me to epi8umhto format

end

