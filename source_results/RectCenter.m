function [ center ] = RectCenter( x, y, coord )
center = [0 0];
center(1) = x + coord(3) / 2;
center(2) = y + coord(4) / 2;
end