function O = coilcalcsallplots

Oall = coilcalcsiteration;

for im = 1:6;
    matnum = im;
    for ig = 1:8;
        [Gauges] = [20, 22, 24, 26, 28, 30, 35, 40];
        gauge = Gauges(ig);
        for iti = 1:6;
            time = 4*iti;
            for itu = 1:6;
                turns = itu*50;
                for in = 1:4;
                    numcoils = in;
                    
                    imA = all(Oall(:,2) == matnum,2);
                    gA = all(Oall(:,3) == gauge,2);
                    tiA = all(Oall(:,4) == time,2);
                    tuA = all(Oall(:,6) == turns,2);
                    inA = all(Oall(:,7) == numcoils,2);
                    
                    OFeasible = Oall(logical(imA.*gA.*tiA.*tuA.*inA),:);
                    
                    E = isempty(OFeasible);
                    
                    %                     a = 8*6*6*4*(im-1);
                    %                     b = 6*6*4*(ig-1);
                    %                     c = 6*4*(iti-1);
                    %                     d = 4*(itu-1);
                    %                     e = in;
                    %
                    %                     i = a+b+c+d+e;
                    
                    if E == 1;
                    else
                        [O] = coilcalcsplotter(OFeasible,matnum,gauge,time,turns,numcoils);
                    end
                end
            end
        end
    end
end
end

