function [ D ] = EdgeDetect( I, LaplacType, s, th_edge )
    n=2*ceil(3*s)+1;                                        %upologismos mege8ous filtrou gaussian pou antistoixei sth do8eisa diaspora
    Gaussian=fspecial('Gaussian',n,s);                  %upologismos purhna filtrou gaussian
    LaplacianG=fspecial('log',n,s);                     %upologismos purhna filtrou LoG
    L1=imfilter(I,LaplacianG,'symmetric','conv');                  %proseggish laplacian eikonas me L1 grammikh me8odo kai L2 mh grammikh me8odo
    B=strel('disk',1);
    IG = imfilter(I,Gaussian,'symmetric','conv');                  %efarmogh filtrou LoG
    L2=imdilate(IG,B)+imerode(IG,B)-2*IG;                   %efarmogh mh grammikou filtrou
    if(LaplacType == 0)                                     %epilogh katallhlou filtrou me vash th parametro eisodou
        L = L1;
    else
        L = L2;
    end
    zero_crossing_boolean = L >= 0;                         %metatroph eikonas se duadikh
    Y=imdilate(zero_crossing_boolean,B)-imerode(zero_crossing_boolean,B);       %euresh perigrammatos antikeimenwn me afairesh ths dilate me thn erode eikona
    [Ix, Iy] = gradient(IG);                                 %upologismos twn merikwn paragwgwn ths eikonas se dieu8unsh X kai Y
    normI = sqrt(Ix.^2+Iy.^2);                              %upologismos metrou ths paragwgou
    D=(Y==1)& normI> (max(max(normI))*th_edge);             %efarmogh threshold sth paragwgo gia thn apporipsh shmeiwn pou den einai akmes
end

