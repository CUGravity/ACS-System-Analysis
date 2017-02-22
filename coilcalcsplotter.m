function coilcalcsplotter

% Outputs to the function are:
%   Oall                    :
%   MMP                     :
%   MPP                     :
%   MVP                     :
%   MCostP                  :
%   MVCuP                   :
%   OFeasibleMinMass        :
%   OFeasibleMinPower       :
%   OFeasibleMinVoltage     :
%   OFeasibleMinCost        :
%   OFeasibleMinVoltsCu     :

clear; clc; close all;
%% Feasible Sets

%MIN MASS
[Oall,MMP,MPP,MVP,MCostP,MVCuP] = coilcalcsiteration;

imMMP = all(Oall(:,2) == MMP(:,2),2); %Material set
gMMP = all(Oall(:,3) == MMP(:,3),2); %Gauge set
tiMMP = all(Oall(:,4) == MMP(:,4),2); %Time set
tuMMP = all(Oall(:,6) == MMP(:,6),2); %Turn set
pcMMP = all(Oall(:,8) == MMP(:,8),2); %Prcnt C set
inMMP = all(Oall(:,7) == MMP(:,7),2); %Num coils set

%Set of all output states with the input parameters of min mass state:
OFeasibleMinMass = Oall(logical(imMMP.*gMMP.*tiMMP.*tuMMP.*pcMMP.*inMMP),:);

%MIN POWER
imMPP = all(Oall(:,2) == MPP(:,2),2); %Material set
gMPP = all(Oall(:,3) == MPP(:,3),2); %Gauge set
tiMPP = all(Oall(:,4) == MPP(:,4),2); %Time set
tuMPP = all(Oall(:,6) == MPP(:,6),2); %Turn set
pcMPP = all(Oall(:,8) == MPP(:,8),2); %Prcnt C set
inMPP = all(Oall(:,7) == MPP(:,7),2); %Num coils set

%Set of all output states with the input parameters of min power state:
OFeasibleMinPower = Oall(logical(imMPP.*gMPP.*tiMPP.*tuMPP.*pcMPP.*inMPP),:);

%MIN VOLTAGE
imMVP = all(Oall(:,2) == MVP(:,2),2); %Material set
gMVP = all(Oall(:,3) == MVP(:,3),2); %Gauge set
tiMVP = all(Oall(:,4) == MVP(:,4),2); %Time set
tuMVP = all(Oall(:,6) == MVP(:,6),2); %Turn set
pcMVP = all(Oall(:,8) == MVP(:,8),2); %Prcnt C set
inMVP = all(Oall(:,7) == MVP(:,7),2); %Num coils set

%Set of all output states with the input parameters of min voltage state:
OFeasibleMinVoltage = Oall(logical(imMVP.*gMVP.*tiMVP.*tuMVP.*pcMVP.*inMVP),:);

%MIN COST
imMCostP = all(Oall(:,2) == MCostP(:,2),2); %Material set
gMCostP = all(Oall(:,3) == MCostP(:,3),2); %Gauge set
tiMCostP = all(Oall(:,4) == MCostP(:,4),2); %Time set
tuMCostP = all(Oall(:,6) == MCostP(:,6),2); %Turn set
pcMCostP = all(Oall(:,8) == MCostP(:,8),2); %Prcnt C set
inMCostP = all(Oall(:,7) == MCostP(:,7),2); %Num coils set

%Set of all output states with the input parameters of min cost state:
OFeasibleMinCost = Oall(logical(imMCostP.*gMCostP.*tiMCostP.*tuMCostP.*pcMCostP.*inMCostP),:);

%MIN VOLTS Cu
imMVCuP = all(Oall(:,2) == MVCuP(:,2),2); %Material set
gMVCuP = all(Oall(:,3) == MVCuP(:,3),2); %Gauge set
tiMVCuP = all(Oall(:,4) == MVCuP(:,4),2); %Time set
tuMVCuP = all(Oall(:,6) == MVCuP(:,6),2); %Turn set
pcMVCuP = all(Oall(:,8) == MVCuP(:,8),2); %Prcnt C set
inMVCuP = all(Oall(:,7) == MVCuP(:,7),2); %Num coils set

%Set of all output states with the input parameters of min cost state:
OFeasibleMinVoltsCu = Oall(logical(imMVCuP.*gMVCuP.*tiMVCuP.*tuMVCuP.*pcMVCuP.*inMVCuP),:);

%% Plotter - For min mass parameter states

% Inputs
acPC = OFeasibleMinMass(:,1);
omegaPC = OFeasibleMinMass(:,5);

%Outputs
powerPC = OFeasibleMinMass(:,14) + 2*OFeasibleMinMass(:,13);
massPC = OFeasibleMinMass(:,17);

figure
subplot(2,1,1);
hold on;
plot3(acPC,omegaPC,powerPC,'o');
xlabel('G'); ylabel('Omega'); zlabel('TOTAL Power');
title('MIN MASS PARAMS, P = f(w,ac)');
MP = plot3(MMP(1),MMP(5),MMP(14)+2*MMP(13),'*');
CP = plot3(MVCuP(1),MVCuP(5),MVCuP(14)+2*MVCuP(13),'x');
legend([MP,CP],'Min mass pt','Chosen pt');
hold off;

