function [ blob_binary_img, R ] = BlobDetect( I, sigma, th_blob, visualize )
    n=ceil(3*sigma)*2+1;
    Gaussian=fspecial('gaussian',[n n],sigma);                  %orismos gaussian kernel
    Lxx_kernel = conv2(Gaussian, [1 -2 1]);                     %isxuei oti conv([-1 1], [-1 1]) = [1 -2 1]
    Lyy_kernel = conv2(Gaussian, [1 -2 1]');                    %idios metasxhmatismos gia a3ona y
    Lxy_kernel = conv2(conv2(Gaussian, [-1 0 1]), [-1 0 1]');   %logw asummetrias sto kernel [-1 1] xrhsimopoioume to [-1 0 1] gia to Lxy
    Lxx = imfilter(I, Lxx_kernel, 'replicate');                 %efarmogh kernel upologismos smoothing kai 2hs paragwgou kateu8eian
    Lyy = imfilter(I, Lyy_kernel, 'replicate');                 %euresh upoloipwn paragwgwn
    Lxy = imfilter(I, Lxy_kernel, 'replicate');
    R = Lxx.*Lyy - Lxy.^2;                                      %orizousa pinaka hessian

    Rmax = max(R(:));                                           %megisth timh krithriou
    ns = ceil(3*sigma)*2 + 1;
    B_sq = strel('disk',ns);                                    %kataskeuh purhna gia dilate ths eikonas
    Cond1 = (R==imdilate(R,B_sq));                              %euresh twn shmeiwn pou einai topika megista
    blob_binary_img = Cond1 & R > th_blob*Rmax;                 %dexomaste mono topika megista kai osa pernane to katofli th_blob

    [blob_y, blob_x] = find(blob_binary_img);                    %euresh suntetagmenwn apo th diadikh eikona
    points = [blob_x  blob_y  repmat(sigma, sum(blob_binary_img(:)), 1)];     %kataskeuh pinaka gia eisodo sth sunarthsh
                                                                                    %interest_points_visualization
    if(visualize == 1)
        interest_points_visualization(I, points);
    end
end

