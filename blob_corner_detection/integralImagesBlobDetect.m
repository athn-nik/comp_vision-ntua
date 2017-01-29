function [ blob_binary_img, R ] = integralImagesBlobDetect( I, sigma, th_blob )                                                                                  
    %I=rgb2gray(I);
    n = 2*ceil(3*sigma) + 1;                                                                    %kataskeuh twn Lxx, Lyy kai Lxy me box filters proseggistika
    s_large = 4*floor(n/6) + 1;                                                                 %upologmos diastasewn twn box filters
    s_small = 2*floor(n/6) + 1;
    Lxx = (1/(s_large*s_small*4))*(integral_image_local_sum(I,3*s_small,s_large, 0, 0)...       %upologismos kai kanonikopoihshs tou Lxx me box filter, xrhsimopoioume
        - 3*integral_image_local_sum(I,s_small,s_large, 0, 0));                                 %para8uro pou perilamvanei ta kentrika pixel kai ta afairoume sth sunexeia
    Lyy = (1/(s_large*s_small*4))*(integral_image_local_sum(I,s_large,3*s_small, 0, 0)...       %omoiws gia to Lyy
        - 3*integral_image_local_sum(I,s_large,s_small, 0, 0));
    Lxy = (1/(s_small*s_small*4))*(integral_image_local_sum(I,s_small,s_small, s_small+1, s_small+1)...       %omoiws gia to Lxy
        + integral_image_local_sum(I,s_small,s_small, -s_small-1, -s_small-1)...
        - integral_image_local_sum(I,s_small,s_small, s_small+1, -s_small-1)...
        - integral_image_local_sum(I,s_small,s_small, -s_small-1, s_small+1));
    R = Lxx.*Lyy - 0.81*Lxy.^2;
    Rmax = max(R(:));                                           %megisth timh krithriou
    ns = ceil(3*sigma)*2 + 1;
    B_sq = strel('disk',ns);                                    %kataskeuh purhna gia dilate ths eikonas
    Cond1 = (R==imdilate(R,B_sq));                              %euresh twn shmeiwn pou einai topika megista
    blob_binary_img = Cond1 & R > th_blob*Rmax;                 %dexomaste mono topika megista kai osa pernane to katofli th_blob
    
end

