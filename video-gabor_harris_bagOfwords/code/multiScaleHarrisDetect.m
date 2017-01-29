function [ points ] = multiScaleHarrisDetect( I, sxy_0, st, k, th, b, s, N )
    I = I.vid;
    point_matrix = zeros(size(I,1), size(I,2), size(I,3), N);                                     %orismos pinaka gia tis gwnies ths eikonas
    laplacian_matrix = zeros(size(I,1), size(I,2), size(I,3), N);                                  %kai tou laplacian of gaussian (h trith diastash einai osh kai ta scales)

    for i = 1:N
        sxy = s^(i-1)*sxy_0;                                                         %upologismos neou sigma kai ro ana kainourgia klimaka
        [~, point_matrix(:,:,:,i)] = videoHarrisDetector(I, sxy, st, k, th, b);    %entopismos harris me to standard algori8mo            
        n=ceil(3*sxy)*2+1;                                                            %upologismos mege8ous filtrou pou antistoixei sth do8eisa diaspora
        LaplacianG = fspecial('log',[n n],sxy);                                       %kernel laplacian
        temp = fspecial('log',[1 n],sxy);                                       %kernel laplacian
        LaplacianG_time(1,1,1:numel(temp)) = temp;
        laplacian_matrix(:,:,:,i) = (sxy^3)*abs(imfilter(imfilter(I,LaplacianG,'replicate'), LaplacianG_time, 'replicate'));    %upologismos kanonikopoihmenhs laplacian ane3arthths apo th klimaka
    end
    peak_laplacian_points = laplacian_matrix == imdilate(laplacian_matrix, ones(1,1,1,3));    %efarmogh dilation sth diastash twn scales (4h diastash) wste na entopisoume to megisto se
    accepted_corners = point_matrix == peak_laplacian_points & (point_matrix == 1);       %geitonia (prohgoumenhs kai epomenhs klimakas)
    points = [];
    for i = 1:N
        sxy = s^(i-1)*sxy_0;                                                                         %upologismos scale autwn twn shmeiwn
        [py, px, pz] = ind2sub(size(accepted_corners(:,:,:,i)),find(accepted_corners(:,:,:,i)));                              %vriskoume ta indexes twn shmeiwn pou plhroun tis sun8hkes
        points = [points; px py repmat(sxy, numel(px), 1) pz];                                 %kataskeush output me to epi8umhto format
    end
end
