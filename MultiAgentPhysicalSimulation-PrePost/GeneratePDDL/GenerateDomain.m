function GenerateDomain(warehouses, houses, packages, drones, velocity, timeWindow)

    % Create a PDDL domain string
    pddlDomain = '';

   % Define the PDDL domain header
    pddlDomain = strcat(pddlDomain, '(define (domain delivery)\n');
    pddlDomain = strcat(pddlDomain, '	(:requirements :typing :durative-actions :fluents :duration-inequalities)\n');
    pddlDomain = strcat(pddlDomain, '	(:predicates\n');
    pddlDomain = strcat(pddlDomain, '		(first-time)\n');
    pddlDomain = strcat(pddlDomain, '		(TL0start)\n');
    pddlDomain = strcat(pddlDomain, '		(TL1start)\n');
    pddlDomain = strcat(pddlDomain, '		(TL0)\n');
    pddlDomain = strcat(pddlDomain, '		(TL1)\n');
    pddlDomain = strcat(pddlDomain,'	\n');        

    % Add predicates for warehouses, packages, houses, and drones here
    for d = 1:drones.num
        pddlDomain = strcat(pddlDomain, ['		(drone',num2str(d),'-delivery-ongoing)\n']);
        pddlDomain = strcat(pddlDomain, ['		(drone',num2str(d),'-complete-delivery)\n']);
        pddlDomain = strcat(pddlDomain, ['		(drone',num2str(d),'-busy)\n']);
        for s = 1:drones.numSlots(d)
            pddlDomain = strcat(pddlDomain, ['		(drone',num2str(d),'-slot',num2str(s),'-full)\n']);
            for p = 1:packages.num
                pddlDomain = strcat(pddlDomain, ['		(drone',num2str(d),'-has-package',num2str(p),'-at-slot',num2str(s),')\n']);             
            end
        end
        pddlDomain = strcat(pddlDomain, '\n');        
    end
    
    for w = 1:warehouses.num
        for p = 1:packages.num
            pddlDomain = strcat(pddlDomain, ['		(package',num2str(p),'-at-warehouse',num2str(w),')\n']);         
        end
    end

    for h = 1:houses.num
        for p = 1:packages.num
            pddlDomain = strcat(pddlDomain, ['		(house',num2str(h),'-needs-package',num2str(p),')\n']);         
            pddlDomain = strcat(pddlDomain, ['		(house',num2str(h),'-got-package',num2str(p),')\n']);         
        end
        
    end
    pddlDomain = strcat(pddlDomain, '	)\n\n');


    % add functions variable for each drone
    pddlDomain = strcat(pddlDomain, '	(:functions\n');
    for d = 1:drones.num
        pddlDomain = strcat(pddlDomain, ['		(drone',num2str(d),'-x)\n']);
        pddlDomain = strcat(pddlDomain, ['		(drone',num2str(d),'-y)\n']);
        pddlDomain = strcat(pddlDomain, ['		(drone',num2str(d),'-battery)\n']);
    end 
    pddlDomain = strcat(pddlDomain, '	)\n\n');

    % add control variables for each drone
    fid_control_variable = fopen("texts/control-variables.txt", 'r');
    control_variable = fread(fid_control_variable, '*char')';
    fclose(fid_control_variable);
    for d = 1:drones.num
        new_control_variable = replace(control_variable,'drone1',['drone',num2str(d)]);
        new_control_variable = replace(new_control_variable,'20',string(velocity));
        pddlDomain = strcat(pddlDomain, new_control_variable);
        pddlDomain = strcat(pddlDomain, '\n');

    end
    pddlDomain = strcat(pddlDomain, '\n');

    % add regions
    fid_region = fopen("texts/region.txt", 'r');
    region = fread(fid_region, '*char')';
    fclose(fid_region);
    pddlDomain = strcat(pddlDomain, region);
    pddlDomain = strcat(pddlDomain, '\n');        

    for h = 1:houses.num
        old = {'earth', '0 0', '1280'};
        new = {['house',num2str(h),'-region'], ...
               [num2str(houses.xy(h,1)),' ',num2str(houses.xy(h,2))], ...
               '32'};
        new_region = replace(region,old,new);
        pddlDomain = strcat(pddlDomain, new_region);
        pddlDomain = strcat(pddlDomain, '\n');        
    end

    for w = 1:warehouses.num
        old = {'earth', '0 0', '1280'};
        new = {['warehouse',num2str(w),'-region'], ...
               [num2str(warehouses.xy(w,1)),' ',num2str(warehouses.xy(w,2))], ...
               '32'};
        new_region = replace(region,old,new);
        pddlDomain = strcat(pddlDomain, new_region);
        pddlDomain = strcat(pddlDomain, '\n');        
    end

    old = {'earth', '0 0', '1280'};
    new = {'helipad-region','624 624', '32'};
    new_region = replace(region,old,new);
    pddlDomain = strcat(pddlDomain, new_region);
    pddlDomain = strcat(pddlDomain, '\n'); 

    % add start delivery
    start_delivery_lines = readlines("texts/start_delivery.txt");
    for line = start_delivery_lines'
            if contains(line,"drone")
                for d = 1:drones.num
                    new_line = replace(line,"drone1","drone" + num2str(d));
                    pddlDomain = strcat(pddlDomain, new_line);
                    pddlDomain = strcat(pddlDomain, '\n');  

                end
            else
                    pddlDomain = strcat(pddlDomain, line);
                    pddlDomain = strcat(pddlDomain, '\n');  
            end
    end
    
    % add delivery
    fid_delivery = fopen("texts/deliver.txt", 'r');
    delivery = fread(fid_delivery, '*char')';
    fclose(fid_delivery);
    for d = 1:drones.num
        header = [' ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;\n', ...
	              ' ;	drone',num2str(d),' delivery actions\n', ...
	              ' ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;\n'];
        pddlDomain = strcat(pddlDomain, header);

        for s = 1:drones.numSlots(d)
            for h = 1:houses.num
                for p = 1:packages.num
                    old = {'drone1','slot1','house1','package1'};
                    new = {['drone',num2str(d)], ['slot',num2str(s)], ...
                           ['house',num2str(h)], ['package',num2str(p)]};
                    if h == timeWindow.house
                        old = [old, '; ', ';;'];
                        new = [new, '(at end (TL0))','(at end (not (TL1)))'];
                    end
                    new_delivery = replace(delivery,old,new);
                    pddlDomain = strcat(pddlDomain, new_delivery);
                    pddlDomain = strcat(pddlDomain, '\n');                    
                end
            end
        end
    end
    pddlDomain = strcat(pddlDomain, '\n');

    % add pickup
    fid_pickup = fopen("texts/pickup.txt", 'r');
    pickup = fread(fid_pickup, '*char')';
    fclose(fid_pickup);
    for d = 1:drones.num
        header = [' ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;\n', ...
	              ' ;	drone',num2str(d),' pickup actions\n', ...
	              ' ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;\n'];
        pddlDomain = strcat(pddlDomain, header);

        for s = 1:drones.numSlots(d)
            for w = 1:warehouses.num
                for p = 1:packages.num
                    old = {'drone1','slot1','warehouse1','package1'};
                    new = {['drone',num2str(d)], ['slot',num2str(s)], ...
                           ['warehouse',num2str(w)], ['package',num2str(p)]};
                    new_pickup = replace(pickup,old,new);
                    pddlDomain = strcat(pddlDomain, new_pickup);
                    pddlDomain = strcat(pddlDomain, '\n');                    
                end
            end
        end
    end
    pddlDomain = strcat(pddlDomain, '\n');

    % add finish delivery
    fid_finish_delivery = fopen("texts/finish_delivery.txt", 'r');
    finish_delivery = fread(fid_finish_delivery, '*char')';
    fclose(fid_finish_delivery);
    for d = 1:drones.num
        old = {'drone1'};
        new = {['drone',num2str(d)]};
        new_finish_delivery = replace(finish_delivery,old,new);
        pddlDomain = strcat(pddlDomain, new_finish_delivery);
        pddlDomain = strcat(pddlDomain, '\n');                    
    end
    pddlDomain = strcat(pddlDomain, '\n');

    
    % add timedliteral
    fid_timedliteral = fopen("texts/timedliteral.txt", 'r');
    timedliteral = fread(fid_timedliteral, '*char')';
    fclose(fid_timedliteral);
    new_timedliteral = replace(timedliteral,'Tend', string(timeWindow.end));
    new_timedliteral = replace(new_timedliteral,'Tstart', string(timeWindow.start));
    pddlDomain = strcat(pddlDomain, new_timedliteral);
    pddlDomain = strcat(pddlDomain, '\n');
    
    pddlDomain = strcat(pddlDomain, '\n\n');  

    % Define the PDDL domain tail
    pddlDomain = strcat(pddlDomain, ')\n');  

    % save the PDDL domain
    fid = fopen('delivery_domain.pddl', 'w');
    fprintf(fid, pddlDomain);
    fclose(fid);

    % save the PDDL domain to WSL
    % fid = fopen('\\wsl.localhost\Ubuntu-22.04\home\saar\scotty2\cqScotty2\Deliveries\delivery_domain.pddl', 'w');
    % fprintf(fid, pddlDomain);
    % fclose(fid);
end