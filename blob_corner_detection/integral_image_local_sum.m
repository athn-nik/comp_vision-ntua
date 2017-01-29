function [ S ] = integral_image_local_sum( I, nx, ny, offset_x, offset_y )  %upologismos topikwn a8roismatwn me integral images
    assert(mod(nx,2) ~= 0 & nx > 1 & mod(ny,2) ~= 0 & ny > 1);              %dexomaste mono perito ari8mo diastasewn para8urou wste na mporoume
    dx = (nx + 1)/2 - 1;                                                    %na antistoixhsoume kentriko pixel sto para8uro
    dy = (ny + 1)/2 - 1;
    assert(abs(offset_x) < nx+2 & abs(offset_y) < ny+2); 
    I = padarray(I, [5*dy 5*dx]);                                           %to d einai h mish diastash tou para8urou mas xwris to kentriko pixel
    I = I(1+2*dy:end, 1+2*dx:end);                                          %au3anoume th diastash ths eikonas mas me zero padding kai afairoume ta stoixeia pou den xreiazomaste
    S_mean = cumsum(cumsum(I, 1),2);                                        %wste to susswreutiko a8roisma gia ton upologismo ths integral image na dwsei times pera apo ta oria ths eikonas
    S_padded = padarray(S_mean, [2*dy 2*dx]);                               %gia ton upologismo twn topikwn a8roismatwn sta peri8wria ths eikonas
    S_A = circshift(S_padded, [(dy + 1) (dx + 1)]);                                 %kuklikes olis8hseis gia thn euresh tou Sa Sb Sc kai Sd afou prwta ginei au3hsh diastasewn me zero padding
    S_C = circshift(S_padded, [-dy -dx]);
    S_B = circshift(S_padded, [(dy + 1) -dx]);
    S_D = circshift(S_padded, [-dy (dx + 1)]);
    S = S_A + S_C - S_B - S_D;                                              %katallhlh pros8esh - afairesh twn pinakwn Sa Sb Sc kai Sd gia ton parallhlo upologismo olwn twn topikwn a8roismatwn
    S = S(1+5*dy-offset_y:end-7*dy-offset_y,...
        1+5*dx-offset_x:end-7*dx-offset_x);                                 %afairesh tou zero padding pou eisagame kai efarmogh offset
end