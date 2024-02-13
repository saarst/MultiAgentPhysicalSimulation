function [stepsNew, speedX] = BuildPlanfromScotty()
    maxVel = 15; % [meter / sec] velocity norm
    acceleration = 4.75; % [meter / sec^2] in x and y seperately
    steps = jsondecode(fileread('\\wsl.localhost\Ubuntu-22.04\home\saar\scotty2\cqScotty2\scotty_results_drown_3.json')).plan.steps;

    j1 = 1;
    j2 = 1;
    for i=1:length(steps)

        if contains(steps{i}.action,"DRONE1")
            stepsDrone{j1,1} = steps{i};
            j1 = j1 + 1;
        elseif contains(steps{i}.action,"DRONE2")
            stepsDrone{j2,2} = steps{i};
            j2 = j2 + 1;
        end
    end
    vx_start = zeros([length(stepsDrone)/2,2]);
    vx_end = zeros([length(stepsDrone)/2,2]);
    vy_start = zeros([length(stepsDrone)/2,2]);
    vy_end = zeros([length(stepsDrone)/2,2]);
    for d=1:2
        for i=1:(length(stepsDrone(:,d))/2)
            prevIndex = 2*(i-1) + 1;
            if isempty(stepsDrone{prevIndex,d})
                continue
            end
            prevVx1 = stepsDrone{prevIndex,d}.state_variables.("DRONE" + d +"_X");
            prevVy1 = stepsDrone{prevIndex,d}.state_variables.("DRONE" + d +"_Y");
            prevTime = stepsDrone{prevIndex,d}.step_time;
            % delay = 0;
            % if i>1 && prevTime > currTime
            %     delay = prevTime - currTime;
            %     prevTime = currTime;
            % end
            currVx1 = stepsDrone{prevIndex+1,d}.state_variables.("DRONE" + d +"_X");
            currVy1 = stepsDrone{prevIndex+1,d}.state_variables.("DRONE" + d +"_Y");
            currTime = stepsDrone{prevIndex+1,d}.step_time;
            % currTime = currTime - delay;
            

            deltaPosX = currVx1 - prevVx1;
            deltaPosY = currVy1 - prevVy1;

            deltaPos = [deltaPosX , deltaPosY];
            deltaDist = norm(deltaPos);

            deltaTime = currTime - prevTime;
    
            %%
            speedCandidateX = solveSpeed(deltaPosX, vx_start(i,d), vx_end(i,d), deltaTime, acceleration);
            speedX{i,d} = min(speedCandidateX);
            if isempty(speedX{i,d})
                error("no solution");
            end


            speedCandidateY = solveSpeed(deltaPosY, vy_start(i,d), vy_end(i,d), deltaTime, acceleration);
            speedY{i,d} = min(speedCandidateY);
            if isempty(speedY{i,d})
                error("no solution");
            end

            speedNorm{i,d} = norm([speedX{i,d},speedY{i,d}]);
            if speedNorm{i,d} > maxVel
                error("solution exceedes maximum velocity")
            end
            
            newStep.index = i-1;
            newStep.speedX = speedX{i,d};
            newStep.speedY = speedY{i,d};
            newStep.direction = deltaPos/deltaDist;
            newStep.accX = (-1)^(speedX{i,d} > vx_start(i,d)) * acceleration;
            newStep.decX = (-1)^(speedX{i,d} < vx_end(i,d)) * acceleration;
            newStep.accY = (-1)^(speedY{i,d} > vy_start(i,d)) * acceleration;
            newStep.decY = (-1)^(speedY{i,d} > vy_end(i,d)) * acceleration;
            newStep.start_time = prevTime;
            newStep.accX_time = prevTime + abs(speedX{i,d} - vx_start(i,d))/acceleration;
            newStep.decX_time = currTime - abs(speedX{i,d} - vx_end(i,d))/acceleration;
            newStep.accY_time = prevTime + abs(speedY{i,d} - vy_start(i,d))/acceleration;
            newStep.decY_time = currTime - abs(speedY{i,d} - vy_end(i,d))/acceleration;
            newStep.end_time = currTime;
            newStep.step_action = stepsDrone{prevIndex,d}.action;
            stepsNew{i,d} = newStep;
        end
    end

    for d=1:2
        for i=1:(length(stepsDrone(:,d))/2-1)
            if ~isempty(speedX{i+1,d})
                vx_end(i,d) = 0.8 * speedX{i+1,d};
                vx_start(i+1,d) = vx_end(i,d);
            end
            if ~isempty(speedY{i+1,d})
                vy_end(i,d) = 0.8 * speedY{i+1,d};
                vy_start(i+1,d) = vy_end(i,d);
            end
        end
    end

