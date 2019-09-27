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
	load('zconv1');
cd ..
geo.nx=5;
geo.ny=1;

cd data
	load('teststate');
cd ..

state.alpha=2*pi/180;
quest=1;                %Simple state solution, could be something else
                        %but then you'll have to change below too
JID='batchjob';             


  
for j=1:(100)
 
  

[lattice,ref]=fLattice_setup(geo,state);
solverloop5(results,quest,JID,lattice,state,geo,ref);



cd output
    load batchjob-Cx;
cd ..

outdata(j,1)=results.CL;
outdata(j,2)=results.CD;                %Save your outdata here
outdata(j,3)=results.Cm;


plot(j,outdata(j,2),'*')
hold on
drawnow
geo.nx(1)=geo.nx+1;           %Change your arbitraty geometry variable here
end



    
    
    
    