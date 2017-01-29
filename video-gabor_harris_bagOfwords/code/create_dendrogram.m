function [ ] = create_dendrogram( data,name )

figure;
link = linkage(data,'centroid','@distChiSq');
dendrogram(link,'ColorThreshold','default');
title(name);
C = cluster(link, 'maxclust', 3);                           %upologismos klassewn twn eikonwn mas dedomenou oti uparxoun 3 klaseis
Rc = zeros(1, 3);
for i = 1:3
    if(sum(C == i) == 1)                                    %se periptwsh pou kapoia klash exei ena melos h apostash me allo stoixeio sth klash orizetai ws 0
        MaxIntraDist = 0;
    else
        MaxIntraDist = max(pdist(data(C == i, :)));          %alliws h max apostash einai to max distance (h pdist upologizei olous tous sundiasmous kai epilegoume to megisto)
    end
    MinInterDist = min(min(pdist2(data(C == i, :), data(C ~= i, :))));        %h elaxisth apostash einai h min apostash apo opoiodhpote stoixeio anhkei sth klash me opoiodhpote stoixeio den anhkei
    Rc(i) = MaxIntraDist / MinInterDist;                    %upologismos Rc
end
R = sum(Rc);                                                %upologismos telikhs metrikhs apo to a8roisma twn epimerous metrikwn gia ka8e klash
disp(R);

end

