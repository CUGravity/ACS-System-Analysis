function [radius,torque,current,voltageEnd,powerEnd,voltageCenter,powerCenter,...
    massEnd,massCenter,massTotal,MinCost] = ...
    coilcalcs(acceleration,w,time,turns,numcoils,material,gauge,prcntC,prcntT,sf,EndCoils)

%KNOWN CONST
l = 0.1;        % Length (in meters)
m = 1.33;       % Mass (in kilograms)
B = 0.25e-4;    % Earth magnetic field (in Tesla)

%MATERIALS
if strcmp('Cu',material)
    p = 1.68e-8;                            % Ohm m (copper)
    Density = 8960;                         % kg/m^3 density of copper
    MinCostPerPound = 2.17;                 % Cost
    MinCostPerkg = MinCostPerPound*0.4536;

elseif strcmp('Au',material)                % Gold
    p = 2.44e-8;
    Density = 19300;
    MinCostPerkg = 41024.83;

elseif strcmp('Ag',material) %Silver
    p = 1.59e-8;
    Density = 10490;
    MinCostPerkg = 570.90;

elseif strcmp('Al7050',material) %Aluminum 7050
    p = 2.82e-8;
    Density = 2800;
    MinCostPerPound = 0.76;
    MinCostPerkg = MinCostPerPound*0.4536;

elseif strcmp('Al7178',material) %Aluminum 7178
    p = 2.82e-8;
    Density = 2830;
    MinCostPerPound = 0.76;
    MinCostPerkg = MinCostPerPound*0.4536;

elseif strcmp('NiCh',material) %Nickel-Chrome
    p = 1.1e-6;
    Density = 8400;
    MinCostPerPound = 4.50;
    MinCostPerkg = MinCostPerPound*0.4536;

elseif strcmp('Nb',material) %Niobium
    p = 1.52e-8;
    Density = 8570;
    MinCostPerkg = 180;

elseif strcmp('Ta',material) %Tantalum
    p = 1.31e-8;
    Density = 16690;
    MinCostPerkg = 150;

elseif strcmp('Ni',material) %Nickel
    p = 6.93e-8;
    Density = 8908;
    MinCostPerPound = 4.66;
    MinCostPerkg = MinCostPerPound*0.4536;

else % default
    p = 1.68e-8; % Ohm m (copper)
    Density = 8960; % kg/m^3 density of copper
    MinCostPerPound = 2.17;
    MinCostPerkg = MinCostPerPound*0.4536;
end

%GAUGES
switch gauge
    case 5
        r = 4.621/1000;
        Ac = pi*r^2;
    case 10
        r = 2.588/1000;
        Ac = pi*r^2;
    case 15
        r = 1.45/1000;
        Ac = pi*r^2;
    case 20
        r = 0.812/1000;
        Ac = pi*r^2;
    case 22
        r = 0.644/1000;
        Ac = pi*r^2;
    case 24
        Ac = 8.2e-7; %m^2 - 24 gauge (0.511 mm)
    case 26
        r = 0.405/1000;
        Ac = pi*r^2;
    case 28
        r = 0.321/1000;
        Ac = pi*r^2;
    case 30
        r = 0.255/1000;
        Ac = pi*r^2;
    case 35
        r = 0.143/1000;
        Ac = pi*r^2;
    case 40
        r = 0.0799/1000;
        Ac = pi*r^2;
    otherwise % default gauge = 24
        Ac = 8.2e-7;
end

%%
acceleration = acceleration*9.81;   % Acceleration (from g's to m/s^2)
w = w*0.1047;                       % Angular speed (from rpm to rad/s)
radius = acceleration/w^2;          % Radius (in meters)

%Undeployed tether (NOT IMPORTANT STATE)-(CALC SLIGHTLY MODED)
if prcntT == 0
    lend = (prcntC/100)*l;
    lcenter = 3*l - 2*lend;
    R = lcenter/2;
    mend = (prcntC/100)*m;
    mcenter = 3*m - 2*mend;
    Iend = (mend/12)*(l^2+lend^2);
    Icenter = (1/2)*(mcenter/12)*(l^2+(lcenter/2)^2);
    Itotal = 2*(Iend + mend*R*R + Icenter);
    time = time*60*60;
    torque = Itotal*w/time;
    
% Deployed tether (IMPORTANT STATE)
else
    R = (prcntT/100)*radius;
    lend = (prcntC/100)*l;                          % End sat size
    lcenter = 3*l - 2*lend;                         % Center sat size
    mend = (prcntC/100)*m;                          % End mass
    mtether = m/4;                                  % Tether mass
    mcenter = 3*m - 2*mend - 2*mtether;             % Center mass
    Iend = (mend/12)*(l^2+lend^2);                  % Moment of inertia end (box)
    Iteth = (mtether)*R*R/3;                        % Moment of inertia tether (cyclinder)
    Icenter = (1/2)*(mcenter/12)*(l^2+lcenter^2);   % Moment of inertia center (box)
    Itotal = 2*(Iend + mend*R*R + Iteth + Icenter); % Total moment of inertia (parallel axis)
    time = time*60*60;      % Time (from hours seconds)
    torque = Itotal*w/time; % Torque
end

%Safety factor on torque
torquesf = torque*sf;

% Aface = l*l; %m^2
L = l-0.02;                 % Coil length size available 
Lend = lend-0.02;           % Coil length size available end
Lcenter = lcenter-0.02;     % Coil length size available center
Aend = (Lend)*(L);          % Area of end sat side
Acenter = (Lcenter)*(L);    % Area of center sat side

k = 1;            % Relative permeability for iron
B_core = B*k;       % New core magnetic moment

if strcmp('yes',EndCoils)
    
    % current needed for torque with all three coils in mag field
    current = torquesf/(turns*numcoils*B_core*(Acenter+Aend+Aend));
    lengthEnd = turns*numcoils*(2*Lend+2*L);                % length of coil wire in end (meters)
    lengthCenter = turns*numcoils*(2*Lcenter+2*L);          % length of coil wire in center (meters)
    
elseif strcmp('no',EndCoils)
    
    % current needed for torque with one central coil in mag field
    current = torquesf/(turns*numcoils*B_core*(Acenter));
    lengthEnd = 0;                                          % length of coil wire in end (meters)
    lengthCenter = turns*numcoils*(2*Lcenter+2*L);          % length of coil wire in center (meters)

else
    
    % current needed for torque with all three coils in mag field
    current = torquesf/(turns*numcoils*B_core*(Acenter+Aend+Aend));
    lengthEnd = turns*numcoils*(2*Lend+2*L);                % length of coil wire in end (meters)
    lengthCenter = turns*numcoils*(2*Lcenter+2*L);          % length of coil wire in center (meters)
end

resisEnd = p*lengthEnd/Ac;              % resistance in end
resisCenter = p*lengthCenter/Ac;        % resistance in center

voltageEnd = current*resisEnd;          %voltage needed at end
powerEnd = voltageEnd*current;          %power draw at end

voltageCenter = current*resisCenter;    %voltage needed in center
powerCenter = voltageCenter*current;    %power draw at center

massEnd = lengthEnd*Ac*Density;         %mass of end sat coils
massCenter = lengthCenter*Ac*Density;   %mass of center sat coils

massTotal = 2*massEnd + massCenter;
MinCost = massTotal*MinCostPerkg;

end