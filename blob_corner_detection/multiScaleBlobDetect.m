function [  ] = multiScaleBlobDetect( Iorig, sigma0, th_blob, s, N, integral )
    I = im2double(rgb2gray(Iorig));
    blob_matrix = zeros(size(I,1), size(I,2), N);                                     %orismos pinaka gia ta blob ths eikonas
    R_matrix = zeros(size(I,1), size(I,2), N);                                  %kai tou krithriou R

    for i = 1:N
        sigma = s^(i-1)*sigma0;                                                         %upologismos neou sigma kai ro ana kainourgia klimaka
        if(integral == 0)
            [blob_matrix(:,:,i), R_matrix(:,:,i)] = BlobDetect(I, sigma, th_blob, 0);     %entopismos blob me to standard algori8mo
        else
            [blob_matrix(:,:,i), R_matrix(:,:,i)] = integralImagesBlobDetect(I, sigma, th_blob);
        end
    end
    peak_R_points = R_matrix == imdilate(R_matrix, ones(1,1,3));    %efarmogh dilation sth diastash twn scales (z) wste na entopisoume to megisto se
    accepted_blobs = blob_matrix == peak_R_points & (blob_matrix == 1);       %geitonia (prohgoumenhs kai epomenhs klimakas)
    points = [];
    for i = 1:N
        [blob_y, blob_x] = find(accepted_blobs(:,:,i));                                           %metatroph diadikhs eikonas me tis gwnies se pinaka diastasewn pixel
        sigma = s^(i-1)*sigma0;                                                                         %upologismos scale autwn twn shmeiwn
        points = [points ; blob_x  blob_y  repmat(sigma, sum(sum(accepted_blobs(:,:,i))), 1)];    %kataskeuh domhs gia thn eisodo ths sunarthshs interest_points_visualization
    end
    interest_points_visualization(Iorig, points);                                       %optikopoihsh apotelesmatwn
end

