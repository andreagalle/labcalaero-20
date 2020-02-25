%function [KAY,TW,T]=diffbatch(ac_name,state_name);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% diffbatch, subsidary function to TORNADO	%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%	ac_name = name of geometry file (string)
%	state_name=name of state file (string)
%	JID=job identifier, output filename (string)
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
results=[];
i=0;
j=0;

cd aircraft
	load('testgeo2');
cd ..

cd data
	load('teststate');
cd ..

state.alpha=2.5*pi/180;
quest=1;                %Simple state solution, could be something else
                        %but then you'll have to change below too
JID='batchjob';             

nooftests=10;
nooftwists=9;

%figure(4)
%hold on
%grid on

KAY=[0 0;0 0];
for i=1:nooftests
 geo.T=0.1+0.02*i;                               %Change your arbitraty geometry variable here   
for j=1:(nooftwists)
 geo.TW(1,1,2)=(-6+0.2*j)*pi/180;           %Change your arbitraty geometry variable here
  

[lattice,ref]=fLattice_setup(geo,state);
solverloop5(results,quest,JID,lattice,state,geo,ref);



cd output
    load batchjob-Cx;
cd ..

outdata1(i,j)=results.CL;
outdata2(i,j)=results.CD;                %Save your outdata here

k=results.CD/(results.CL^2)

KAY(i,j)=k;
TW(j)=geo.TW(1,1,2)
T(i)=geo.T

surf(KAY)
drawnow

end
end


    
    
    
    