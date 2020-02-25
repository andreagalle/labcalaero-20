function [OUT]=tornadobatch(ac_name,state_name);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% tornadobatch, subsidary function to TORNADO	
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
settings=config('startup')

cd(settings.acdir)
	load('Z2');
cd(settings.hdir)

cd(settings.sdir)
	load('E4');
cd(settings.hdir)


quest=1;                %Simple state solution, could be something else
                        %but then you'll have to change below too,
                        %especially the "Load data" section.
JID='batchjob';             

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CHANGE GEOMETRY
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Here you may enter whatever changes to the geometry you like
%
% Examples:
%   Change number of panels for easy grid convergence.
%   Change a rudder setting, or tailplane twist for trim computations
%   Change the geometry in any other way.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

geo=geo;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%






%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CHANGE STATE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Here you may enter whatever changes to the state you like
%
% Examples:
%   Change angle of attack or sideslip.
%   Change altitude, airspeed or ainything else
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

state.PGcorr=0;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


latticetype=1;%Standard VLM
%latticetype=0;%Tornado freestream following wake VLM
for i=1:7;
    a= [    2.8500
    2.8400
    2.7200
    2.7300
    2.7500
    2.7400
    2.7100];
    
alpha=a(i)*pi/180;


[Alattice,ref]=fLattice_setup2(geo,state,latticetype);

Alattice=wingrotation2(1,geo,Alattice,[0 1 0],[0 0 0],alpha)

[s,void]=size(Alattice.N);



cd(settings.acdir)
	load('ground1');
cd(settings.hdir)

geo.b=20;
geo.c=geo.b;
geo.startx=-geo.c/2
geo.starty=-geo.b/2
geo.nx=3;
geo.ny=3;


h=4*[0.0622
     0.0753
     0.1004
     0.1501
     0.2500
     0.3501
     0.4998
     0.6744];
 
geo.startz=-h(i);
[Glattice,void]=fLattice_setup2(geo,state,latticetype);


cd(settings.acdir)
	load('Z2');
cd(settings.hdir)




lattice.XYZ=[Alattice.XYZ;Glattice.XYZ];
lattice.N=[Alattice.N;Glattice.N];
lattice.COLLOC=[Alattice.COLLOC;Glattice.COLLOC];
lattice.VORTEX=[Alattice.VORTEX;Glattice.VORTEX];


geometryplot(lattice,geo,ref)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CHANGE Reference values.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Here you may enter whatever changes to the state Reference 
% you values like.
%
% Examples:
%   Set the reference spane to a constant.
%  
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

ref=ref;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[results]=solver9(results,state,geo,lattice,ref);

Aresults.F=results.F(1:s,:,:);
Aresults.M=results.M(1:s,:,:);
Aresults.gamma=results.gamma(1:s,:);

Aresults.FORCE=sum(Aresults.F,1);			%Total force
Aresults.MOMENTS=sum(Aresults.M,1);			%Summing up moments	



[results]=coeff_create3(Aresults,Alattice,state,ref,geo);

%disp(results.dwcond);

OUT.CL(i)=results.CL;
OUT.CL_a(i)=results.CL_a;
OUT.CD(i)=results.CD;
OUT.h(i)=h(i);
end

%cd(settings.odir)
%    load batchjob-Cx;
%cd(settings.hdir)






    
    
    
    