function [warehouses, houses, packages, drones] = domainConfig_simple()
    % Define the number of instances you want to add
    warehouses.num = 1;             % Change this to the desired number of warehouses
    warehouses.xy = [322, 982]; 
    assert (isequal(size(warehouses.xy), [warehouses.num, 2]))
    houses.num = 1;      % Change this to the desired number of houses
    houses.xy = [92, 182];
    assert (isequal(size(houses.xy), [houses.num, 2]))
    packages.num = 1;               % Change this to the desired number of packages
    drones.num = 1;                 % Change this to the desired number of drones
    drones.numSlots = 1;
    assert(isequal(size(drones.numSlots), [drones.num, 1]))
end