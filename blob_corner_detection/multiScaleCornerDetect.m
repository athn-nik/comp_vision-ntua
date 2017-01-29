function [  ] = multiScaleCornerDetect( Iorig, sigma0, ro0,k,th_corner, s, N )
    I = im2double(rgb2gray(Iorig));
    corner_matrix = zeros(size(I,1), size(I,2), N);                                     %orismos pinaka gia tis gwnies ths eikonas
    laplacian_matrix = zeros(size(I,1), size(I,2), N);                                  %kai tou laplacian of gaussian (h trith diastash einai osh kai ta scales)

    for i = 1:N
        sigma = s^(i-1)*sigma0;                                                         %upologismos neou sigma kai ro ana kainourgia klimaka
        ro = s^(i-1)*ro0;                                                               %h klimaka diaforishs kai oloklhrwshs metavaletai kata s ana epanalhpsh
        corner_matrix(:,:,i) = CornerDetect(I, sigma, ro, k, th_corner, 0);             %entopismos gwniwn me to standard algori8mo
        n=ceil(3*sigma)*2+1;                                                            %upologismos mege8ous filtrou pou antistoixei sth do8eisa diaspora
        LaplacianG = fspecial('log',[n n],sigma);                                       %kernel laplacian
        laplacian_matrix(:,:,i) = (sigma^2)*abs(imfilter(I,LaplacianG,'replicate'));    %upologismos kanonikopoihmenhs laplacian ane3arthths apo th klimaka
    end
    peak_laplacian_points = laplacian_matrix == imdilate(laplacian_matrix, ones(1,1,3));    %efarmogh dilation sth diastash twn scales (z) wste na entopisoume to megisto se
    accepted_corners = corner_matrix == peak_laplacian_points & (corner_matrix == 1);       %geitonia (prohgoumenhs kai epomenhs klimakas)
    points = [];
    for i = 1:N
        [corner_y, corner_x] = find(accepted_corners(:,:,i));                                           %metatroph diadikhs eikonas me tis gwnies se pinaka diastasewn pixel
        sigma = s^(i-1)*sigma0;                                                                         %upologismos scale autwn twn shmeiwn
        points = [points ; corner_x  corner_y  repmat(sigma, sum(sum(accepted_corners(:,:,i))), 1)];    %kataskeuh domhs gia thn eisodo ths sunarthshs interest_points_visualization
    end
    interest_points_visualization(Iorig, points);                                       %optikopoihsh apotelesmatwn
end