function [Oall,MMP,MPP,MCurrP,MCostP,...
    OFeasibleMinMass,OFeasibleMinPower,...
    OFeasibleMinCurrent,OFeasibleMinCost] = coilcalcsplotter

clear; clc; close all;
%% Feasible Sets

[Oall,MMP,MPP,MCurrP,MCostP] = coilcalcsiteration;

imMMP = all(Oall(:,2) == MMP(:,2),2); %Material set
gMMP = all(Oall(:,3) == MMP(:,3),2); %Gauge set
tiMMP = all(Oall(:,4) == MMP(:,4),2); %Time set
tuMMP = all(Oall(:,6) == MMP(:,6),2); %Turn set
inMMP = all(Oall(:,7) == MMP(:,7),2); %Num coils set

%Set of all output states with the input parameters of min mass state:
OFeasibleMinMass = Oall(logical(imMMP.*gMMP.*tiMMP.*tuMMP.*inMMP),:);

imMPP = all(Oall(:,2) == MPP(:,2),2); %Material set
gMPP = all(Oall(:,3) == MPP(:,3),2); %Gauge set
tiMPP = all(Oall(:,4) == MPP(:,4),2); %Time set
tuMPP = all(Oall(:,6) == MPP(:,6),2); %Turn set
inMPP = all(Oall(:,7) == MPP(:,7),2); %Num coils set

%Set of all output states with the input parameters of min power state:
OFeasibleMinPower = Oall(logical(imMPP.*gMPP.*tiMPP.*tuMPP.*inMPP),:);

imMCurrP = all(Oall(:,2) == MCurrP(:,2),2); %Material set
gMCurrP = all(Oall(:,3) == MCurrP(:,3),2); %Gauge set
tiMCurrP = all(Oall(:,4) == MCurrP(:,4),2); %Time set
tuMCurrP = all(Oall(:,6) == MCurrP(:,6),2); %Turn set
inMCurrP = all(Oall(:,7) == MCurrP(:,7),2); %Num coils set

%Set of all output states with the input parameters of min current state:
OFeasibleMinCurrent = Oall(logical(imMCurrP.*gMCurrP.*tiMCurrP.*tuMCurrP.*inMCurrP),:);

imMCostP = all(Oall(:,2) == MCostP(:,2),2); %Material set
gMCostP = all(Oall(:,3) == MCostP(:,3),2); %Gauge set
tiMCostP = all(Oall(:,4) == MCostP(:,4),2); %Time set
tuMCostP = all(Oall(:,6) == MCostP(:,6),2); %Turn set
inMCostP = all(Oall(:,7) == MCostP(:,7),2); %Num coils set

%Set of all output states with the input parameters of min cost state:
OFeasibleMinCost = Oall(logical(imMCostP.*gMCostP.*tiMCostP.*tuMCostP.*inMCostP),:);

%% Plotter - For min mass parameter states

for omegaPC = 1:10;
    wA = all(OFeasibleMinMass(:,5) == omegaPC,2); %RPM hold
    OFeasibleW = OFeasibleMinMass(logical(wA),:);
    
    Empty = isempty(OFeasibleW);
    
    if Empty == 1;
    else
        %Inputs CONSTANT OMEGA
        acW = OFeasibleW(:,1);
        prcntCW = OFeasibleW(:,8);
        
        %Outputs CONSTANT OMEGA
        powerW = OFeasibleW(:,14) + 2*OFeasibleW(:,13);
        massW = OFeasibleW(:,17);
        
        figure
        subplot(2,1,1);
        hold on;
        plot3(acW,prcntCW,powerW,'-o');
        xlabel('G'); ylabel('Prcnt C'); zlabel('TOTAL Power');
        title(['OMEGA=' num2str(omegaPC) ' MIN MASS PARAMS']);
        plot3(MMP(1),MMP(8),MMP(14)+2*MMP(13),'*');
        hold off;
        
        subplot(2,1,2);
        hold on;
        plot3(acW,prcntCW,massW,'-o');
        xlabel('G'); ylabel('Prcnt C'); zlabel('TOTAL Mass');
        title(['OMEGA=' num2str(omegaPC) ' MIN MASS PARAMS']);
        plot3(MMP(1),MMP(8),MMP(17),'*');
        hold off;
    end
end

