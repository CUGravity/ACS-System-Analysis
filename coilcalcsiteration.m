function Oall = coilcalcsiteration

clear; clc; close all;

[OUTPUTS] = zeros((10*6*8*6*7*6*4*5*2),13);

Materials = {'Cu', 'Al7050', 'Al7178', 'NiCh', 'Nb', 'Ni'};
[Gauges] = [20, 22, 24, 26, 28, 30, 35, 40];

%tic;

for ia = 1:10;
    acceleration = (0.025*ia)+0.13;
    for im = 1:6;
        material = Materials(im);
        for ig = 1:8;
            gauge = Gauges(ig);
            for iti = 1:6;
                time = 4*iti;
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
                                    
                                    [radius,current,power,mass] = ...
                                        coilcalcs(acceleration,w,time,turns,numcoils,...
                                        material,gauge,prcntC,prcntT);

                                        [OUTPUTS(i,:)] = [acceleration,im,...
                                        gauge,time,w,turns,numcoils,prcntC,...
                                        prcntT,radius,current,power,mass];
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
    if OUTPUTS(i,13) > 0.867 %Mass
        [OUTPUTS(i,:)] = 0;
    end
end

for i = 1:length(OUTPUTS);
    if OUTPUTS(i,12) > 3 %Power
        [OUTPUTS(i,:)] = 0;
    end
end

for i = 1:length(OUTPUTS);
    if OUTPUTS(i,11) > 0.25 %Current
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
