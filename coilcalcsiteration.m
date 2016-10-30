function [Oall,MMP,MPP,MCurrP,MCostP] = coilcalcsiteration

clear; clc; close all;
%% Set up

Materials = {'Cu', 'Al7050', 'Al7178', 'NiCh', 'Nb', 'Ni'}; %Materials Tested
[Gauges] = [20, 22, 24, 26, 28, 30, 35, 40]; %Gauges Tested
sf = 1.2; %Safety Factor

gmin = 0.375; %Set min g to achieve
gmax = 0.385; %Set max g to achieve
gIterations = 10; %Set number of steps between min and max g
AccelSpan = linspace(gmin,gmax,gIterations);

TminDays = 3; %Set min time for spin up to achieve
TmaxDays = 7; %Set max time for spin up to achieve
TimeIterations = 10; %Set number of steps between min and max time
TimeSpan = linspace(TminDays*24,TmaxDays*24,TimeIterations);

wmin = 1; %Set min w to achieve
wmax = 10; %Set max w to achieve
wIterations = 10; %Set number of steps between min and max w
wSpan = linspace(wmin,wmax,wIterations);

[OUTPUTS] = zeros((gIterations*6*8*TimeIterations*wIterations*6*4*5*2),18);

%% Enumeration/Iterations

i = 1;
for ia = 1:gIterations;
    acceleration = AccelSpan(ia);
    for im = 1:6;
        material = Materials(im);
        for ig = 1:8;
            gauge = Gauges(ig);
            for iti = 1:TimeIterations;
                time = TimeSpan(iti);
                for iw = 1:wIterations;
                    w = wSpan(iw);
                    for itu = 1:6;
                        turns = itu*50;
                        for in = 1:4;
                            numcoils = in;
                            for ipc = 1:5;
                                prcntC = 20*(ipc);
                                for ipt = 1:2;
                                    prcntT = 100*(ipt-1);
                                    
                                    [radius,torque,current,...
                                        powerEnd,powerCenter,massEnd,massCenter,massTotal,MinCost] = ...
                                        coilcalcs(acceleration,w,time,turns,numcoils,...
                                        material,gauge,prcntC,prcntT,sf);
                                    
                                    [OUTPUTS(i,:)] = [acceleration,im,...
                                        gauge,time,w,turns,numcoils,prcntC,...
                                        prcntT,radius,torque,current,...
                                        powerEnd,powerCenter,...
                                        massEnd,massCenter,massTotal,MinCost];
                                    
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

%% Output Cutoffs

for i = 1:length(OUTPUTS);
    if OUTPUTS(i,16) > 0.865 %Mass Center cutoff
        [OUTPUTS(i,:)] = 0;
    end
end

for i = 1:length(OUTPUTS);
    if OUTPUTS(i,15) > 0.16 %Mass End cutoff
        [OUTPUTS(i,:)] = 0;
    end
end

for i = 1:length(OUTPUTS);
    if OUTPUTS(i,17) > 4 %Mass Total cutoff
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
    if OUTPUTS(i,18) > 999999 %cost cutoff
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

%% Finding optimal sets

% Minimum mass
[MinMass,MMI] = min(Oall(:,17)); %Find minimum mass and index
MMP = Oall(MMI,:); % Find minimum mass parameters
disp(' ');
disp(['MINIMUM MASS (' num2str(MinMass) ') PARAMETERS:']);
disp(['acceleration ' num2str(MMP(1)) '']);
disp(['' Materials(MMP(2)) '']);
disp(['gauge ' num2str(MMP(3)) '']);
disp(['time ' num2str(MMP(4)) '']);
disp(['w ' num2str(MMP(5)) '']);
disp(['turns ' num2str(MMP(6)) '']);
disp(['numcoils ' num2str(MMP(7)) '']);
disp(['prcntC ' num2str(MMP(8)) '']);
disp(['prcntT ' num2str(MMP(9)) '']);
disp(['radius ' num2str(MMP(10)) '']);
disp(['torque ' num2str(MMP(11)) '']);
disp(['current ' num2str(MMP(12)) '']);
disp(['powerEnd ' num2str(MMP(13)) '']);
disp(['powerCenter ' num2str(MMP(14)) '']);
disp(['massEnd ' num2str(MMP(15)) '']);
disp(['massCenter ' num2str(MMP(16)) '']);
disp(['massTotal ' num2str(MMP(17)) '']);
disp(['MinCost ' num2str(MMP(18)) '']);
disp(' ');

