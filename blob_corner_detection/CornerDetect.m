function [ corner_binary_img, points ] = CornerDetect( I, sigma, ro, k, th_corner, visualize )
    %Igrayscale = im2double(rgb2gray(I)); %  eisodos hdh se double grayscale gia epipleon taxuthta
    n1=ceil(3*sigma)*2+1;
    n2=ceil(3*ro)*2+1;
    GaussianS=fspecial('gaussian',[n1 n1],sigma);
    Is = imfilter(I, GaussianS);
    [Isx, Isy] = gradient(Is);
    GaussianP=fspecial('gaussian',[n2 n2],ro);
    J1=imfilter(Isx.*Isx, GaussianP);
    J2=imfilter(Isx.*Isy, GaussianP);
    J3=imfilter(Isy.*Isy, GaussianP);
    Lplus=0.5*(J1+J3+sqrt((J1-J3).^2+4*(J2.^2)));
    Lminus=0.5*(J1+J3-sqrt((J1-J3).^2+4*(J2.^2)));
    R=Lminus.*Lplus-k*(Lminus+Lplus).^2;                    %upologismou krithriou gwniothtas apo tis times twn idiotimwn
    Rmax = max(R(:));
    ns = ceil(3*sigma)*2 + 1;
    B_sq = strel('disk',ns);
    Cond1 = (R==imdilate(R,B_sq));
    corner_binary_img = Cond1 & R > th_corner*Rmax;                    %epilogh pixel pou antistoixoun se gwnia ta opoia ikanopoioun tis sun8hkes
    
    [corner_y, corner_x] = find(corner_binary_img);                    %euresh suntetagmenwn apo th diadikh eikona
    points = [corner_x  corner_y  repmat(sigma, sum(corner_binary_img(:)), 1)];     %kataskeuh pinaka gia eisodo sth sunarthsh
                                                                                    %interest_points_visualization
    if(visualize == 1)
        interest_points_visualization(I, points);
    end
end

