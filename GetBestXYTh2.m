function ImgOut=GetBestXYTh2(Img1,Img2,UnitDrift)
    Sze=size(Img1);
% Get Barycenter for fast alignment
    [MX,MY]=ndgrid(1:Sze(1),1:Sze(2));
    S1=sum(Img1(:));
    S2=sum(Img2(:));
    G1=[sum(sum(Img1,3).*MX,'all')./S1,sum(sum(Img1,3).*MY,'all')./S1];
    G2=[sum(sum(Img2,3).*MX,'all')./S2,sum(sum(Img2,3).*MY,'all')./S2];
    Drift=round([G1(2)-G2(2),G1(1)-G2(1),0]);
    History=nan(1,5);
    LTh=[0,-1,1];
    i0=1;
    while i0<=length(LTh)
% Align on XY
        LX=[-1,-1;-1,0;-1,0;0,-1;0,0;0,1;1,-1;1,0;1,1];
        i1=1;
        while i1<=size(LX,1)
            DTmp=Drift+UnitDrift.*[LX(i1,1),LX(i1,2),LTh(i0)];
            if ~ismember(History(:,2:4),DTmp,'rows')
                TmpScore=GetScore(Img1,Img2,DTmp,0);
                if TmpScore<min(History(:,5))
                    Drift(1:2)=DTmp(1:2);
                    i1=0;
                end
                History=cat(1,History,[size(History,1),DTmp,TmpScore]);
            end
            i1=i1+1;
        end
%         subplot(3,2,1)
%             plot(History(:,1),History(:,2),'b.-')
%             hold on
%             plot(History(:,1),History(:,3),'r.-')
%             hold off
%             grid on
%             title('XY Position')
%             legend({'X','Y'})
%         subplot(3,2,3)
%             plot(History(:,1),History(:,4),'g.-')
%             grid on
%             title('Theta')
%         subplot(3,2,5)
%             plot(History(:,1),History(:,5),'k.-')
%             grid on
%             title('Score')
%         drawnow
        
        [~,idx]=min(History(:,5));       
        Drift=History(idx,2:4);
        DTmp=Drift+UnitDrift.*[0,0,LTh(i0)];
        if ~ismember(History(:,2:4),DTmp,'rows')
            TmpScore=GetScore(Img1,Img2,DTmp,0);
            if TmpScore<min(History(:,5))
                disp(['Theta>',num2str(DTmp(3))])
                Drift=DTmp;
            end
            i0=0;
            History=cat(1,History,[size(History,1),DTmp,TmpScore]);
        end
        i0=i0+1;       
    end
    [~,idx]=min(History(:,5));       
    Drift=History(idx,2:4);
    Score=History(idx,5);
    
    disp(['DX=',num2str(Drift(1),2),' ; DY=',num2str(Drift(2),2),' ; DTh=',num2str(Drift(3),2),' ; Score=',num2str(Score,3)])
    [~,ImgOut]=GetScore(Img1,Img2,Drift,0);
end


function [Score,Img2]=GetScore(Img1,Img2,Drift,ShowPos)
    if nargin<4
        ShowPos=0;
    end
    mymap=cat(1,linspace(0,1,255),[linspace(0,0.5,128),linspace(0.5,0,127)],linspace(1,0,255)).';
    Sze=size(Img1);
    if length(Sze)==2
        Sze(3)=1;
    end
    if Drift(3)~=0
        Img2=imrotate(Img2,Drift(3),'bilinear','crop');
    end
    Img2=circshift(Img2,Drift(1:2));

% Max if difference between channels
    k=reshape(Img1-Img2,[prod(Sze(1:2)),Sze(3)]);
    [~,idx]=max(abs(k),[],2);
    for ic=1:Sze(3)
        if ic==1
            DI=k(:,ic).*double(idx==ic);
        else
            DI=DI+k(:,ic).*double(idx==ic);
        end
    end
    DI=reshape(DI,Sze(1:2));
    Score=sum(abs(DI),'all')./prod(Sze(1:2));

%     Score=sum(abs(Img1-Img2),'all');
    if ShowPos==0
    else
        subplot(ShowPos(1),ShowPos(2),ShowPos(3))
        imagesc(DI); 
        axis image;
        colormap(gca,mymap)
        caxis(max(abs(DI(:)))*[-1,1])
        xlim([520,750]);ylim([430,650])
        colorbar
        title(Score)
    end
end