% Minimum Power
PowerTotal = Oall(:,13) + Oall(:,14); %Find minimum power and index
[MinPower,MPI] = min(PowerTotal); % Find minimum power parameters
MPP = Oall(MPI,:);
disp(' ');
disp(['MINIMUM POWER (' num2str(MinPower) ') PARAMETERS:']);
disp(['acceleration ' num2str(MPP(1)) '']);
disp(['' Materials(MPP(2)) '']);
disp(['gauge ' num2str(MPP(3)) '']);
disp(['time ' num2str(MPP(4)) '']);
disp(['w ' num2str(MPP(5)) '']);
disp(['turns ' num2str(MPP(6)) '']);
disp(['numcoils ' num2str(MPP(7)) '']);
disp(['prcntC ' num2str(MPP(8)) '']);
disp(['prcntT ' num2str(MPP(9)) '']);
disp(['radius ' num2str(MPP(10)) '']);
disp(['torque ' num2str(MPP(11)) '']);
disp(['current ' num2str(MPP(12)) '']);
disp(['powerEnd ' num2str(MPP(13)) '']);
disp(['powerCenter ' num2str(MPP(14)) '']);
disp(['massEnd ' num2str(MPP(15)) '']);
disp(['massCenter ' num2str(MPP(16)) '']);
disp(['massTotal ' num2str(MPP(17)) '']);
disp(['MinCost ' num2str(MPP(18)) '']);
disp(' ');

%Minimum Current
[MinCurrent,MCurrI] = min(Oall(:,12)); %Find minimum current and index
MCurrP= Oall(MCurrI,:); % Find minimum current parameters
disp(' ');
disp(['MINIMUM CURRENT (' num2str(MinCurrent) ') PARAMETERS']);
disp(['acceleration ' num2str(MCurrP(1)) '']);
disp(['' Materials(MCurrP(2)) '']);
disp(['gauge ' num2str(MCurrP(3)) '']);
disp(['time ' num2str(MCurrP(4)) '']);
disp(['w ' num2str(MCurrP(5)) '']);
disp(['turns ' num2str(MCurrP(6)) '']);
disp(['numcoils ' num2str(MCurrP(7)) '']);
disp(['prcntC ' num2str(MCurrP(8)) '']);
disp(['prcntT ' num2str(MCurrP(9)) '']);
disp(['radius ' num2str(MCurrP(10)) '']);
disp(['torque ' num2str(MCurrP(11)) '']);
disp(['current ' num2str(MCurrP(12)) '']);
disp(['powerEnd ' num2str(MCurrP(13)) '']);
disp(['powerCenter ' num2str(MCurrP(14)) '']);
disp(['massEnd ' num2str(MCurrP(15)) '']);
disp(['massCenter ' num2str(MCurrP(16)) '']);
disp(['massTotal ' num2str(MCurrP(17)) '']);
disp(['MinCost ' num2str(MCurrP(18)) '']);
disp(' ');

% Minimum Cost
[MinCost,MCostI] = min(Oall(:,18)); %Find minimum cost and index
MCostP = Oall(MCostI,:); % Find minimum cost parameters
disp(' ');
disp(['MINIMUM COST (' num2str(MinCost) ') PARAMETERS:']);
disp(['acceleration ' num2str(MCostP(1)) '']);
disp(['' Materials(MCostP(2)) '']);
disp(['gauge ' num2str(MCostP(3)) '']);
disp(['time ' num2str(MCostP(4)) '']);
disp(['w ' num2str(MCostP(5)) '']);
disp(['turns ' num2str(MCostP(6)) '']);
disp(['numcoils ' num2str(MCostP(7)) '']);
disp(['prcntC ' num2str(MCostP(8)) '']);
disp(['prcntT ' num2str(MCostP(9)) '']);
disp(['radius ' num2str(MCostP(10)) '']);
disp(['torque ' num2str(MCostP(11)) '']);
disp(['current ' num2str(MCostP(12)) '']);
disp(['powerEnd ' num2str(MCostP(13)) '']);
disp(['powerCenter ' num2str(MCostP(14)) '']);
disp(['massEnd ' num2str(MCostP(15)) '']);
disp(['massCenter ' num2str(MCostP(16)) '']);
disp(['massTotal ' num2str(MCostP(17)) '']);
disp(['MinCost ' num2str(MCostP(18)) '']);
disp(' ');

end
