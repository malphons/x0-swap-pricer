function [Price, Results] = priceSwapDiscount(CurveType, Settle, ZeroTimesMonths, ZeroRates, MaturityDate, Leg1Type, Leg1Rate, Leg2Type, Leg2Rate)

    %#function nansum
    
    % Ensure datatype are corrected
    Settle = datetime(Settle);
    MaturityDate = datetime(MaturityDate);
    Leg1Type = string(Leg1Type);
    Leg2Type = string(Leg2Type);


    % Create the interest rate curve
    ZeroTimes = calmonths(ZeroTimesMonths);
    ZeroDates = datetime(Settle) + ZeroTimes;
    myRC = ratecurve(CurveType, Settle, ZeroDates, ZeroRates);
    
    % Create swap instrument
    Swap = fininstrument("Swap", 'Maturity', MaturityDate, 'LegRate', [Leg1Rate, Leg2Rate], ...
        'LegType', [Leg1Type, Leg2Type], 'ProjectionCurve', myRC, 'Name', "swap_instrument");
    
    % Create pricer
    Pricer = finpricer("Discount", 'DiscountCurve', myRC);
    
    % Price the swap
    [Price, outPR] = price(Pricer, Swap, "all");
    
    % Return the detailed results
    Results = table2struct(outPR.Results);
end