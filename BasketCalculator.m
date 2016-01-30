function [ D, B, R, HW ] = BasketCalculator( D, Y, initWeights, w, FREQ )
%BasketCalculator calculates basket series with rebalancing according to give
%frequency and a weight selection algorithm w
%   D vector of dates
%   Y matrix of timeseries levels where each column represents one
%   component
%   initWeights initial weights with length equal to number of columns in Y
%   w a pointer to a weight seletion function
%   FREQ daily/monthly/quarterly/yearly
%   Returns D - dates, B - basket series, R - basket returns, HW - Historical
%   weights
startingBasketLevel = 100;
B = ones(size(D))*startingBasketLevel;
HW = zeros(size(Y));
HW(1,:) = initWeights;
startingLevels = Y(1,:);
weights = initWeights;

for ind = 2:length(D)-1;
    todayLevels = Y(ind,:);
    basketReturn = weights * (todayLevels ./ startingLevels -1)';
    B(ind) = round(startingBasketLevel * (basketReturn + 1), 12);
    HW(ind,:) = weights;
    if month(D(ind)) ~= month(D(ind+1))
        weights = w(Y(1:ind,:),'one,two,beta',1,initWeights);
        startingLevels = Y(ind,:);
        startingBasketLevel = B(ind);
    end
end
B(end) = B(end-1);
R = B(2:end) ./ B(1:end-1) -1;

disp(strcat('Basket Sharpe Ratio : ', num2str(SharpeRatio(R))));

end

