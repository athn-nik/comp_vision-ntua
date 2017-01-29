function [ Output_img ] = generate_pyramids( I, pyr_levels )   %sunarthsh upologismou gkaousianwn puramidwn
Output_img = cell(1, pyr_levels);                              %kataskeuh domhs cell me skopo thn ana8esh se ka8e cell mias eikonas (ena epipedo puramidas)
Output_img{1} = I;                                             %to prwto epipedo ths puramidas einai h arxikh eikona
for i = 2:pyr_levels                                           %gia ta epomena epipeda efarmozoume th sunarthsh impyramid h opoia afou efarmosei ena low pass filtro
    Output_img{i} = impyramid(Output_img{i-1}, 'reduce');      %(kata proseggish gkaousiano) meiwnei tis diastaseis ths eikonas sto miso
end
end
