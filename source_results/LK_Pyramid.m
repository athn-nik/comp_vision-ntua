function [ d_x,d_y ] = LK_Pyramid( I1, I2, rho, epsilon, pyr_levels )  %polu klimakwth ulopoihsh lukas kanade meta3u 2 eikokwn
I1_pyramids = generate_pyramids(I1, pyr_levels);    %dhmiourgia gkaousianwn puramidwn gia th prwth eikona
I2_pyramids = generate_pyramids(I2, pyr_levels);    %dhmiourgia gkaousianwn puramidwn gia th prwth eikona
d_x_output = 0; d_y_output = 0;
maximum_rho = rho;                                  %apo8hkeush timhs rho gia allagh mege8ous kernel gkaousianou filtrou
for i = pyr_levels:-1:1
    if i == pyr_levels
        d_x_input = zeros(size(I1_pyramids{i}, 1), size(I1_pyramids{i}, 2));    %gia th prwth eikona e3agwgh diastasewn kai kataskeuh mhdenikwn
        d_y_input = zeros(size(I1_pyramids{i}, 1), size(I1_pyramids{i}, 2));    %arxikwn sun8hkwn
    else
        d_x_input = 2*imresize(d_x_output,'OutputSize', size(I1_pyramids{i}));  %se oles tis alles periptwseis prosarmogh ths optikhs rohs sth nea klimaka
        d_y_input = 2*imresize(d_y_output,'OutputSize', size(I1_pyramids{i}));  %me au3hsh diastasewn kai metrou
    end
    rho = maximum_rho/(2^(i-1));              %upologismos neou mege8ous kernel gkaousianou filtrou
    [ d_x_output, d_y_output ] = LK(I1_pyramids{i}, I2_pyramids{i}, rho, epsilon, d_x_input, d_y_input);     %efarmogh me8odou lukas kanade sto epipedo pou vriskomaste
end
d_x = d_x_output;      %apo8hkeush telikhs timhs dianusmatikou pediou
d_y = d_y_output;
end
