close all;
clearvars;
clc;

videoFolder = './samples';
preprocessedFolder = './videos';
outputFolder = './output';

nframes = 200;
n_centers = 48;
assert(nframes > n_centers / 2);                %elenxos giati gia liga frames endexetai na kollhsei to bagofwords epeidh ta clusters einai parapanw apo ta shmeia anixneushs


rmdir(preprocessedFolder,'s')
if ~exist(preprocessedFolder,'dir')
    mkdir(preprocessedFolder);
    [fileList, labels] = getAllFiles(videoFolder);
    for i = 1:size(fileList, 1)
        vid = readVideo(fileList{i,:}, nframes, 0);
        save(strcat(preprocessedFolder, '/', int2str(i), '.mat'),'vid');
    end
else
    [~, labels] = getAllFiles(videoFolder);
end

if ~exist(outputFolder,'dir')
    mkdir(outputFolder);
end

sxy = 2;
st_gabor = 1.49;
st_harris = 0.7;
k = 0.048;
th_harris = 0.0005;
th_gabor= 0.05;
b = 2;
%numel() no of elements labels gia na kswrw video
data_train_hof_harris = cell(1, numel(labels));
data_train_hog_harris = cell(1, numel(labels));

data_train_hof_gabor = cell(1, numel(labels));
data_train_hog_gabor = cell(1, numel(labels));

msg = '';
test_cases = numel(labels);
tic;

for i = 1:numel(labels)
    cd(preprocessedFolder);
    I = load(strcat(num2str(i), '.mat'));
    cd ..;
    points = videoHarrisDetector(I.vid, sxy, st_harris, k, th_harris, b);
    data_train_hof_harris{i} = CalculateDescriptors(I.vid, points, 0, 4*sxy, 8, 3);
    data_train_hog_harris{i} = CalculateDescriptors(I.vid, points, 1, 4*sxy, 8, 3);
    data_train_hof_hog_harris{i}= cell2mat({data_train_hof_harris{i}; data_train_hog_harris{i}});
    
     points = videoGaborDetector(I.vid, sxy, st_gabor, th_gabor, b);
    data_train_hof_gabor{i} = CalculateDescriptors(I.vid, points, 0, 4*sxy, 8, 3);
    data_train_hog_gabor{i} = CalculateDescriptors(I.vid, points, 1, 4*sxy, 8, 3);
    data_train_hof_hog_gabor{i}= cell2mat({data_train_hof_gabor{i}; data_train_hog_gabor{i}});
    
    time = toc;
    eta_time_total = (time * test_cases) / i;
    eta_time = eta_time_total * ((test_cases - i)/ test_cases);
    eta_hours = floor(eta_time / 3600);
    eta_mins = floor((eta_time - eta_hours * 3600) / 60);
    eta_secs = ceil(eta_time - eta_mins * 60 - eta_hours * 3600);

    fprintf(repmat('\b',1,numel(msg)));
    if i > 2
        fprintf('Percentage complete: %.2f%%\nETA: %d hours, %d minutes, %d seconds', (i*100)/test_cases, eta_hours, eta_mins, eta_secs);
        msg = sprintf('Percentage complete: %.2f%%\nETA: %d hours, %d minutes, %d seconds', (i*100)/test_cases, eta_hours, eta_mins, eta_secs);
    else
        fprintf('Percentage complete: %.2f%%\nETA: - hours, - minutes, - seconds', (i*100)/test_cases);
        msg = sprintf('Percentage complete: %.2f%%\nETA: - hours, - minutes, - seconds', (i*100)/test_cases);
    end
end

fprintf('\n');

BOF_tr_hof_harris = myBofVW_train_only(data_train_hof_harris, n_centers);
save(strcat(outputFolder, '/BOF_tr_hof_harris.mat'), 'BOF_tr_hof_harris');

BOF_tr_hog_harris = myBofVW_train_only(data_train_hog_harris, n_centers);
save(strcat(outputFolder, '/BOF_tr_hog_harris.mat'), 'BOF_tr_hog_harris');

BOF_tr_hog_hof_harris = myBofVW_train_only(data_train_hof_hog_harris, n_centers);
save(strcat(outputFolder, '/BOF_tr_hog_hof_harris.mat'), 'BOF_tr_hog_hof_harris');

BOF_tr_hof_gabor = myBofVW_train_only(data_train_hof_gabor, n_centers);
save(strcat(outputFolder, '/BOF_tr_hof_gabor.mat'), 'BOF_tr_hof_gabor');

BOF_tr_hog_gabor = myBofVW_train_only(data_train_hog_gabor, n_centers);
save(strcat(outputFolder, '/BOF_tr_hog_gabor.mat'), 'BOF_tr_hog_gabor');

BOF_tr_hog_hof_gabor = myBofVW_train_only(data_train_hof_hog_gabor, n_centers);
save(strcat(outputFolder, '/BOF_tr_hog_hof_gabor.mat'), 'BOF_tr_hog_hof_gabor');
