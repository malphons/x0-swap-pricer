classdef TestSwapPricerAccuracy < matlab.unittest.TestCase
    % TestSwapPricer contains tests for the priceSwapDiscount function

    methods(Test)
        function testPriceCalculation(testCase)
            % Test to verify correct price calculation

            % Setup
            CurveType = "zero";
            Settle = datetime("2019-09-15", "InputFormat", "uuuu-MM-dd");
            ZeroTimesMonths = [6, 12*[1 2 3 4 5 7 10 20 30]]';
            ZeroRates = [0.0052, 0.0055, 0.0061, 0.0073, 0.0094, 0.0119, 0.0168, 0.0222, 0.0293, 0.0307]';
            MaturityDate = datetime("2024-09-15", "InputFormat", "uuuu-MM-dd");
            Leg1Type = "float";
            Leg1Rate = 0.022;
            Leg2Type = "fixed";
            Leg2Rate = 0.019;

            % Expected value (This should be replaced with a manually calculated or known value)
            expectedPrice = 7.2279; % Add the expected price here

            % Action
            [Price, ~] = priceSwapDiscount(CurveType, Settle, ZeroTimesMonths, ZeroRates, MaturityDate, Leg1Type, Leg1Rate, Leg2Type, Leg2Rate);

            % Verify
            testCase.verifyEqual(Price, expectedPrice, 'AbsTol', 1e-4, 'Price calculation is incorrect.');
        end
    end

end