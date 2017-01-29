function [  ] = DispFrame( I, coord, fig_index, save, path )
currentFigure = figure(fig_index);
imshow(I,[]);                  %apeikonish prwtou frame me plaisio
hold on;
rect = rectangle('Position', coord);
set(rect, 'EdgeColor', 'g');
hold off;

if save
    print(currentFigure, path, '-dpng', '-r0');
end

end

