function [ sub_matrix ] = get_box( I, coord )  %sunarthsh epiloghs tmhmatos eikonas
coord = int16(coord);                          %dexetai ws parametro tis suntetagmenes tou plaisiou pou 8eloume kai tis diastaseis tou
delta_x = coord(2):coord(2)+coord(4);          %upologismos epi8umhtwn shmeiwn
delta_y = coord(1):coord(1)+coord(3);
sub_matrix = I(delta_x, delta_y,:);            %epistrofh upopinaka
end

