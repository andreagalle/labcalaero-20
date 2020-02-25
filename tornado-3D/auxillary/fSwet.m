function [Swet,vol]=fSwet(geo)
%Haven't written anything here yet



loopsperwing=geo.nelem;
noofloops=loopsperwing;
noofwings=size(loopsperwing');


for s=1:noofwings			%Intermediate variable setuploop
	CHORDS(s,1)=geo.c(s);		%calculating chords of first element
end


for s=1:noofwings
	for t=1:(noofloops(s))
      %Looping trough all quads
      CHORDS(s,t+1)=CHORDS(s,t)*geo.T(s,t);	%calculating
   end
end


for s=1:noofwings
	for t=1:(noofloops(s))
      
      %Looping trough all quads
      CHORDS(s,t+1)=CHORDS(s,t)*geo.T(s,t);	%calculating
        
        try
        cd aircraft
        cd airfoil
            A=load(char(geo.foil(s,t,1)));
            B=load(char(geo.foil(s,t,2)));
        cd ..
        cd ..
        catch
            disp('Ouuaaah!')
        end
        
        
        %reorder
        ind=(A(1,1)+2);
        A2=flipud(A(ind:end,:));
        A3=A(2:ind-1,:);
        A4=[A2
            A3];
        
        ind=(B(1,1)+2);
        B2=flipud(B(ind:end,:));
        B3=B(2:ind-1,:);
        B4=[B2
            B3];
        %end reorder
        
        LwetA=sum(sqrt(sum((diff(A4*CHORDS(s,t))).^2,2)));
        LwetB=sum(sqrt(sum((diff(B4*CHORDS(s,t+1))).^2,2)));
        
        
        Swet(s,t)=(LwetA+LwetB)/2*geo.b(s,t);

        C_mgc=(CHORDS(s,t)+CHORDS(s,t+1))/2;
        
        
      
    end
end