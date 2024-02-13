function main(domainConfigFile, problemConfigFile, numOfProblems, randFlag)
    arguments
        domainConfigFile string = "domainConfig_early_5pack" % config file for simulation
        problemConfigFile string = "problemConfig_early_5pack"
        numOfProblems = 1;
        randFlag = 0;
    end
    % apply domain config
    domainConfigFun = str2func(domainConfigFile);
    [warehouses, houses, packages, drones, velocity, timeWindow] = domainConfigFun();
    % generate domain
    GenerateDomain(warehouses, houses, packages, drones, velocity, timeWindow)
    % get problem config
    problemConfigFun = str2func(problemConfigFile);
    for index = 1:numOfProblems
        % apply problem config
        packages = problemConfigFun(warehouses, houses, packages, drones,index, randFlag);
        % generate problem
        GenerateProblem(warehouses, houses, packages, drones,index)
    end
    disp("Done");
end
