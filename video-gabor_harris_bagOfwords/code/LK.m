function [d_x,d_y] = LK(I1, I2, rho, epsilon, d_x0, d_y0)  %sunarthsh lukas kanade
    [x_0, y_0] = meshgrid(1:size(I1,2),1:size(I1,1));      %kataskeuh arxikou grid diastasewn eikonwn
    [gradIw1x, gradIw1y] = gradient(I1);                   %upologismos paragwgwn prwths eikonas
    d_x = d_x0;                                            %ana8esh arxikwn sun8hkwn dianusmatikou pediou
    d_y = d_y0;
    n = ceil(3*rho)*2 + 1;
    Gaussian = fspecial('gaussian',[n n], rho);        %dhmiourgia kernel gkaousianou filtrou

    for q = 1:16
        x_i = x_0 + d_x;                                   %upologismos newn suntetagmenwn gia ka8e pixel
        y_i = y_0 + d_y;                                   %me th xrhsh tou dianusmatikou pediou
        Id1 = interp2(I1,x_i,y_i,'linear',0);              %upologismos newn deigmatwn eikonas I1(x + d)
        E = I2 - Id1;                                      %upologismos xronikhs paragwgou eikonas I2(x) - I1(x + d)

        A1 = interp2(gradIw1x,x_i,y_i,'linear',0);         %upologismos newn deigmatwn merikwn paragwgwn
        A2 = interp2(gradIw1y,x_i,y_i,'linear',0);

        A1A2G = imfilter(A1.*A2, Gaussian, 'symmetric');               %efarmogh me8odou lukas kanade gia ka8e pixel
        A1G2 = imfilter(A1.*A1, Gaussian, 'symmetric') + epsilon;      %kai tautoxrona efarmogh gkaousianou kernel gia ton sunupologismo
        A2G2 = imfilter(A2.*A2, Gaussian, 'symmetric') + epsilon;      %twn timwn twn geitonikwn stoixeiwn
        A1EG = imfilter(A1.*E, Gaussian, 'symmetric');
        A2EG = imfilter(A2.*E, Gaussian, 'symmetric');

        temp = A1G2 .* A2G2 - A1A2G.*A1A2G;                            %orizousa pinaka
        ux = (A2G2.*A1EG - A1A2G.*A2EG) ./ temp;                       %upologismos u dianusmatos
        uy = (A1G2.*A2EG - A1EG.*A1A2G) ./ temp;

        d_x = d_x + ux;                                     %ananewsh pediou optikhs rohs
        d_y = d_y + uy;
    end
end

