function [displ_x,displ_y] = displ( d_x, d_y, threshold ) %sunarthsh upologismou telikou dianismatos metatopishs
energy = d_x.^2 + d_y.^2;                      %apo to dianismatiko pedio optikhs rohs
d_filter = energy/max(energy(:)) > threshold;       %afou upologisoume thn energeia th kanonikopoioume kai aporriptoume ta stoixeia me mikrh energeia
dx = -d_x .* d_filter;                         %efarmozoume th maska me ta stoixeia pou aporiptontai sto pedio
dy = -d_y .* d_filter;                         %tautoxrona allazoume to proshmo tou gia na vroume th pragmatikh metatwpish
                                               %dioti h me8odos lukas kanade upologizei to -d
displ_x = sum(dx(:)) / sum(d_filter(:));       %upologismos mesou orou twn shmeiwn pou menoun
displ_y = sum(dy(:)) / sum(d_filter(:));
end

