function GenerateProblem(warehouses, houses, packages, drones,index)

    % Create a PDDL problem string
    pddlProblem = '';

   % Define the PDDL domain header
    pddlProblem = strcat(pddlProblem, ['(define (problem delivery',num2str(index),')\n']);
    pddlProblem = strcat(pddlProblem, '	(:domain delivery)\n');
    pddlProblem = strcat(pddlProblem, '\n');

    % init
    pddlProblem = strcat(pddlProblem, '	(:init\n');
    pddlProblem = strcat(pddlProblem, '		(first-time)\n');
    for d = 1:drones.num
        pddlProblem = strcat(pddlProblem, ['		(= (drone',num2str(d),'-x) 640.0)\n']);
        pddlProblem = strcat(pddlProblem, ['		(= (drone',num2str(d),'-y) 640.0)\n']);
        pddlProblem = strcat(pddlProblem, ['		(= (drone',num2str(d),'-battery) 4000)\n']);
    end
    for p = 1:packages.num
        h = packages.destHouse(p);
        w = packages.srcWarehouse(p);
        pddlProblem = strcat(pddlProblem, ['		(house',num2str(h),'-needs-package',num2str(p),')\n']);
        pddlProblem = strcat(pddlProblem, ['		(package',num2str(p),'-at-warehouse',num2str(w),')\n']);
    end
    pddlProblem = strcat(pddlProblem, '	)\n\n');

    % goal
    pddlProblem = strcat(pddlProblem, '	(:goal (and\n');
    for d = 1:drones.num
        pddlProblem = strcat(pddlProblem, ['		(drone',num2str(d),'-complete-delivery)\n']);
    end
    for p = 1:packages.num
        h = packages.destHouse(p);
        pddlProblem = strcat(pddlProblem, ['		(house',num2str(h),'-got-package',num2str(p),')\n']);
    end    
    pddlProblem = strcat(pddlProblem, '		)\n');
    pddlProblem = strcat(pddlProblem, '	)\n');
    pddlProblem = strcat(pddlProblem, ')\n');
    pddlProblem = strcat(pddlProblem, '\n');
    % metric
    pddlProblem = strcat(pddlProblem, '(:metric minimize (+\n');
    for d = 1:drones.num
        pddlProblem = strcat(pddlProblem,['					(* -0.1 (drone'],num2str(d),'-battery))\n');
    end
    pddlProblem = strcat(pddlProblem, '					(* 20 (total-time) ))\n');
    pddlProblem = strcat(pddlProblem, ')\n');
    
    % save the PDDL problem
    fid = fopen(['delivery_problem',num2str(index),'.pddl'], 'w');
    fprintf(fid, pddlProblem);
    fclose(fid);

    % save the PDDL problem to WSL
    % fid = fopen(['\\wsl.localhost\Ubuntu-22.04\home\saar\scotty2\cqScotty2\Deliveries\delivery_problem',num2str(index),'.pddl'], 'w');
    % fprintf(fid, pddlProblem);
    % fclose(fid);

end