subplot(2,1,2);
hold on;
plot3(acPC,omegaPC,massPC,'o');
xlabel('G'); ylabel('Omega'); zlabel('TOTAL Mass');
title('MIN MASS PARAMS, M = f(w,ac)');
MP = plot3(MMP(1),MMP(5),MMP(17),'*');
CP = plot3(MVCuP(1),MVCuP(5),MVCuP(17),'x');
legend([MP,CP],'Min mass pt','Chosen pt');
hold off;


%% For min power parameter states

% Inputs
acPC = OFeasibleMinPower(:,1);
omegaPC = OFeasibleMinPower(:,5);

%Outputs
powerPC = OFeasibleMinPower(:,14) + 2*OFeasibleMinPower(:,13);
massPC = OFeasibleMinPower(:,17);

figure
subplot(2,1,1);
hold on;
plot3(acPC,omegaPC,powerPC,'o');
xlabel('G'); ylabel('Omega'); zlabel('TOTAL Power');
title('MIN POWER PARAMS, P = f(w,ac)');
MP = plot3(MPP(1),MPP(5),MPP(14)+2*MPP(13),'*');
CP = plot3(MVCuP(1),MVCuP(5),MVCuP(14)+2*MVCuP(13),'x');
legend([MP,CP],'Min power pt','Chosen pt');
hold off;

subplot(2,1,2);
hold on;
plot3(acPC,omegaPC,massPC,'o');
xlabel('G'); ylabel('Omega'); zlabel('TOTAL Mass');
title('MIN POWER PARAMS, M = f(w,ac)');
MP = plot3(MPP(1),MPP(5),MPP(17),'*');
CP = plot3(MVCuP(1),MVCuP(5),MVCuP(17),'x');
legend([MP,CP],'Min power pt','Chosen pt');
hold off;


%% For min voltage parameter states

% Inputs
acPC = OFeasibleMinVoltage(:,1);
omegaPC = OFeasibleMinVoltage(:,5);

%Outputs
powerPC = OFeasibleMinVoltage(:,14) + 2*OFeasibleMinVoltage(:,13);
massPC = OFeasibleMinVoltage(:,17);

figure
subplot(2,1,1);
hold on;
plot3(acPC,omegaPC,powerPC,'o');
xlabel('G'); ylabel('Omega'); zlabel('TOTAL Power');
title('MIN VOLTAGE PARAMS, P = f(w,ac)');
MP = plot3(MVP(1),MVP(5),MVP(14)+2*MVP(13),'*');
CP = plot3(MVCuP(1),MVCuP(5),MVCuP(14)+2*MVCuP(13),'x');
legend([MP,CP],'Min volts pt','Chosen pt');
hold off;

subplot(2,1,2);
hold on;
plot3(acPC,omegaPC,massPC,'o');
xlabel('G'); ylabel('Omega'); zlabel('TOTAL Mass');
title('MIN VOLTAGE PARAMS, M = f(w,ac)');
MP = plot3(MVP(1),MVP(5),MVP(17),'*');
CP = plot3(MVCuP(1),MVCuP(5),MVCuP(17),'x');
legend([MP,CP],'Min volts pt','Chosen pt');
hold off;


%% For min cost parameter states

% Inputs
acPC = OFeasibleMinCost(:,1);
omegaPC = OFeasibleMinCost(:,5);

%Outputs
powerPC = OFeasibleMinCost(:,14) + 2*OFeasibleMinCost(:,13);
massPC = OFeasibleMinCost(:,17);

figure
subplot(2,1,1);
hold on;
plot3(acPC,omegaPC,powerPC,'o');
xlabel('G'); ylabel('Omega'); zlabel('TOTAL Power');
title('MIN COST PARAMS, P = f(w,ac)');
MP = plot3(MCostP(1),MCostP(5),MCostP(14)+2*MCostP(13),'*');
CP = plot3(MVCuP(1),MVCuP(5),MVCuP(14)+2*MVCuP(13),'x');
legend([MP,CP],'Min cost pt','Chosen pt');
hold off;

subplot(2,1,2);
hold on;
plot3(acPC,omegaPC,massPC,'o');
xlabel('G'); ylabel('Omega'); zlabel('TOTAL Mass');
title('MIN COST PARAMS, M = f(w,ac)');
MP = plot3(MCostP(1),MCostP(5),MCostP(17),'*');
CP = plot3(MVCuP(1),MVCuP(5),MVCuP(17),'x');
legend([MP,CP],'Min cost pt','Chosen pt');
hold off;

%% For min voltage Copper parameter states

% Inputs
acPC = OFeasibleMinVoltsCu(:,1);
omegaPC = OFeasibleMinVoltsCu(:,5);

%Outputs
powerPC = OFeasibleMinVoltsCu(:,14) + 2*OFeasibleMinVoltsCu(:,13);
massPC = OFeasibleMinVoltsCu(:,17);

figure
subplot(2,1,1);
hold on;
plot3(acPC,omegaPC,powerPC,'o');
xlabel('G'); ylabel('Omega'); zlabel('TOTAL Power');
title('CHOSEN POINT PARAMS, P = f(w,ac)');
CP = plot3(MVCuP(1),MVCuP(5),MVCuP(14)+2*MVCuP(13),'x');
legend(CP,'Chosen pt');
hold off;

subplot(2,1,2);
hold on;
plot3(acPC,omegaPC,massPC,'o');
xlabel('G'); ylabel('Omega'); zlabel('TOTAL Mass');
title('CHOSEN POINT PARAMS, M = f(w,ac)');
CP = plot3(MVCuP(1),MVCuP(5),MVCuP(17),'x');
legend(CP,'Chosen pt');
hold off;

end