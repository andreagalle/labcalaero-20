function [A,M]=tornadobatch(ac_name,state_name);
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
settings=config('startup');

cd(settings.acdir)
	load('A320_jig3');
cd(settings.hdir)

cd(settings.sdir)
	load('ABstate');
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

%state.pgcorr=0;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


lattictype=1;%Standard VLM
%lattictype=0;%Tornado freestream following wake VLM




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

%ref=ref;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
a=sum(geo.b(1,:));
geo.ny(1,5)=5;

b1=geo.b(1,5)
b2=b1*6;

b=sum(geo.b(1,:));


elong=a/b

T1=geo.T(1,5);
T2=1-(1-T1)*b2/b1;

geo.b(1,5)=b2;
geo.T(1,5)=T2;


b=sum(geo.b(1,:));


elong=a/b


geo.TW(1,4,2)=geo.TW(1,4,2)-3*pi/180;
geo.TW(1,5,1)=geo.TW(1,5,1)-3*pi/180;
geo.TW(1,5,2)=geo.TW(1,5,2)-6*pi/180;


cd aircraft
    save 0_Morph_m2 geo
cd ..
    



[lattice,ref]=fLattice_setup2(geo,state,lattictype); 
geometryplot(lattice,geo,ref);












return
j=0;
for i=1:30:270;
j=j+1;
    state.AS=i;
    
[state.rho sos p_1]=ISAtmosphere(state.ALT);
        M(j)=state.AS/sos;
    
state.pgcorr=0;     
[lattice,ref]=fLattice_setup2(geo,state,lattictype);   
[results]=solver9(results,state,geo,lattice,ref);
[results]=coeff_create3(results,lattice,state,ref,geo);
A(j,1)=results.CL_a;

state.pgcorr=1;
[lattice,ref]=fLattice_setup2(geo,state,lattictype);
[results]=solver9(results,state,geo,lattice,ref);
[results]=coeff_create3(results,lattice,state,ref,geo);
A(j,2)=results.CL_a;

state.pgcorr=2;
[lattice,ref]=fLattice_setup2(geo,state,lattictype);
[results]=solver9(results,state,geo,lattice,ref);
[results]=coeff_create3(results,lattice,state,ref,geo);
    
 A(j,3)=results.CL_a;
 results.dwcond
end  


plot(M,A(:,1))
hold on
plot(M,A(:,2),'r')
plot(M,A(:,3),'g')
    