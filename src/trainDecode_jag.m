function TRAIN = trainDecode_jag(TrainX, TrainZ, Idxs, method, varargin)
% inputs
%   TrainX: nDOF x n samples aligned training data kinematics
%   TrainZ: 720 x n samples aligned training data features
%   Idxs: integer vector of selected indices

%   method: string decdoe method, 'standard', or 'DWPRR', 
% outputs
%   TRAIN: structure containing decode coefficients
%
% smw 3/2017

try
    KalmanGain = varargin{1};
catch
    KalmanGain = ones(size(TrainX,1),2);
end

% run decode on test data +/- extra processing such as gains/thresh
switch method
    case 'standard'
        TRAIN = kalman_train(TrainX,TrainZ(Idxs,:));
        %             xhat = zeros(length(KalmanMvnts), size(TestX,2));
        a = kalman_test(TrainZ(Idxs,1),TRAIN,[-1./KalmanGain(:,2),1./KalmanGain(:,1)],1);% init
    case 'DWPRR'
        minZ = min(TrainZ(Idxs,:),[],2);
        tempZ = TrainZ(Idxs,:)-repmat(minZ,1,size(TrainZ,2));
        %         tempZ = nthroot(tempZ,3);
        normalizerZ = max(tempZ,[],2);
        tempZ = tempZ./repmat(normalizerZ,1,size(tempZ,2));
        tempZ = nthroot(tempZ,3);
        tempZ = [tempZ; ones(1,size(tempZ,2))];
        tempX = TrainX;
        tempXPos = zeros(size(tempX));
        tempXNeg = zeros(size(tempX));
        tempXPos(tempX >= 0) = tempX(tempX >= 0);
        tempXNeg(tempX < 0) = tempX(tempX < 0); % note, if there are all zero rows, remove
        tempX = [tempXPos; tempXNeg];
        clear w trainEst;
        for iDWPRR = 1:size(tempX,1)
            w(:,iDWPRR) = DWPRR(tempX(iDWPRR,:),tempZ);
            trainEst(iDWPRR,:) = (w(:,iDWPRR)'*tempZ).^3;
        end
        TRAIN = kalman_train(TrainX,trainEst);
        
        %             ' = zeros(length(KalmanMvnts), size(TestX,2));
        a = kalman_test(trainEst(:,1),TRAIN,[-1./KalmanGain(:,2),1./KalmanGain(:,1)],1);% init
    case 'KalmanSS'
        TRAIN = kalman_trainSS(TrainX,TrainZ(Idxs,:));
end