function ImgOut=FuncEstimSat(ImgIn,toShow)
    if~exist('toShow','var')
        toShow=false;
    end
    
    F1=ImgIn<255 | bwmorph(ImgIn==255,'remove');
    Img2=double(ImgIn);
    Img2(~F1)=nan;
    ImgOut=inpaint_nans(Img2,1);
    
    if toShow
        subplot 221
            imagesc(ImgIn);
            axis image
            colorbar
            colormap(gca,'hot')
            xlim([580,830]);ylim([400,630]);
        subplot 222
            imagesc(F1);
            axis image
            colorbar
            colormap(gca,'hot')
            xlim([580,830]);ylim([400,630]);

        subplot 223
            imagesc(ImgOut);
            axis image
            colorbar
            colormap(gca,'hot')
            xlim([580,830]);ylim([400,630]);
            title(max(ImgOut(:)))
            drawnow
    end
end