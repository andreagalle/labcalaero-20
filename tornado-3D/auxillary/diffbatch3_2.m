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
	load('TA320htvt_3');
cd ..
geo.nx=[5 5 5
        2 2 0
        1 0 0
        1 0 0];

geo.ny=[2 5 1
        2 2 0
        1 0 0
        1 0 0   ];

geo.meshtype= [1 2 2
               1 1 0
               1 0 0
               1 0 0];
    
    
cd data
	load('teststate');
cd ..

state.alpha=2*pi/180;
quest=11;                %Simple state solution, could be something else
                        %but then you'll have to change below too
JID='batchjob';             


  
for j=1:50
 
  

[lattice,ref]=fLattice_setup(geo,state);
solverloop5(results,quest,JID,lattice,state,geo,ref);



cd output
    load batchjob-Cx;
cd ..

outdata(j,1)=results.CL;
outdata(j,2)=results.CD;                %Save your outdata here
outdata(j,3)=results.Cm;
lemma=sum(geo.ny,2);
outdata(j,4)=lemma(1);
outdata(j,5)=results.dwcond

figure(2)
plot(j,outdata(j,2),'*')
hold on


hold on
drawnow
geo.ny(1,3:end)=geo.ny(1,3:end)+1;           %Change your arbitraty geometry variable here
%geo.nx(1,:)=geo.nx(1,:)+1;
save zlastrun outdata
end
figure(1)
plot(outdata(:,4),1-outdata(:,3)/outdata(end,3))


    
    
    
    