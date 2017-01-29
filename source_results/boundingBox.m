function [ rect_size ] = boundingBox( I, M, S )   %sunarthsh upologismou plaisiou proswpou
Iframeycbcr = im2double(rgb2ycbcr(I));            %metatroph eikonas sto xrwmatiko xwro YCbCr kai kanonikopoihsh
Iframecb=reshape(Iframeycbcr(:,:,2),[],1);        %reshape se dianusma
Iframecr=reshape(Iframeycbcr(:,:,3),[],1);
ImSize = size(Iframeycbcr(:,:,1));                %upologismos mege8ous eikonas
Pskin =mvnpdf([Iframecb,Iframecr],M,S);           %efarmogh gkaousianhs sunarthshs upologismou pi8anothtas na einai derma ta stoixeia
Pskin = Pskin / max(max(Pskin));                  %kanonikopoihsh apotelesmatos
Pskin = reshape(Pskin,ImSize(1),ImSize(2) );      %reshape eikonas se dusdiastato pinaka
Pskin = Pskin > 0.22;                              %efarmogh filtou kai metatroph eikonas se duadikh
s_open = strel('disk',1);                         %upologismos mikrou kai megalou purhna gia open kai close
s_close = strel('disk',7);
Pskin_open = imopen(Pskin, s_open);                %open me mikro purhna gia afairesh mikrwn perioxwn
Pskin_close = imclose(Pskin_open, s_close);        %close gia sunenwsh geitwnikwn perioxwn kai trupwn
Pskin_final = imopen(Pskin_close, strel('disk',2));     %efarmogh epipleon opening me stoxo thn e3aleipsh tuxwn mikrwn perioxwn
                                                        %xwris na proklh8ei allagh stis upoloipes anixneu8eises perioxes

BW = logical(Pskin_final);                          %xwrismos antikeimenwn eikonas
stats = regionprops(BW, 'area', 'boundingBox');     %euresh stoxeiwn gia ta antikeimena (emvadon kentro klp)
stats_cells = struct2cell(stats);                   %metatroph struct ths sunarthshs regionprops se double
coordinate = cell2mat(stats_cells(2,:)');           %e3agwgh suntetagmenwn plaisiwn kai rotate wste ka8e sthlh na
                                                    %exei thn idia parametro gia ola ta plaisia
[~, indx_hand] = min(coordinate(:,1));              %euresh ths aristeroterhs perioxhs sthn eikona
rect_size = int16(stats(indx_hand).BoundingBox);    %epistrofh diastasewn megisths epifaneias
end