%%
    for d=1:2
        for i=1:(length(stepsDrone(:,d))/2)
            prevIndex = 2*(i-1) + 1;
            if isempty(stepsDrone{prevIndex,d})
                continue
            end
            prevVx1 = stepsDrone{prevIndex,d}.state_variables.("DRONE" + d +"_X");
            prevVy1 = stepsDrone{prevIndex,d}.state_variables.("DRONE" + d +"_Y");
            prevTime = stepsDrone{prevIndex,d}.step_time;

            % delay = 0;
            % if i>1 && prevTime > currTime
            %     delay = prevTime - currTime;
            %     prevTime = currTime;
            % end

            currVx1 = stepsDrone{prevIndex+1,d}.state_variables.("DRONE" + d +"_X");
            currVy1 = stepsDrone{prevIndex+1,d}.state_variables.("DRONE" + d +"_Y");
            currTime = stepsDrone{prevIndex+1,d}.step_time;

            % currTime = currTime - delay;

            

            deltaPosX = currVx1 - prevVx1;
            deltaPosY = currVy1 - prevVy1;

            deltaPos = [deltaPosX , deltaPosY];
            deltaDist = norm(deltaPos);

            deltaTime = currTime - prevTime;
    
            %%
            speedCandidateX = solveSpeed(deltaPosX, vx_start(i,d), vx_end(i,d), deltaTime, acceleration);
            speedX{i,d} = min(speedCandidateX);
            if isempty(speedX{i,d})
                error("no solution");
            elseif speedX{i,d} > maxVel
                error("solution exceedes maximum velocity in X coordinate")
            end

            speedCandidateY = solveSpeed(deltaPosY, vy_start(i,d), vy_end(i,d), deltaTime, acceleration);
            speedY{i,d} = min(speedCandidateY);
            if isempty(speedY{i,d})
                error("no solution");
            elseif speedY{i,d} > maxVel
                error("solution exceedes maximum velocity in Y coordinate")
            end
            
            newStep.index = i-1;
            newStep.speedX = speedX{i,d};
            newStep.speedY = speedY{i,d};
            newStep.direction = deltaPos/deltaDist;
            newStep.accX = (-1)^(speedX{i,d} < vx_start(i,d)) * acceleration;
            newStep.decX = (-1)^(speedX{i,d} > vx_end(i,d)) * acceleration;
            newStep.accY = (-1)^(speedY{i,d} < vy_start(i,d)) * acceleration;
            newStep.decY = (-1)^(speedY{i,d} > vy_end(i,d)) * acceleration;
            newStep.start_time = prevTime;
            newStep.accX_time = prevTime + abs(speedX{i,d} - vx_start(i,d))/acceleration;
            newStep.decX_time = currTime - abs(speedX{i,d} - vx_end(i,d))/acceleration;
            newStep.accY_time = prevTime + abs(speedY{i,d} - vy_start(i,d))/acceleration;
            newStep.decY_time = currTime - abs(speedY{i,d} - vy_end(i,d))/acceleration;
            newStep.end_time = currTime;
            newStep.step_action = stepsDrone{prevIndex,d}.action;
            stepsNew{i,d} = newStep;
        end
    end
%%





structNew_d1.step = stepsNew(:,1);
structNew_d1.step = structNew_d1.step(~cellfun('isempty',structNew_d1.step));
JsonNew_d1 = jsonencode(structNew_d1,"PrettyPrint",true);

fid = fopen('scotty_results_acc_d1.json','w');
fprintf(fid,'%s',JsonNew_d1);
fclose(fid);

structNew_d2.step = stepsNew(:,2);
structNew_d2.step = structNew_d2.step(~cellfun('isempty',structNew_d2.step));
JsonNew_d2 = jsonencode(structNew_d2,"PrettyPrint",true);

fid = fopen('scotty_results_acc_d2.json','w');
fprintf(fid,'%s',JsonNew_d2);
fclose(fid);

disp("Finish")
disp("Maximal speed of drone 1 is :" + max([speedNorm{:,1}]));
disp("Maximal speed of drone 2 is :" + max([speedNorm{:,2}]));



end