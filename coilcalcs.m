function [radius,torque,currentEnd,currentCenter,powerEnd,powerCenter,massEnd,massCenter] = ...
    coilcalcs(acceleration,w,time,turns,numcoils,material,gauge,prcntC,prcntT)
%disp(' ');
%%
%disp(' ----- Inputs ----- ');
% a = 0.1; % gees
% w = 6; % rpm
% t = 24; %hours
% n = 1   00; % turns
% c = 3; % numcoils

%KNOWN CONST
l = 0.1; %m
m = 1.33; %kg
B = 0.5e-4; % tesla

%MATERIALS
if strcmp('Cu',material)
    p = 1.68e-8; % Ohm m (copper)
    Density = 8960; % kg/m^3 density of copper
elseif strcmp('Au',material) %Gold
    p = 2.44e-8;
    Density = 19300;
elseif strcmp('Ag',material) %Silver
    p = 1.59e-8;
    Density = 10490;
elseif strcmp('Al7050',material) %Aluminum 7050
    p = 2.82e-8;
    Density = 2800;
elseif strcmp('Al7178',material) %Aluminum 7178
    p = 2.82e-8;
    Density = 2830;
elseif strcmp('NiCh',material) %Nickel-Chrome
    p = 1.1e-6;
    Density = 8400;
elseif strcmp('Nb',material) %Niobium
    p = 1.52e-8;
    Density = 8570;
elseif strcmp('Ta',material) %Tantalum
    p = 1.31e-8;
    Density = 16690;
elseif strcmp('Ni',material) %Nickel
    p = 6.93e-8;
    Density = 8908;
else % default
    p = 1.68e-8; % Ohm m (copper)
    Density = 8960; % kg/m^3 density of copper
end

%GUAGES
if gauge == 24
    Ac = 8.2e-7; %m^2 - 24 gauge (0.511 mm)
elseif gauge == 5
        r = 4.621/1000;
        Ac = pi*r^2;
elseif gauge == 10
        r = 2.588/1000;
        Ac = pi*r^2;
elseif gauge == 15
        r = 1.45/1000;
        Ac = pi*r^2;
elseif gauge == 20
        r = 0.812/1000;
        Ac = pi*r^2;
elseif gauge == 22
        r = 0.644/1000;
        Ac = pi*r^2;
elseif gauge == 26
        r = 0.405/1000;
        Ac = pi*r^2;
elseif gauge == 28
        r = 0.321/1000;
        Ac = pi*r^2;
elseif gauge == 30
        r = 0.255/1000;
        Ac = pi*r^2;
elseif gauge == 35
        r = 0.143/1000;
        Ac = pi*r^2;
elseif gauge == 40
        r = 0.0799/1000;
        Ac = pi*r^2;
else % default gauge = 24
    Ac = 8.2e-7;
end
% 
% disp(['Acceleration: ',num2str(acceleration),' gees']);
% disp(['Rotation Rate: ',num2str(w),' rpm']);
% disp(['Coil turns: ',num2str(turns),' (',num2str(numcoils),' coils)']);
% disp(['Time to spin up: ',num2str(time),' hours']);
% disp(' ');

%%
%disp(' ----- Outputs ----- ');
acceleration = acceleration*9.81; % m/s^2
w = w*0.1047; %rpm to rad/s
radius = acceleration/w^2; %m
%disp(['Tether Radius: ',num2str(radius),' meters']);

%Undeployed tether (NOT IMPORTANT STATE)-(CALC SLIGHTLY MODED)
if prcntT == 0;
    lend = (prcntC/100)*l;
    lcenter = 3*l - 2*lend;
    R = lcenter/2;
    mend = (prcntC/100)*m;
    mcenter = 3*m - 2*mend;
    Iend = (mend/12)*(l^2+lend^2);
    Icenter = (1/2)*(mcenter/12)*(l^2+lcenter^2);
    Itotal = 2*(Iend + mend*R*R + Icenter);
    time = time*60*60;
    torque = Itotal*w/time;
    
% Deployed tether (IMPORTANT STATE)
else
    R = (prcntT/100)*radius;
    lend = (prcntC/100)*l; % end sat size
    lcenter = 3*l - 2*lend; % center sat size
    mend = (prcntC/100)*m; % end mass
    mcenter = 3*m - 2*mend; % center mass
    Iend = (mend/12)*(l^2+lend^2); % moment of inertia end (box)
    Iteth = (m/4)*R*R/3; %moment of inertia tether (cyclinder)
    Icenter = (1/2)*(mcenter/12)*(l^2+lcenter^2); % moment of inertia center (box)
    Itotal = 2*(Iend + mend*R*R + Iteth + Icenter); %total moment of inertia (parallel axis)
    time = time*60*60;
    torque = Itotal*w/time; %Torque
end

% Aface = l*l; %m^2
Aend = lend*l; % Area of end sat side
Acenter = lcenter*l; % Area of center sat side

currentEnd = (torque/2)/(turns*numcoils*B*(Aend));
% current at the end if half the torque needed (since 2 end sats)
currentCenter = torque/(turns*numcoils*B*(Acenter));
% current at center if all the torque is needed

%disp(['Needed current: ',num2str(current),' Amperes']);

lengthEnd = turns*numcoils*(4*lend+4*l+4*l); % length of coil wire in end (meters)
lengthCenter = turns*numcoils*(4*lcenter+4*l+4*l); %length of coil wire in center (meters)

resisEnd = p*lengthEnd/Ac; % resistance in end
resisCenter = p*lengthCenter/Ac; % resistance in center

voltageEnd = currentEnd*resisEnd; %voltage needed at end
powerEnd = voltageEnd*currentEnd; %power draw at end

voltageCenter = currentCenter*resisCenter; %voltage needed in center
powerCenter = voltageCenter*currentCenter; %power draw at center
%disp(['Power draw: ',num2str(power),' Watts']);

massEnd = lengthEnd*Ac*Density; %mass of end sat coils
massCenter = lengthCenter*Ac*Density; %mass of center sat coils
%disp(['Coil mass: ',num2str(mass),' kg']);

%disp(' ');

end