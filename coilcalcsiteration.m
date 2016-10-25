function Oall = coilcalcsiteration

clear; clc; close all;

Materials = {'Cu', 'Al7050', 'Al7178', 'NiCh', 'Nb', 'Ni'};
[Gauges] = [20, 22, 24, 26, 28, 30, 35, 40];

gmin = 0.17; %Set min g to achieve
gmax = 0.22; %Set max g to achieve
gIterations = 10; %Set number of steps between min and max g
AccelSpan = linspace(gmin,gmax,gIterations);

Days = 3; %Days to spin up
HoursPerIterate = 4; %Iteration window (iterate per H hours)
Hours = Days*24;
timeIterations = Hours/HoursPerIterate; %Iteration steps
TimeSpan = linspace(0,Hours,timeIterations);

[OUTPUTS] = zeros((gIterations*6*8*timeIterations*7*6*4*5*2),16);

%tic;
i = 1;
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
                                    
                                    [radius,torque,current,...
                                        powerEnd,powerCenter,massEnd,massCenter] = ...
                                        coilcalcs(acceleration,w,time,turns,numcoils,...
                                        material,gauge,prcntC,prcntT);
                                    
                                    [OUTPUTS(i,:)] = [acceleration,im,...
                                        gauge,time,w,turns,numcoils,prcntC,...
                                        prcntT,radius,torque,current,...
                                        powerEnd,powerCenter,...
                                        massEnd,massCenter];
                                    
                                    i = i+1;
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
    if OUTPUTS(i,16) > 0.865 %Mass Center cutoff
        [OUTPUTS(i,:)] = 0;
    end
end

for i = 1:length(OUTPUTS);
    if OUTPUTS(i,15) > 0.865 %Mass End cutoff
        [OUTPUTS(i,:)] = 0;
    end
end

for i = 1:length(OUTPUTS);
    if OUTPUTS(i,14) > 3 %Power Center cutoff
        [OUTPUTS(i,:)] = 0;
    end
end

for i = 1:length(OUTPUTS);
    if OUTPUTS(i,13) > 3 %Power End cutoff
        [OUTPUTS(i,:)] = 0;
    end
end

for i = 1:length(OUTPUTS);
    if OUTPUTS(i,12) > 0.25 %Current cutoff
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
