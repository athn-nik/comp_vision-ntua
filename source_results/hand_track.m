close all;
clearvars;
clc;

%%
addpath(pwd);
[M, S] = init_skin_filter();    %kataskeuh filtrou dermatos opws egine sto meros 1

cd Chalearn;
names = dir('*.png');           %dhmiourgia listas olwn twn arxeiwn eikonas png
numIcons = length(names);       %upologismos ari8mou frame
I = zeros(480,640,numIcons);    %arxikopoihsh pinaka dedomenwn video
file_names = char(names(:).name);   %kataskeuh pinaka char me ta onomata
[~, order] = sortrows(ParseFileName2Num(file_names));
names = names(order);           %allagh seiras frame

for k = 1:numIcons
  I(:,:,k) = im2double(rgb2gray(imread(names(k).name)));   %fortwsh arxeiwn eikonas kai metatroph se gkri klimaka
end
first_image = imread(names(1).name);   %fortwsh prwths eikonas se egxrwmh morfh
cd ..;

cd ChalearnUser;
first_kinect = repmat(uint8(imread('U1.png')),1,1,3);
cd ..;

epsilon = linspace(0.01, 0.1, 4);
pyramid_scales = 2:4;
ro = linspace(2.5, 12.5, 7);
energy_thresh= linspace(0.15, 0.6, 5);
max_dist_invalid = 27;

test_cases = size(epsilon,2)*size(pyramid_scales,2)*size(ro,2)*size(energy_thresh,2);
results = repmat(struct('dist_array',zeros(1, numIcons), 'max_dist',0,...
    'aver_dist',0, 'valid',true, 'epsilon', 0, 'ro', 0, 'pyramid_scales', 0, 'energy_thresh', 0), 1, test_cases);

center = struct('x',{279 282 288 300 308 319 328 332 331 330 323 320 321 325 330 331 328 326 324 326 329 332 330 330 327 326 330 332 334 334 332 329 325 323 313 310 302 298 293 292 291 291 292 292 291 289 288 287 287 288 289 291 293 295 296 295 295 292 287 274 266},...
'y',{293 298 294 281 271 249 228 221 216 216 218 219 218 218 213 214 215 216 216 214 213 211 214 216 217 219 218 217 215 216 222 226 238 245 262 273 293 304 320 328 340 342 347 347 346 347 346 346 346 345 346 347 346 346 346 347 348 344 343 325 315});

disp('Searching for best hand detection...');
msg = '';
idx = 0;

tic;

for i = 1:size(epsilon,2)
    for j=1:size(pyramid_scales,2)
        for k=1:size(ro,2)
            for l=1:size(energy_thresh,2)
                idx = idx+1;
                
                coord = boundingBox(first_image.*first_kinect, M, S);   %upologismos plaisiou prwswpou
                coord = coord + int16([-10 -10 20 20]);         %au3hsh plaisiou me stoxo thn apofugh la8wn

                zer_d = zeros(coord(4)+1, coord(3)+1);    %arxikopoihsh arxikwn sun8hkwn optikhs rohs
                handx = double(coord(1));                 %arxikopoihsh dianusmatos 8eshs proswpou
                handy = double(coord(2));

                for m = 1:numIcons - 1
                    Iw1 = get_box(I(:,:,m), coord);      %epilogh perioxhs xeriou sth prwth eikona kai antistoixwn
                    Iw2 = get_box(I(:,:,m+1), coord);    %stoixeiwn apo th deuterh eikona

                    %[dx, dy] = LK(Iw1, Iw2, ro, epsilon, zer_d, zer_d);
                    [dx, dy] = LK_Pyramid(Iw1, Iw2, ro(k), epsilon(i),pyramid_scales(j));     %epilogh epi8umhtou algori8mou (aplou h puramidas) 

                    [displ_x,displ_y] = displ(dx,dy,energy_thresh(l));    %upologismos telikou dianismatos metatopishs
                    handx = handx + displ_x;             %ananewsh dianusmatos 8eshs proswpou
                    handy = handy + displ_y;
                    coord(1) = int16(handx);             %ananewsh 8eshs suntetagmenwn plaisiou
                    coord(2) = int16(handy);
                    
                    cent1 = RectCenter(handx, handy, coord);
                    cent2 = [center(m).x center(m).y];
                    dist = CoordDistance(cent1, cent2);
                    if dist > max_dist_invalid
                        results(idx).valid = false;
                        break;
                    end
                    results(idx).dist_array(m) = dist;
                end
                
                results(idx).pyramid_scales = pyramid_scales(j);
                results(idx).epsilon = epsilon(i);
                results(idx).ro = ro(k);
                results(idx).energy_thresh = energy_thresh(l);
                
                time = toc;
                eta_time_total = (time * test_cases) / idx;
                eta_time = eta_time_total * ((test_cases - idx)/ test_cases);
                eta_mins = floor(eta_time / 60);
                eta_secs = ceil(eta_time - eta_mins * 60);
                
                fprintf(repmat('\b',1,numel(msg)));
                if idx > 8
                    fprintf('Percentage complete: %.2f%%\nETA: %d minutes, %d seconds', (idx*100)/test_cases, eta_mins, eta_secs);
                    msg = sprintf('Percentage complete: %.2f%%\nETA: %d minutes, %d seconds', (idx*100)/test_cases, eta_mins, eta_secs);
                else
                    fprintf('Percentage complete: %.2f%%\nETA: - minutes, - seconds', (idx*100)/test_cases);
                    msg = sprintf('Percentage complete: %.2f%%\nETA: - minutes, - seconds', (idx*100)/test_cases);
                end
            end
        end
    end
