function [ dist ] = CoordDistance( cent1, cent2 )

dist = sum((cent1-cent2).^2).^0.5;

end