for ipc = 1:5;
    prcntC = 20*(ipc);
    pcA = all(OFeasibleMinMass(:,8) == prcntC,2); %End cube size hold
    OFeasiblePC = OFeasibleMinMass(logical(pcA),:);
    
    Empty = isempty(OFeasiblePC);
    
    if Empty == 1;
    else
        % Inputs CONSTANT PRCNT C
        acPC = OFeasiblePC(:,1);
        omegaPC = OFeasiblePC(:,5);
        
        %Outputs CONSTANT PRCNT C
        powerPC = OFeasiblePC(:,14) + 2*OFeasiblePC(:,13);
        massPC = OFeasiblePC(:,17);
        
        figure
        subplot(2,1,1);
        hold on;
        plot3(acPC,omegaPC,powerPC,'-o');
        xlabel('G'); ylabel('Omega'); zlabel('TOTAL Power');
        title(['PRCNT C=' num2str(prcntC) ' MIN MASS PARAMS']);
        plot3(MMP(1),MMP(5),MMP(14)+2*MMP(13),'*');
        hold off;
        
        subplot(2,1,2);
        hold on;
        plot3(acPC,omegaPC,massPC,'-o');
        xlabel('G'); ylabel('Omega'); zlabel('TOTAL Mass');
        title(['PRCNT C=' num2str(prcntC) ', MIN MASS PARAMS']);
        plot3(MMP(1),MMP(5),MMP(17),'*');
        hold off;
    end
end


%% For min power parameter states
for omegaPC = 1:10;
    wA = all(OFeasibleMinPower(:,5) == omegaPC,2); %RPM hold
    OFeasibleW = OFeasibleMinPower(logical(wA),:);
    
    Empty = isempty(OFeasibleW);
    
    if Empty == 1;
    else
        %Inputs CONSTANT OMEGA
        acW = OFeasibleW(:,1);
        prcntCW = OFeasibleW(:,8);
        
        %Outputs CONSTANT OMEGA
        powerW = OFeasibleW(:,14) + 2*OFeasibleW(:,13);
        massW = OFeasibleW(:,17);
        
        figure
        subplot(2,1,1);
        hold on;
        plot3(acW,prcntCW,powerW,'-o');
        xlabel('G'); ylabel('Prcnt C'); zlabel('TOTAL Power');
        title(['OMEGA=' num2str(omegaPC) ' MIN POWER PARAMS']);
        plot3(MPP(1),MPP(8),MPP(14)+2*MPP(13),'*');
        hold off;
        
        subplot(2,1,2);
        hold on;
        plot3(acW,prcntCW,massW,'-o');
        xlabel('G'); ylabel('Prcnt C'); zlabel('TOTAL Mass');
        title(['OMEGA=' num2str(omegaPC) ' MIN POWER PARAMS']);
        plot3(MPP(1),MPP(8),MPP(17),'*');
        hold off;
    end
end

for ipc = 1:5;
    prcntC = 20*(ipc);
    pcA = all(OFeasibleMinPower(:,8) == prcntC,2); %End cube size hold
    OFeasiblePC = OFeasibleMinPower(logical(pcA),:);
    
    Empty = isempty(OFeasiblePC);
    
    if Empty == 1;
    else
        % Inputs CONSTANT PRCNT C
        acPC = OFeasiblePC(:,1);
        omegaPC = OFeasiblePC(:,5);
        
        %Outputs CONSTANT PRCNT C
        powerPC = OFeasiblePC(:,14) + 2*OFeasiblePC(:,13);
        massPC = OFeasiblePC(:,17);
        
        figure
        subplot(2,1,1);
        hold on;
        plot3(acPC,omegaPC,powerPC,'-o');
        xlabel('G'); ylabel('Omega'); zlabel('TOTAL Power');
        title(['PRCNT C=' num2str(prcntC) ' MIN POWER PARAMS']);
        plot3(MPP(1),MPP(5),MPP(14)+2*MPP(13),'*');
        hold off;
        
        subplot(2,1,2);
        hold on;
        plot3(acPC,omegaPC,massPC,'-o');
        xlabel('G'); ylabel('Omega'); zlabel('TOTAL Mass');
        title(['PRCNT C=' num2str(prcntC) ', MIN POWER PARAMS']);
        plot3(MPP(1),MPP(5),MPP(17),'*');
        hold off;
    end
end


%% For min current parameter states
for omegaPC = 1:10;
    wA = all(OFeasibleMinCurrent(:,5) == omegaPC,2); %RPM hold
    OFeasibleW = OFeasibleMinCurrent(logical(wA),:);
    
    Empty = isempty(OFeasibleW);
    
    if Empty == 1;
    else
        %Inputs CONSTANT OMEGA
        acW = OFeasibleW(:,1);
        prcntCW = OFeasibleW(:,8);
        
        %Outputs CONSTANT OMEGA
        powerW = OFeasibleW(:,14) + 2*OFeasibleW(:,13);
        massW = OFeasibleW(:,17);
        
        figure
        subplot(2,1,1);
        hold on;
        plot3(acW,prcntCW,powerW,'-o');
        xlabel('G'); ylabel('Prcnt C'); zlabel('TOTAL Power');
        title(['OMEGA=' num2str(omegaPC) ' MIN CURRENT PARAMS']);
        plot3(MCurrP(1),MCurrP(8),MCurrP(14)+2*MCurrP(13),'*');
        hold off;
        
        subplot(2,1,2);
        hold on;
        plot3(acW,prcntCW,massW,'-o');
        xlabel('G'); ylabel('Prcnt C'); zlabel('TOTAL Mass');
        title(['OMEGA=' num2str(omegaPC) ' MIN CURRENT PARAMS']);
        plot3(MCurrP(1),MCurrP(8),MCurrP(17),'*');
        hold off;
    end
