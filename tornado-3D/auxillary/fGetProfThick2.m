function [t1, t2]=fGetProfThick(foils,sparpos)
%  Input: 2 airfoils per partition: inboard & outboard
%  INPUT: foils = {'name1', 'name2'};
%  Input: spar location where thickness of airfoil is required (%chord)
%  Output: t=thikness of airfoil at sparloc for airfoils (%chord)
%  aenmu

for k = 1:2
    foil=(foils(1,1,k));

    if isempty(str2num((cell2mat(foil))))==0
        TYPE=1;       %Naca xxxx profile, see case 1
    elseif isempty(str2num((cell2mat(foil))))
        TYPE=2;       %Airfoil from file, see case 2
    end

    switch TYPE

        case 1

            foil  = str2num(cell2mat(foil));
            m     = fix(foil/1000);	%gives first NACA-4 number      -> max camber
            lemma = foil-m*1000;
            p     = fix(lemma/100);	%gives second NACA-4 number     -> pos of max camber
            lemma = (foil-m*1000)-p*100;
            tk    = lemma/100;     %                                -> max thikness      
        
            for i = 1:max(size(sparpos))
                x = sparpos(i);
                Yt = 5*tk*(0.2969*x^0.5 - 0.126*x - 0.3516*x^2 + 0.2843*x^3 - 0.1015*x^4);
                if sparpos(i) <= p
                    Yc=f*(1/p^2)*(2*p*x - x ^2);
                    tanteta = f*(1/p^2)*(2*p - 2*x);                
                else
                    Yc=f*(1/(1-p)^2)*(1-2*p+2*p*x - x^2);
                    tanteta=f*(1/(1-p)^2)*(2*p - 2*x);
                end
                Yup  = Yc + Yt*cos(atan(tanteta));
                Ylow = Yc - Yt*cos(atan(tanteta));
                t(i) = Yup - Ylow;
            end

          
        case 2
    
            %The airfoil is descriped as a coordinate file for upper and lower surfaces
            cd aircraft
            cd airfoil
                A=load(char(foil));
            cd ..
            cd ..

            % Take the number of data points in the data file
            L=A(1,1);
        
            %Upper surface
            Xu = A(2:L+1,1)/A(L+1,1); %% It is divided by A(L+1,1), which is the max absciss of the aifoil, in order to normalize the airfoil to a chord c=1
            Yu = A(2:L+1,2)/A(L+1,1);

            % Lower surface
            Xl = A(L+2:end,1)/A(L+1,1);
            Yl = A(L+2:end,2)/A(L+1,1);

            for i = 1:max(size(sparpos))
                t(i) = interp1(Xu,Yu, sparpos(i)) - interp1(Xl,Yl, sparpos(i));
            end
            
    end%switch
    
    if k==1
        A = t;  %inboard airfoil: spar thicknesses
    else
        B = t;  %outboard airfoil: spar thicknesses
    end
end;    %end of 'k' for loop


end%function
