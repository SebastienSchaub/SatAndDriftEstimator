function StkOut=FuncDiffAlign(Stk,DeltaT)
    if nargin<2
        DeltaT=1;
    end
    DeltaIntROI=80;
    UnitDrift=[1,1,0.5];%drift X,Y,rot
    % mymap=cat(1,linspace(0,1,255),[linspace(0,0.5,128),linspace(0.5,0,127)],linspace(1,0,255)).';


    Sze=size(Stk);% assumed XYCZT
    StkOut=Stk;
    t0=tic;
    for iz=2:Sze(4)
        k=StkOut(:,:,:,iz);
        for ic=1:Sze(3)
            MX(ic)=max(k(:,:,ic),[],'all');
        end
        if max(k,[],'all')<=DeltaIntROI
            MyROI=[1,Sze(1),1,Sze(2)];
        else
            k1=squeeze(max(max(k,[],3),[],1));
            MyROI(1:2)=[find(k1>DeltaIntROI,1,'first'),find(k1>DeltaIntROI,1,'last')];
            k1=squeeze(max(max(k,[],3),[],2));
            MyROI(3:4)=[find(k1>DeltaIntROI,1,'first'),find(k1>DeltaIntROI,1,'last')];
            MyROI(2:2:4)=max(MyROI(2:2:4),MyROI(1:2:3)+1);
        end
        subplot(2,2,1)
            if Sze(3)==1
                RGB=repmat(StkOut(:,:,1,max(1,iz-DeltaT))/MX(1),[1,1,3]);
            elseif Sze(3)==2
                RGB=cat(3,StkOut(:,:,1,max(1,iz-DeltaT))/MX(1),StkOut(:,:,2,max(1,iz-DeltaT))/MX(2),StkOut(:,:,1,max(1,iz-DeltaT))/MX(1));
            elseif Sze(3)==3
                RGB=cat(3,StkOut(:,:,1,max(1,iz-DeltaT))/MX(1),StkOut(:,:,2,max(1,iz-DeltaT))/MX(2),StkOut(:,:,3,max(1,iz-DeltaT))/MX(3));
            else
            end
            imagesc(RGB);
            axis image
            title('Prev Image')
            ylim(MyROI(3:4));
            xlim(MyROI(1:2));
        subplot(2,2,2)
            if Sze(3)==1
                RGB=repmat(StkOut(:,:,1,iz)/MX(1),[1,1,3]);
            elseif Sze(3)==2
                RGB=cat(3,StkOut(:,:,1,iz)/MX(1),StkOut(:,:,2,iz)/MX(2),StkOut(:,:,1,iz)/MX(1));
            elseif Sze(3)==3
                RGB=cat(3,StkOut(:,:,1,iz)/MX(1),StkOut(:,:,2,iz)/MX(2),StkOut(:,:,3,iz)/MX(3));
            else
            end
            
            imagesc(RGB);
            axis image
            title('Before Image')
            ylim(MyROI(3:4));
            xlim(MyROI(1:2));
        StkOut(:,:,:,iz)=GetBestXYTh2(StkOut(:,:,:,max(1,iz-DeltaT)),StkOut(:,:,:,iz),UnitDrift);
        subplot(2,2,3)
            if Sze(3)==1
                RGB=repmat((StkOut(:,:,1,iz)-k(:,:,1))/MX(1),[1,1,3]);
            elseif Sze(3)==2
                RGB=cat(3,(StkOut(:,:,1,iz)-k(:,:,1))/MX(1),(StkOut(:,:,2,iz)-k(:,:,2))/MX(2),(StkOut(:,:,1,iz)-k(:,:,1))/MX(1));
            elseif Sze(3)==3
                RGB=cat(3,(StkOut(:,:,1,iz)-k(:,:,1))/MX(1),(StkOut(:,:,2,iz)-k(:,:,2))/MX(2),(StkOut(:,:,3,iz)-k(:,:,3))/MX(3));
            else
            end
            imagesc(RGB);
            axis image
            title('Delta Image')
            ylim(MyROI(3:4));
            xlim(MyROI(1:2));
        subplot(2,2,4)
            if Sze(3)==1
                RGB=repmat(StkOut(:,:,1,iz)/MX(1),[1,1,3]);
            elseif Sze(3)==2
                RGB=cat(3,StkOut(:,:,1,iz)/MX(1),StkOut(:,:,2,iz)/MX(2),StkOut(:,:,1,iz)/MX(1));
            elseif Sze(3)==3
                RGB=cat(3,StkOut(:,:,1,iz)/MX(1),StkOut(:,:,2,iz)/MX(2),StkOut(:,:,3,iz)/MX(3));
            else
            end
            imagesc(RGB);
            axis image
            title('After Image')
            ylim(MyROI(3:4));
            xlim(MyROI(1:2));
            drawnow;
        disp(['Z=',num2str(iz),'/',num2str(Sze(4)),' ; elapsed time : ',num2str(toc(t0),'%2.2f'),'s'])
    end
end