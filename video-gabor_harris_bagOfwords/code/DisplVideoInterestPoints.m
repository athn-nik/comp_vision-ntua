function [ ] = DisplVideoInterestPoints ( I, isHarris, sxy, st, k, th, b, selected_frames_idx, outputFolder, vidName )

if isHarris
    points = videoHarrisDetector(I.vid, sxy, st, k, th, b);
    title_text = strcat('Harris sxy=', num2str(sxy), ' st=', num2str(st), ' th=', num2str(th), ' b=', num2str(b));
else
    points = videoGaborDetector(I.vid, sxy, st, th, b);
    title_text = strcat('Gabor sxy=', num2str(sxy), ' st=', num2str(st), ' th=', num2str(th), ' b=', num2str(b));
end
showDetection(I.vid, points, selected_frames_idx, 1, outputFolder, strcat(vidName, title_text), title_text);

end

