function packages = problemConfig_simple(warehouses, houses, packages, drones, index, randFlag)
    arguments
        warehouses
        houses
        packages
        drones
        index
        randFlag = 0
    end

    if randFlag
        packages.destHouse = randi(houses.num,[packages.num,1]);
        packages.srcWarehouse = randi(warehouses.num, [packages.num, 1]);
    elseif index == 1
        packages.destHouse = 1;
        packages.srcWarehouse = 1;
    end

    assert(length(packages.destHouse) == packages.num)
    assert(max(packages.destHouse) <= houses.num)
    assert(min(packages.destHouse) >= 1)

    assert(length(packages.srcWarehouse) == packages.num)
    assert(max(packages.srcWarehouse) <= warehouses.num)
    assert(min(packages.srcWarehouse) >= 1)

end