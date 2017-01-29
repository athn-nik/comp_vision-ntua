function [ M, S ] = init_skin_filter()
    Samplesrgb=load('skinSamplesRGB');                 %fortwsh arxeiou deigmatwn dermatos
    Samplesrgb = Samplesrgb.skinSamplesRGB;            %fortwsh xrwmatwn rgb
    SamplesYcbcr=im2double(rgb2ycbcr(Samplesrgb));     %metatroph xrwmatwn sto xwro YCbCr kai 
    Icb=reshape(SamplesYcbcr(:,:,2),[],1);             %reshape dusdiastaths eikonas se dianusma
    Icr=reshape(SamplesYcbcr(:,:,3),[],1);
    mcb=mean(mean(SamplesYcbcr(:,:,2)));               %upologismos mesou orou kanaliou Cb
    mcr=mean(mean(SamplesYcbcr(:,:,3)));               %upologismos mesou orou kanaliou Cr
    M=[mcb, mcr];                                      %kataskeuh dianusmatos mesou orou kanaliwn Cb kai Cr
    S=cov(Icb,Icr);                                    %upologismos sundiakumanshs kanaliwn Cb kai Cr
end