end

for ipc = 1:5;
    prcntC = 20*(ipc);
    pcA = all(OFeasibleMinCurrent(:,8) == prcntC,2); %End cube size hold
    OFeasiblePC = OFeasibleMinCurrent(logical(pcA),:);
    
    Empty = isempty(OFeasiblePC);
    
    if Empty == 1;
    else
        % Inputs CONSTANT PRCNT C
        acPC = OFeasiblePC(:,1);
        omegaPC = OFeasiblePC(:,5);
        
        %Outputs CONSTANT PRCNT C
        powerPC = OFeasiblePC(:,14) + 2*OFeasiblePC(:,13);
        massPC = OFeasiblePC(:,17);
        
        figure
        subplot(2,1,1);
        hold on;
        plot3(acPC,omegaPC,powerPC,'-o');
        xlabel('G'); ylabel('Omega'); zlabel('TOTAL Power');
        title(['PRCNT C=' num2str(prcntC) ' MIN CURRENT PARAMS']);
        plot3(MCurrP(1),MCurrP(5),MCurrP(14)+2*MCurrP(13),'*');
        hold off;
        
        subplot(2,1,2);
        hold on;
        plot3(acPC,omegaPC,massPC,'-o');
        xlabel('G'); ylabel('Omega'); zlabel('TOTAL Mass');
        title(['PRCNT C=' num2str(prcntC) ', MIN CURRENT PARAMS']);
        plot3(MCurrP(1),MCurrP(5),MCurrP(17),'*');
        hold off;
    end
end


%% For min cost parameter states
for omegaPC = 1:10;
    wA = all(OFeasibleMinCost(:,5) == omegaPC,2); %RPM hold
    OFeasibleW = OFeasibleMinCost(logical(wA),:);
    
    Empty = isempty(OFeasibleW);
    
    if Empty == 1;
    else
        %Inputs CONSTANT OMEGA
        acW = OFeasibleW(:,1);
        prcntCW = OFeasibleW(:,8);
        
        %Outputs CONSTANT OMEGA
        powerW = OFeasibleW(:,14) + 2*OFeasibleW(:,13);
        massW = OFeasibleW(:,17);
        
        figure
        subplot(2,1,1);
        hold on;
        plot3(acW,prcntCW,powerW,'-o');
        xlabel('G'); ylabel('Prcnt C'); zlabel('TOTAL Power');
        title(['OMEGA=' num2str(omegaPC) ' MIN COST PARAMS']);
        plot3(MCostP(1),MCostP(8),MCostP(14)+2*MCostP(13),'*');
        hold off;
        
        subplot(2,1,2);
        hold on;
        plot3(acW,prcntCW,massW,'-o');
        xlabel('G'); ylabel('Prcnt C'); zlabel('TOTAL Mass');
        title(['OMEGA=' num2str(omegaPC) ' MIN COST PARAMS']);
        plot3(MCostP(1),MCostP(8),MCostP(17),'*');
        hold off;
    end
end

for ipc = 1:5;
    prcntC = 20*(ipc);
    pcA = all(OFeasibleMinCost(:,8) == prcntC,2); %End cube size hold
    OFeasiblePC = OFeasibleMinCost(logical(pcA),:);
    
    Empty = isempty(OFeasiblePC);
    
    if Empty == 1;
    else
        % Inputs CONSTANT PRCNT C
        acPC = OFeasiblePC(:,1);
        omegaPC = OFeasiblePC(:,5);
        
        %Outputs CONSTANT PRCNT C
        powerPC = OFeasiblePC(:,14) + 2*OFeasiblePC(:,13);
        massPC = OFeasiblePC(:,17);
        
        figure
        subplot(2,1,1);
        hold on;
        plot3(acPC,omegaPC,powerPC,'-o');
        xlabel('G'); ylabel('Omega'); zlabel('TOTAL Power');
        title(['PRCNT C=' num2str(prcntC) ' MIN COST PARAMS']);
        plot3(MCostP(1),MCostP(5),MCostP(14)+2*MCostP(13),'*');
        hold off;
        
        subplot(2,1,2);
        hold on;
        plot3(acPC,omegaPC,massPC,'-o');
        xlabel('G'); ylabel('Omega'); zlabel('TOTAL Mass');
        title(['PRCNT C=' num2str(prcntC) ', MIN COST PARAMS']);
        plot3(MCostP(1),MCostP(5),MCostP(17),'*');
        hold off;
    end
end


end