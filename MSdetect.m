function MSEpoch   = MSdetect(MSEpoch,v,acc,amp,veltype,test)
% microsaccade detection, 
% threshold 1 = velocity threshold defined by parameter 'veltype'
% threshold 2 = acceleration threshold for start and end points
% threshold 3 = amplitude >0.1
% final step, check overlapping period.

% input
% MSEpoch (struct)
%       MSEpoch.SmoothData: trial*time*channel (eye position)
%
% v : threshold of velocity (10 deg/sec is recommended)
%
% acc: threshold of acceleration (1200 ~ 2500) 
%
% amp: threshold of amplitude to avoid noise (0.05~0.1 deg)
%
% veltype: type of velocity threshold
%       = 1 : absolute threshold given by parameter 'v' (recommended)
%       = 2 : 2.25 sd of velocity for each trial
%       = 3 : 0.35 of maximum velocity for each trial
% test: 
%       1: run the first trial for parameter tuning
%       0: run all trials
% Written by Yujie Wu, 20171118, 
% Modified by Yujie Wu, 20190812

smoothx = MSEpoch.SmoothData(:,:,1); % horizontal position of eye trial*time*channel
smoothy = MSEpoch.SmoothData(:,:,2);% vertical position of eye

vv=0.002; % duration between two sample points (500Hz)

if test ==1
    ntral = 1;
else
    ntral = size(smoothx,1);
end

clear saccadeIndex nosaccadeIndex saccadeIndex_1thr ...
    SaccadeStartIndex_3thr SaccadeEndIndex_3thr ...
    SaccadeStartIndex SaccadeEndIndex SaccadeNum_3thr

h=waitbar(0,'Please wait...');

for ii=1:ntral

    velocitysx(ii,:) = diff(smoothx(ii,:))/vv;
    velocitysy(ii,:) = diff(smoothy(ii,:))/vv; % NOTE: no velocity for last time point %
    velocityradial(ii,:) = sqrt(velocitysx(ii,:).^2+velocitysy(ii,:).^2);
    accelerations(ii,:) = [0 diff(velocityradial(ii,:))/vv]; % NOTE: no acc for first time point(0) and last point%
    
     %% first threshold
     if veltype == 1
         saccadeIndex_1thr{ii} = find(abs(velocityradial(ii,1:end))>v);%& abs(accelerations(ii,:)) >=550
     elseif veltype == 2
         saccadeIndex_1thr{ii} = find(abs(velocityradial(ii,1:end))>mean(abs(velocityradial(ii,10:end-10)))+2.25*std(abs(velocityradial(ii,10:end-10))));%& abs(accelerations(ii,:)) >=550
     elseif veltype == 3
         saccadeIndex_1thr{ii} = find(abs(velocityradial(ii,1:end))>=0.35*max(abs(velocityradial(ii,10:end-10))));
     end
     
    % Cut Saccade Epoch(above velocity threshold)
    ContinsJudge = diff(saccadeIndex_1thr{ii});
    SaccadeStartIndex_1thr{ii} = [];
    SaccadeEndIndex_1thr{ii} = [];
    
    Amplitude{ii}=[];
 
    SaccadeNum_1thr(ii) =0;
    
    for zz = 1:length(saccadeIndex_1thr{ii})
        if zz ==1 % for the first point
            SaccadeStartIndex_1thr{ii} =  saccadeIndex_1thr{ii}(zz);
            if isempty(ContinsJudge) || (~isempty(ContinsJudge) && ContinsJudge(zz) ~=1)
                SaccadeEndIndex_1thr{ii} =  saccadeIndex_1thr{ii}(zz);
                SaccadeNum_1thr(ii) = SaccadeNum_1thr(ii) + 1;
            end
        else
            if zz == length(saccadeIndex_1thr{ii}) % for the last point
                if  saccadeIndex_1thr{ii}(zz) - saccadeIndex_1thr{ii}(zz-1) ==1
                    SaccadeEndIndex_1thr{ii} =  [SaccadeEndIndex_1thr{ii}  saccadeIndex_1thr{ii}(zz)];
                    SaccadeNum_1thr(ii) = SaccadeNum_1thr(ii) + 1;
                else
                    SaccadeStartIndex_1thr{ii}=  [SaccadeStartIndex_1thr{ii} saccadeIndex_1thr{ii}(zz)];
                    SaccadeEndIndex_1thr{ii}=  [SaccadeEndIndex_1thr{ii} saccadeIndex_1thr{ii}(zz)];
                    SaccadeNum_1thr(ii) = SaccadeNum_1thr(ii) + 1;
                end
            else
                % for the middle points
                if saccadeIndex_1thr{ii}(zz) - saccadeIndex_1thr{ii}(zz-1) ==1 % StartPoint has been recorded
                    if ContinsJudge(zz) ~=1 % current Saccade end at this point
                        SaccadeEndIndex_1thr{ii} =  [SaccadeEndIndex_1thr{ii}  saccadeIndex_1thr{ii}(zz)];
                        SaccadeNum_1thr(ii) = SaccadeNum_1thr(ii) + 1;
                    end
                else % This is a new Start Point
                    SaccadeStartIndex_1thr{ii} =  [SaccadeStartIndex_1thr{ii} saccadeIndex_1thr{ii}(zz)];
                     if ContinsJudge(zz) ~=1 % current Saccade end at this point
                        SaccadeEndIndex_1thr{ii} =  [SaccadeEndIndex_1thr{ii}  saccadeIndex_1thr{ii}(zz)];
                        SaccadeNum_1thr(ii) = SaccadeNum_1thr(ii) + 1;
                    end
                end
            end
        end
    end