end
fprintf('\n');

%%
disp('Analysing results...');
rank = zeros(1, test_cases);
for i=1:test_cases
    dist_matrix = results(i).dist_array;
    results(i).max_dist = max(dist_matrix);
    results(i).aver_dist = mean(dist_matrix);
    if results(i).valid
        rank(i) = results(i).max_dist + results(i).aver_dist;
    else
        rank(i) = inf;
    end
end

[~, best_order] = sort(rank);

disp('Printing best results...');
for k = 1:8
best_result = best_order(k);
fprintf('Result rank: %d\n', k);
fprintf('Epsilon = %f, Ro = %f, Pyramid Levels = %d, Energy Threshold = %f\n\n', results(best_result).epsilon, results(best_result).ro,...
    results(best_result).pyramid_scales, results(best_result).energy_thresh);
end

disp('Saving Results');
save('results.mat', 'results');

ro_rank = zeros(1, size(ro,2));
epsilon_rank = zeros(1, size(epsilon,2));
energy_rank = zeros(1, size(energy_thresh,2));
scales_rank = zeros(1, size(pyramid_scales,2));

for i=1:test_cases
    if results(i).valid
        ro_idx = find(ro == results(i).ro);
        ro_rank(ro_idx) = ro_rank(ro_idx) + 1 / rank(i);
        epsilon_idx = find(epsilon == results(i).epsilon);
        epsilon_rank(epsilon_idx) = epsilon_rank(epsilon_idx) + 1 / rank(i);
        energy_idx = find(energy_thresh == results(i).energy_thresh);
        energy_rank(energy_idx) = energy_rank(energy_idx) + 1 / rank(i);
        scales_idx = find(pyramid_scales == results(i).pyramid_scales);
        scales_rank(scales_idx) = scales_rank(scales_idx) + 1 / rank(i);
    end
end
ro_rank = ro_rank ./ max(ro_rank);
figure();
plot(ro, ro_rank);
xlabel('ro');
ylabel('rank');
title('Ikanothta entopismou sunarthsei tou ro');

epsilon_rank = epsilon_rank ./ max(epsilon_rank);
figure();
plot(epsilon, epsilon_rank);
xlabel('epsilon');
ylabel('rank');
title('Ikanothta entopismou sunarthsei tou epsilon');

energy_rank = energy_rank ./ max(energy_rank);
figure();
plot(energy_thresh, energy_rank);
xlabel('energy threshold');
ylabel('rank');
title('Ikanothta entopismou sunarthsei tou katwfliou energeias');

scales_rank = scales_rank ./ max(scales_rank);
figure();
plot(pyramid_scales, scales_rank);
xlabel('pyramid scales');
ylabel('rank');
title('Ikanothta entopismou sunarthsei twn klimakwn');