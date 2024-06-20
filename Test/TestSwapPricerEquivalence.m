classdef TestSwapPricerEquivalence < matlabtest.compiler.TestCase
    properties
        BuildResults
        ModelUnderTest = "priceSwapDiscount.m"
    end

    methods (TestClassSetup)
        function buildPackage(testCase)
            % Build the deployed code artifact for MATLAB Production Server
            [filepath,filename,fileext] = fileparts(which(testCase.ModelUnderTest));
            modelPath = fullfile(filepath, strcat(filename,fileext));
            buildOpts = compiler.build.ProductionServerArchiveOptions(modelPath);
            testCase.BuildResults = build(testCase, buildOpts);
        end
    end

    methods (Test)
        function testEquivalence(testCase)
            % Define the inputs for the function
            CurveType = "zero";
            Settle = "2019-09-15";
            ZeroTimesMonths = [6, 12*[1 2 3 4 5 7 10 20 30]]';
            ZeroRates = [0.0052, 0.0055, 0.0061, 0.0073, 0.0094, 0.0119, 0.0168, 0.0222, 0.0293, 0.0307]';
            MaturityDate = "2024-09-15";
            Leg1Type = "float";
            Leg1Rate = 0.022;
            Leg2Type = "fixed";
            Leg2Rate = 0.019;

            % Package inputs
            inputs = {CurveType, Settle, ZeroTimesMonths, ZeroRates, MaturityDate, Leg1Type, Leg1Rate, Leg2Type, Leg2Rate};

            % Execute the deployed code artifact
            executionResults = execute(testCase, testCase.BuildResults, inputs);

            % Verify that the execution matches MATLAB
            verifyExecutionMatchesMATLAB(testCase, executionResults);
        end
    end
end