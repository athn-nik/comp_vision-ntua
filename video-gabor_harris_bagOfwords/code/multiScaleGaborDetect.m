function [ points ] = multiScaleGaborDetect( I, sxy_0, st, th, b, s, N )
    I = I.vid;
    point_matrix = zeros(size(I,1), size(I,2), size(I,3), N);                                     %orismos pinaka gia tis gwnies ths eikonas
    Energy_matrix = zeros(size(I,1), size(I,2), size(I,3), N);                                  %kai tou laplacian of gaussian (h trith diastash einai osh kai ta scales)

    for i = 1:N
        sxy = s^(i-1)*sxy_0;                                                         %upologismos neou sigma kai ro ana kainourgia klimaka
        [~, Energy_matrix(:,:,:,i), point_matrix(:,:,:,i)] = videoGaborDetector(I, sxy, st, th, b);    %entopismos harris me to standard algori8mo            
        Energy_matrix(:,:,:,i) = Energy_matrix(:,:,:,i).*s^i;
    end
    peak_energy_points = Energy_matrix == imdilate(Energy_matrix, ones(1,1,1,3));    %efarmogh dilation sth diastash twn scales (4h diastash) wste na entopisoume to megisto se
    accepted_corners = point_matrix == peak_energy_points & (point_matrix == 1);       %geitonia (prohgoumenhs kai epomenhs klimakas)
    points = [];
    for i = 1:N
        sxy = s^(i-1)*sxy_0;                                                                         %upologismos scale autwn twn shmeiwn
        [py, px, pz] = ind2sub(size(accepted_corners(:,:,:,i)),find(accepted_corners(:,:,:,i)));                              %vriskoume ta indexes twn shmeiwn pou plhroun tis sun8hkes
        points = [points; px py repmat(sxy, numel(px), 1) pz];                                 %kataskeush output me to epi8umhto format
    end
end
