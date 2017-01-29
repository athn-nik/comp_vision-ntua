function[BOF_tr]=myBofVW_train_only(data_train, c_number)
    %%concat features in one vector and  kmeans i n 50% in this vector
    train_matrix = cell2mat(rot90(data_train));
    
    BOF_tr = zeros(size(data_train,2), c_number);
    
    rand_idx = randperm(size(train_matrix, 1));
    rand_idx = sort(rand_idx(1:round(end/2)));
    data_matrix_subset = train_matrix(rand_idx, :);
    %kmeans for centers
    [~, C] = kmeans(data_matrix_subset, c_number);    
    
    for i = 1:size(data_train,2)
        H = zeros(1,size(data_train{i}, 1));
        for j = 1:size(data_train{i}, 1)
            point_matrix = repmat(data_train{i}(j,:), size(C,1), 1);
            dist = sqrt(sum((C-point_matrix).^2,2));
            [~, min_dist_idx] = min(dist);
            H(j) = min_dist_idx;
        end
        BOF_tr(i, :) = histc(H,1:c_number);
        BOF_tr(i, :)=(BOF_tr(i, :)/(norm( BOF_tr(i, :))+eps));
    end
    
end
