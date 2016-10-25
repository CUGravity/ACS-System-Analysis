function Oall = coilcalcsiteration

% NEED TO ITERATE BETTER
% Change enumeration

clear; clc; close all;

Materials = {'Cu', 'Al7050', 'Al7178', 'NiCh', 'Nb', 'Ni'};
[Gauges] = [20, 22, 24, 26, 28, 30, 35, 40];

gmin = 0.1; %Set min g to achieve
gmax = 0.2; %Set max g to achieve
gIterations = 10; %Set number of steps between min and max g
AccelSpan = linspace(gmin,gmax,gIterations);

Days = 3; %Days to spin up
HoursPerIterate = 4; %Iteration window (iterate per H hours)
Hours = Days*24;
timeIterations = Hours/HoursPerIterate; %Iteration steps
TimeSpan = linspace(0,Hours,timeIterations);

[OUTPUTS] = zeros((gIterations*6*8*timeIterations*7*6*4*5*2),17);

%tic;
for ia = 1:gIterations;
    acceleration = AccelSpan(ia);
    for im = 1:6;
        material = Materials(im);
        for ig = 1:8;
            gauge = Gauges(ig);
            for iti = 1:timeIterations;
                time = TimeSpan(iti);
                for iw = 1:7;
                    w = iw;
                    for itu = 1:6;
                        turns = itu*50;
                        for in = 1:4;
                            numcoils = in;
                            for ipc = 1:5;
                                prcntC = 20*(ipc);
                                for ipt = 1:2;
                                    prcntT = 100*(ipt-1);
                                    
                                    x = 6*8*6*7*6*4*5*2*(ia-1);
                                    y = 8*6*7*6*4*5*2*(im-1);
                                    z = 6*7*6*4*5*2*(ig-1);
                                    a = 7*6*4*5*2*(iti-1);
                                    b = 6*4*5*2*(iw-1);
                                    c = 4*5*2*(itu-1);
                                    d = 5*2*(in-1);
                                    e = 2*(ipc-1);
                                    f = ipt;
                                    
                                    i = x+y+z+a+b+c+d+e+f;
                                    
                                    [radius,torque,currentEnd,currentCenter,...
                                        powerEnd,powerCenter,massEnd,massCenter] = ...
                                        coilcalcs(acceleration,w,time,turns,numcoils,...
                                        material,gauge,prcntC,prcntT);
                                    
                                    [OUTPUTS(i,:)] = [acceleration,im,...
                                        gauge,time,w,turns,numcoils,prcntC,...
                                        prcntT,radius,torque,currentEnd,...
                                        currentCenter,powerEnd,powerCenter,...
                                        massEnd,massCenter];
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end

for i = 1:length(OUTPUTS);
    if OUTPUTS(i,17) > 0.865 %Mass Center
        [OUTPUTS(i,:)] = 0;
    end
end

for i = 1:length(OUTPUTS);
    if OUTPUTS(i,16) > 0.865 %Mass End
        [OUTPUTS(i,:)] = 0;
    end
end

for i = 1:length(OUTPUTS);
    if OUTPUTS(i,15) > 3 %Power Center
        [OUTPUTS(i,:)] = 0;
    end
end

for i = 1:length(OUTPUTS);
    if OUTPUTS(i,14) > 3 %Power End
        [OUTPUTS(i,:)] = 0;
    end
end

for i = 1:length(OUTPUTS);
    if OUTPUTS(i,13) > 0.25 %Current Center
        [OUTPUTS(i,:)] = 0;
    end
end

for i = 1:length(OUTPUTS);
    if OUTPUTS(i,12) > 0.25 %Current End
        [OUTPUTS(i,:)] = 0;
    end
end

for i = 1:length(OUTPUTS);
    if OUTPUTS(i,9) == 0 %State (Tether deployed)
        [OUTPUTS(i,:)] = 0;
    end
end

OUTPUTS(all(OUTPUTS==0,2),:)=[];

Oall = OUTPUTS;
%toc

end
