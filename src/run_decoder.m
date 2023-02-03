function [xhat] = run_decoder(TRAIN, TestX, TestZ, Idxs, method, varargin)
% inputs
%   TRAIN: structure of filter coefficients
%   TestX: nDOF x n samples of kinematic data
%   TestZ: 720 x n samples of feature data
%   Idxs: integer vector Selected feature indices
%   method: string decode method 'Standard' or 'DWPRR'
%   optional:
%       gains: nDOF x 2 matrix of gains, default 1
%       thresh: nDOF x 2 matrix of thresholds, default 0.2
% outputs:
%   xhat: nDOF x n samples of decode output
% smw 3/2017
%
b= 0;
KalmanGain = ones(size(TestX, 1), 2);
KalmanThresh = 0.2*ones(size(TestX, 1), 2);

if nargin > 5
    KalmanGain = varargin{1};
end
if nargin > 6
    KalmanThresh = varargin{2};
end

xhat = zeros(size(TestX));
xhatSS = xhat;
for j = 1: size(TestX,2)
    switch method
        case 'standard'
            xhat(:,j) = test_kalman(TestZ(Idxs,j),TRAIN,[-1./KalmanGain(:,2),1./KalmanGain(:,1)],j==1);
        case 'DWPRR'
           error('This function has not been implemented')
        case 'KalmanSS'
           error('This function has not been implemented')
    end
    
    % threshold output
    pos = (xhat(:,j)>=0);
    if any(pos)
        xhat(pos,j) = (xhat(pos,j).*KalmanGain(pos,1)-KalmanThresh(pos,1))./(1-KalmanThresh(pos,1)); %apply flexion gains/thresholds
        
    end
    if any(~pos)
        xhat(~pos,j) = (xhat(~pos,j).*KalmanGain(~pos,2)+KalmanThresh(~pos,2))./(1-KalmanThresh(~pos,2)); %apply extension gains/thresholds
    end
    
    xhat(xhat(:,j)<0 & pos, j) = 0;
    xhat(xhat(:,j)>0 & ~pos, j) = 0;
    
    xhat(xhat(:,j)<-1, j) = -1;
    xhat(xhat(:,j)>1, j) = 1;
    
    b = b +1;
    %disp (b);
end