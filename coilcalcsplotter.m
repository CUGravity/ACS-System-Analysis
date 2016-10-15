function [OFeasible] = coilcalcsplotter(matnum,gauge,time,turns,numcoils)

Oall = coilcalcsiteration;

imA = all(Oall(:,2) == matnum,2); %Material set
gA = all(Oall(:,3) == gauge,2); %Gauge set
tiA = all(Oall(:,4) == time,2); %Time set
tuA = all(Oall(:,6) == turns,2); %Turn set
inA = all(Oall(:,7) == numcoils,2); %Num coils set

OFeasible = Oall(logical(imA.*gA.*tiA.*tuA.*inA),:);

for omegaPC = 1:7;
    wA = all(OFeasible(:,5) == omegaPC,2); %RPM hold
    OFeasibleW = OFeasible(logical(wA),:);
    
    Empty = isempty(OFeasibleW);
    
    if Empty == 1;
    else
        %Inputs CONSTANT OMEGA
        acW = OFeasibleW(:,1);
        prcntCW = OFeasibleW(:,8);
        
        %Outputs CONSTANT OMEGA
        powerW = OFeasibleW(:,12);
        massW = OFeasibleW(:,13);
        
        figure
        plot3(acW,prcntCW,powerW,'o');
        xlabel('G'); ylabel('Prcnt C'); zlabel('Power');
        title(['OMEGA=' num2str(omegaPC) ', Mat=' num2str(matnum) ', Gauge=' num2str(gauge) ', Time=' num2str(time) ', Turns=' num2str(turns) ', Num Coils =' num2str(numcoils) '']);
        
        figure
        plot3(acW,prcntCW,massW,'o');
        xlabel('G'); ylabel('Prcnt C'); zlabel('Mass');
        title(['OMEGA=' num2str(omegaPC) ', Mat=' num2str(matnum) ', Gauge=' num2str(gauge) ', Time=' num2str(time) ', Turns=' num2str(turns) ', Num Coils =' num2str(numcoils) '']);
    end
end

for ipc = 1:5;
    prcntC = 20*(ipc);
    pcA = all(OFeasible(:,8) == prcntC,2); %End cube size hold
    OFeasiblePC = OFeasible(logical(pcA),:);
    
    Empty = isempty(OFeasiblePC);
    
    if Empty == 1;
    else
        % Inputs CONSTANT PRCNT C
        acPC = OFeasiblePC(:,1);
        omegaPC = OFeasiblePC(:,5);
        
        %Outputs CONSTANT PRCNT C
        powerPC = OFeasiblePC(:,12);
        massPC = OFeasiblePC(:,13);
        
        figure
        plot3(acPC,omegaPC,powerPC,'o');
        xlabel('G'); ylabel('Omega'); zlabel('Power');
        title(['PRCNT C=' num2str(prcntC) ', Mat=' num2str(matnum) ', Gauge=' num2str(gauge) ', Time=' num2str(time) ', Turns=' num2str(turns) ', Num Coils =' num2str(numcoils) '']);
        
        figure
        plot3(acPC,omegaPC,massPC,'o');
        xlabel('G'); ylabel('Omega'); zlabel('Mass');
        title(['PRCNT C=' num2str(prcntC) ', Mat=' num2str(matnum) ', Gauge=' num2str(gauge) ', Time=' num2str(time) ', Turns=' num2str(turns) ', Num Coils =' num2str(numcoils) '']);
    end
end

end