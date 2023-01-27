function [movementRMSEs, xTalkRMSEs, varargout] = compute_rmse(trueValue, predictedValue, varargin)
% [movementRMSEs, xTalkRMSEs, corrCoef] = getRMSE(catTargets, catKinematics,type)
% inputs:
%       trueValue - either hand kinematics during training or target location
%       predictedValue - hand kinematics predicted by decode
%       type - analysis, either: 'targets' or 'training'.   Default is
%       targets.
% outputs:
%       movementRMSEs - intended movements
%       xTalkRMSEs - unintended movements
%     try
%         type = varargin{1};
%     catch
%         type = 'targets';
%     end
    [d1,~] = size(trueValue);
    if(d1 > 12) trueValue = trueValue'; end
    [d1,~] = size(predictedValue);
    if(d1 > 12) predictedValue = predictedValue'; end
    
%     decodeError = trueValue - predictedValue;
%     if(strcmp(type,'targets'))
%         tempTarg = sign(diff(sum(abs(trueValue),1)));    %+1 when on, -1 when off
%     else
%         trueValue = trueValue';
%         predictedValue = predictedValue';
%         tempTarg = sign(diff(sign(sum(abs(trueValue),1))));
%     end
    corrCoefs = corr(trueValue',predictedValue');
    corrCoefs = corrCoefs(eye(12) == 1);
    tempTarg = sign(diff(sign(sum(abs(trueValue),1))));
    TargetStartIdxs = find(tempTarg == 1);
    TargetStopIdxs = find(tempTarg == -1);
    if(length(TargetStopIdxs) < length(TargetStartIdxs))
        TargetStopIdxs = [TargetStopIdxs length(trueValue)];
    end
    if(length(TargetStartIdxs) ~= length(TargetStopIdxs))
        TargetStartIdxs = [1 TargetStartIdxs];
    end
    movementRMSEs = zeros(1,length(TargetStartIdxs));
    xTalkRMSEs = zeros(1,length(TargetStartIdxs));
    
    for qq = 1:length(TargetStartIdxs)
        %window of data to look at
        wind = TargetStartIdxs(qq):TargetStopIdxs(qq);
        %which targets are active?
        temp = sum(trueValue(:,wind),2);
        %get RMSEs for all DOFs
        decodeError = trueValue(:,wind) - predictedValue(:,wind);
        squares = decodeError.^2;
        tempRMSE = sqrt(mean(squares,2));
        %which DOFs have targets (intended movement)
        whichDOF = (temp ~= 0);
        %which DOFs have x-talk? (non-intended movements)
        anyMovement = (sum(abs(predictedValue),2) > 0);
        xTalkDOFs = (anyMovement & ~whichDOF); %moves, but not intendeded movement
        %update results
        movementRMSEs(qq) = mean(tempRMSE(whichDOF));
        xTalkRMSEs(qq) = mean(tempRMSE(xTalkDOFs));
    end
    varargout{1} = corrCoefs;
end