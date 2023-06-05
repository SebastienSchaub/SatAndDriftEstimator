% SatAndDriftEstimator
% developed by Sebastien Schaub (sebastien-schaub@imev-mer.fr)
% programmed with MATLAB Version R2020a
% latest modification : 2022-06-06

% It uses, thanks sharing your tools :
% 1) Bioformats from OME (Open Microscopy Environnement)
% http://www.openmicroscopy.org/bio-formats/
% 2) inpaint_nans  from John D'Errico
% https://fr.mathworks.com/matlabcentral/fileexchange/4551-inpaint_nans?s_tid=srchtitle

%% ========================================================================
% Step 1 : import stack
% ========================================================================
%Par.Pathname='C:\Users\schaub\Documents\IMEV\Projets\Papers\2023-Velasquez paper\Raw Images Paper\Fig4';
%Par.Stkname='Fig4C-2-metap2_tyr.tif';
[Par.Stkname,Par.Pathname]=uigetfile({'*.tif,*.lif'},'Get Image');
if Par.Stkname==0
    return;
end
[Stk,ParStk]=BuiltBFHStack(bfopen(fullfile(Par.Pathname,Par.Stkname)));

%% ========================================================================
% Step 2 : fill saturated pixels
% ========================================================================
answer = questdlg('Need to estimate saturated pixels ?', ...
	'Yes', ...
	'No -Skip','No -Skip');
% Handle response
switch answer
    case 'Yes'
        Stk2=zeros(size(Stk));
        t0=tic;
        for ic=1:ParStk.NC
            parfor iz=1:ParStk.NZ
                Stk2(:,:,ic,iz,1)=FuncEstimSat(Stk(:,:,ic,iz,1),true);
                disp(['t=',num2str(toc(t0),'%2.2f'),'s : C=',num2str(ic),'/',num2str(ParStk.NC),' : Z=',num2str(iz),'/',num2str(ParStk.NZ)])
            end
        end
    case 'No -Skip'
        Stk2=Stk;
end

%% ========================================================================
% Step 3 : Align Z
% ========================================================================
answer = questdlg('Need to correct Z Drift ?', ...
	'Yes', ...
	'No -Skip','No -Skip');
% Handle response
switch answer
    case 'Yes'
        MX=[max(Stk2(:,:,1,:,:),[],'all'),max(Stk2(:,:,2,:,:),[],'all')];
        Stk3=FuncDiffAlign(Stk2,1);
   case 'No -Skip'
        Stk3=Stk2;
end


%% ========================================================================
% Save Results
% ========================================================================

[path,core,ext]=fileparts(Par.Stkname);
bfsave(Stk3,fullfile(Par.Pathname,[core,'Mod.tif']));
%bfsave(Stk4,fullfile(Par.Pathname,[core,'Mod2.tif']));