%         SaccadeNum_1thr(ii) =SaccadeNum_1thr(ii)-1;
        
    %% second threshold: define flanking period around the over threshold velocity peak
    saccadeIndex{ii}=[];
    SaccadeNum_3thr(ii) = 0;
    
    if SaccadeNum_1thr (ii)==0
        
        SaccadeStartIndex_3thr{ii} =[];
        SaccadeEndIndex_3thr{ii} = [];
        
    else
        
        for jj =1:SaccadeNum_1thr(ii)
            stepend=0;stepstart=0;
            
            while 1
                if SaccadeEndIndex_1thr{ii}(jj)+stepend+1<=size(accelerations,2) && abs(accelerations(ii,SaccadeEndIndex_1thr{ii}(jj)+stepend+1)) >=acc
                    stepend =stepend+1;
                else
                    break
                end
            end
            
            while 1
                if SaccadeStartIndex_1thr{ii}(jj)-stepstart-1>1&& abs(accelerations(ii,SaccadeStartIndex_1thr{ii}(jj)-stepstart-1)) >=acc
                    stepstart =stepstart+1;
                else
                    break
                end
            end
            
            %% Third threshold (amplitude>0.1degree)
            Amplitude_x = smoothx(ii,SaccadeStartIndex_1thr{ii}(jj)-stepstart)-smoothx(ii,SaccadeEndIndex_1thr{ii}(jj)+stepend);
            Amplitude_y = smoothy(ii,SaccadeStartIndex_1thr{ii}(jj)-stepstart)-smoothy(ii,SaccadeEndIndex_1thr{ii}(jj)+stepend);
            
            %% Forth threshold (refectory period)
            if SaccadeNum_3thr(ii)~=0
                % calculate saccade distance
                SaccadeDis = (SaccadeStartIndex_1thr{ii}(jj)-stepstart)-SaccadeEndIndex_3thr{ii}(SaccadeNum_3thr(ii));
            else
                SaccadeDis = 10000;
            end
             AmplitudeAbs=sqrt(Amplitude_x^2+Amplitude_y^2);
            if AmplitudeAbs>amp
                if SaccadeDis >= 25
                SaccadeNum_3thr(ii) = SaccadeNum_3thr(ii) +1;
                SaccadeStartIndex_3thr{ii}(SaccadeNum_3thr(ii)) = SaccadeStartIndex_1thr{ii}(jj)-stepstart;
                SaccadeEndIndex_3thr{ii}(SaccadeNum_3thr(ii)) = SaccadeEndIndex_1thr{ii}(jj)+stepend;
                Amplitude{ii}(SaccadeNum_3thr(ii))=AmplitudeAbs;
                else
                    if Amplitude{ii}(SaccadeNum_3thr(ii))>=AmplitudeAbs %select the larger one
                    elseif Amplitude{ii}(SaccadeNum_3thr(ii))<AmplitudeAbs
                        SaccadeStartIndex_3thr{ii}(SaccadeNum_3thr(ii)) = SaccadeStartIndex_1thr{ii}(jj)-stepstart;
                        SaccadeEndIndex_3thr{ii}(SaccadeNum_3thr(ii)) = SaccadeEndIndex_1thr{ii}(jj)+stepend;
                        Amplitude{ii}(SaccadeNum_3thr(ii))=AmplitudeAbs;
                    end
                    
                end
            end
            if jj == SaccadeNum_1thr(ii) && SaccadeNum_3thr(ii)==0
                SaccadeStartIndex_3thr{ii} =[];
                SaccadeEndIndex_3thr{ii} = [];
            end
            
        end
        
        
    end
    
    
    
    
    %% check for overlap
    if ~isempty(SaccadeStartIndex_3thr{ii})
        SaccadeStartIndex{ii}(1) = SaccadeStartIndex_3thr{ii}(1);
        
        SaccadeNum(ii) = 1;
        overlapNum = 0 ;
        if SaccadeNum_3thr(ii)==1
            SaccadeEndIndex{ii}(SaccadeNum(ii)) = SaccadeEndIndex_3thr{ii}(SaccadeNum(ii)+overlapNum);
        else
            for jj=2:SaccadeNum_3thr(ii)
                if SaccadeStartIndex_3thr{ii}(jj)<=SaccadeEndIndex_3thr{ii}(jj-1);
                    if  SaccadeNum(ii)>1
                        SaccadeNum(ii)= SaccadeNum(ii)-1;
                    end
                    
                    overlapNum = overlapNum+1;
                end
                if SaccadeNum(ii)+overlapNum<=SaccadeNum_3thr(ii)
                    
                    SaccadeEndIndex{ii}(SaccadeNum(ii)) = SaccadeEndIndex_3thr{ii}(SaccadeNum(ii)+overlapNum);
                    SaccadeNum(ii) = SaccadeNum(ii) +1;
                end
                if SaccadeNum(ii)+overlapNum<=SaccadeNum_3thr(ii)
                    SaccadeStartIndex{ii}(SaccadeNum(ii)) = SaccadeStartIndex_3thr{ii}(SaccadeNum(ii)+overlapNum);
                end
                if jj==SaccadeNum_3thr(ii) && SaccadeNum(ii)+overlapNum<=SaccadeNum_3thr(ii)
                    SaccadeEndIndex{ii}(SaccadeNum(ii)) = SaccadeEndIndex_3thr{ii}(SaccadeNum(ii)+overlapNum);
                end
            end
        end
    else
        
        SaccadeStartIndex{ii} = [];
        SaccadeEndIndex{ii} = [];
        SaccadeNum(ii) = 0;
    end
    
    for jj = 1:SaccadeNum(ii)
        saccadeIndex{ii} =[saccadeIndex{ii} SaccadeStartIndex{ii}(jj):SaccadeEndIndex{ii}(jj)];
        Amp_x = smoothx(ii,SaccadeEndIndex{ii}(jj))-smoothx(ii,SaccadeStartIndex{ii}(jj));%added by yujie 2019/8/12
        Amp_y = smoothy(ii,SaccadeEndIndex{ii}(jj))-smoothy(ii,SaccadeStartIndex{ii}(jj));%added by yujie 2019/8/12
        Amplitude_s{ii}(jj) =sqrt(Amp_x^2+Amp_y^2);
        
        theta_cos{ii}(jj) = -Amp_x/Amplitude_s{ii}(jj);
        theta_sin{ii}(jj) = -Amp_y/Amplitude_s{ii}(jj);
        
    end
    
    nosaccadeIndex{ii}= setdiff(1:size(smoothx,2),saccadeIndex{ii});
    waitbar(ii/ntral,h)
end

%% output

MSEpoch.velocitysx = velocitysx;
MSEpoch.velocitysy = velocitysy;
MSEpoch.velocityradial = velocityradial;
MSEpoch.accelerations = accelerations;
MSEpoch.amplitude = Amplitude_s;
MSEpoch.theta_cos = theta_cos;
MSEpoch.theta_sin = theta_sin;
MSEpoch.SaccadeStartIndex = SaccadeStartIndex;
MSEpoch.SaccadeEndIndex = SaccadeEndIndex;
MSEpoch.saccadeIndex = saccadeIndex;
MSEpoch.nosaccadeIndex = nosaccadeIndex;
MSEpoch.SaccadeNum = SaccadeNum;

close(h);

end