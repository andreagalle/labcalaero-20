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
	load('Z6');
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
    a= [2.8100
        2.8100
        2.7000
        2.7900
        2.7800
        2.7500
        2.7500];
    
alpha=a(i)*pi/180;

geo.startz=0;
[Alattice,ref]=fLattice_setup2(geo,state,latticetype);

Alattice=wingrotation2(1,geo,Alattice,[0 1 0],[0 0 0],alpha);

[s,void]=size(Alattice.N);


h=3*[0.0782
    0.0997
    0.1497
    0.2499
    0.3497
    0.5000
    0.7497];


geo.startz=-2*h(i);
[Glattice,void]=fLattice_setup2(geo,state,latticetype);
Glattice=wingrotation2(1,geo,Glattice,[0 1 0],[0 0 geo.startz],-alpha);






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
OUT.CL_a(i)=results.CL_a*pi/180;
OUT.CD(i)=results.CD;
OUT.h(i)=h(i);
end

%cd(settings.odir)
%    load batchjob-Cx;
%cd(settings.hdir)






    
    
    
    