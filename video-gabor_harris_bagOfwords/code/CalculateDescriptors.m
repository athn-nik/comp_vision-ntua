function [ descriptors ] = CalculateDescriptors( I, points, isHOG, neighbor_size, nbins, desc_cells_per_dim )

I = im2double(I);
dx = zeros(size(I,1), size(I,2), size(I,3));
dy = zeros(size(I,1), size(I,2), size(I,3));
d_zero = zeros(size(I,1), size(I,2));

if isHOG
    [Ix, Iy] = gradient(I);
else
    for i = 1:size(I,3) - 1
        [dx(:,:,i), dy(:,:,i)] = LK(I(:,:,i), I(:,:,i+1), 2, 0.01, d_zero, d_zero);
    end
end

descriptors = cell(size(points, 1), 1);
desc_window_dist = floor(ceil(neighbor_size) / 2);

for i = 1:size(points,1)
    px = points(i, 1);
    py = points(i, 2);
    frame = points(i, 4);
    if (frame == size(I,3) && isHOG == 0)
        continue;
    end
    
    if px - desc_window_dist < 1
        lower_x_bound = 1;
    else
        lower_x_bound =  px - desc_window_dist;
    end
    if px + desc_window_dist > size(I,2)
        upper_x_bound = size(I,2);
    else
        upper_x_bound =  px + desc_window_dist;
    end
    
    if py - desc_window_dist < 1
        lower_y_bound = 1;
    else
        lower_y_bound =  py - desc_window_dist;
    end
    if py + desc_window_dist > size(I,1)
        upper_y_bound = size(I,1);
    else
        upper_y_bound =  py + desc_window_dist;
    end
    
    if isHOG
        Gx = Ix(lower_y_bound: upper_y_bound, lower_x_bound: upper_x_bound, frame);
        Gy = Iy(lower_y_bound: upper_y_bound, lower_x_bound: upper_x_bound, frame);
    else
        Gx = dx(lower_y_bound: upper_y_bound, lower_x_bound: upper_x_bound, frame);
        Gy = dy(lower_y_bound: upper_y_bound, lower_x_bound: upper_x_bound, frame); 
    end
    desc_dim = [desc_cells_per_dim desc_cells_per_dim];
    descriptors{i} = OrientationHistogram(Gx, Gy, nbins, desc_dim, 0, 0);
end

descriptors = cell2mat(descriptors(~cellfun('isempty',descriptors)));

end

