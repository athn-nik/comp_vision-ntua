close all;
clearvars;
clc;

videoFolder = './samples';
preprocessedFolder = './videos';
outputFolder = './output';


load(strcat(outputFolder, '/BOF_tr_hog_harris.mat'));
create_dendrogram(BOF_tr_hog_harris,'HOG harris');

load(strcat(outputFolder, '/BOF_tr_hof_harris.mat'));
create_dendrogram(BOF_tr_hof_harris,'HOF harris');

load(strcat(outputFolder, '/BOF_tr_hog_gabor.mat'));
create_dendrogram(BOF_tr_hog_gabor,'HOG gabor');


load(strcat(outputFolder, '/BOF_tr_hof_gabor.mat'));
create_dendrogram(BOF_tr_hof_gabor,'HOF gabor');

load(strcat(outputFolder, '/BOF_tr_hog_hof_harris.mat'));
create_dendrogram(BOF_tr_hog_hof_harris,'HOF HOG harris');

load(strcat(outputFolder, '/BOF_tr_hog_hof_gabor.mat'));
create_dendrogram(BOF_tr_hog_hof_gabor,'HOF HOG gabor');

