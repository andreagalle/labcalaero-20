function [results]=coeff_create2(results,lattice,state,ref,geo);  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Coefficient creator: Essential function for TORNADO						
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Computes aerodynamic coefficients			
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%	Author:	Tomas Melin, KTH, Department of Aeronautical 
%                               and Vehicle Engineering	
%			copyright 2003											
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CONTEXT:	Subsidary function for TORNADO					
% Called by:	solverloop											
% Calls:			MATLAB standard functions																			
% Loads:																
% Saves: 												
% Input: 			
% Output: forces moments coefficients							
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
delta=0.01;


q=0.5*state.rho*state.AS^2;					%calculating dynamic pressure
										%for coefficient calculation		
[a b void]=size(results.F);


for s=1:a
	normal_force(s)=squeeze(results.F(s,1,:))'*lattice.N(s,:)';                                
end                                
panel_area=tarea(lattice.XYZ);
stat_press=normal_force./panel_area;	%Delta pressure, top/bottom
results.cp=((stat_press)./(q))';


CX=results.FORCE(:,:,1)/(q*ref.S_ref);
CY=results.FORCE(:,:,2)/(q*ref.S_ref);
CZ=results.FORCE(:,:,3)/(q*ref.S_ref);

B2WTransform=[cos(state.betha)*cos(state.alpha),        -sin(state.betha),          cos(state.betha)*sin(state.alpha) ;...
              cos(state.alpha)*sin(state.betha),         cos(state.betha),          sin(state.betha)*sin(state.alpha) ;...
                              -sin(state.alpha),                        0,                           cos(state.alpha)];
for i=1:b                          
    lemma(i,:)=B2WTransform*squeeze(results.FORCE(:,i,:));
end

D=lemma(:,1)';
C=lemma(:,2)';
L=lemma(:,3)';

CL=L/(q*ref.S_ref);
CD=D/(q*ref.S_ref);
CC=C/(q*ref.S_ref);

Cl=results.MOMENTS(1,:,1)/(q*ref.S_ref*ref.b_ref);
Cm=results.MOMENTS(1,:,2)/(q*ref.S_ref*ref.C_mac);
Cn=results.MOMENTS(1,:,3)/(q*ref.S_ref*ref.b_ref);

try
    if state.pgcorr==1
        [results,state]=fpgcorr(results,state)
    end
end 






%%Setting output
results.L=L(1);
results.D=D(1);
results.C=C(1);

results.CX=CX(:,1);
results.CY=CY(:,1);
results.CZ=CZ(:,1);
results.CL=CL(:,1);
results.CD=CD(:,1);
results.CC=CC(:,1);
results.Cl=Cl(:,1);
results.Cm=Cm(:,1);
results.Cn=Cn(:,1);

results.F=squeeze(results.F(:,1,:));
results.M=squeeze(results.M(:,1,:));

results.FORCE=squeeze(results.FORCE(:,1,:));
results.MOMENTS=squeeze(results.MOMENTS(:,1,:));



delta=config('delta');
fac1=ref.b_ref /(2*state.AS);
fac2=ref.C_mac /(2*state.AS);


%%Differentiating
dCX=(CX-CX(:,1))./delta;
dCY=(CY-CY(:,1))./delta;
dCZ=(CZ-CZ(:,1))./delta;

dCL=(CL-CL(:,1))./delta;
dCD=(CD-CD(:,1))./delta;
dCC=(CC-CC(:,1))./delta;

dCl=(Cl-Cl(:,1))./delta;
dCm=(Cm-Cm(:,1))./delta;
dCn=(Cn-Cn(:,1))./delta;




   results.CL_a=dCL(2);
   results.CD_a=dCD(2);
   results.CC_a=dCC(2);
   results.CX_a=dCX(2);
   results.CY_a=dCY(2);
   results.CZ_a=dCZ(2);
   results.Cl_a=dCl(2);
   results.Cm_a=dCm(2);
   results.Cn_a=dCn(2);
   
   results.CL_b=dCL(3);
   results.CD_b=dCD(3);
   results.CC_b=dCC(3);
   results.CX_b=dCX(3);
   results.CY_b=dCY(3);
   results.CZ_b=dCZ(3);
   results.Cl_b=dCl(3);
   results.Cm_b=dCm(3);
   results.Cn_b=dCn(3);
   
   results.CL_P=dCL(4)/fac1;
   results.CD_P=dCD(4)/fac1;
   results.CC_P=dCC(4)/fac1;
   results.CX_P=dCX(4)/fac1;
   results.CY_P=dCY(4)/fac1;
   results.CZ_P=dCZ(4)/fac1;
   results.Cl_P=dCl(4)/fac1;
   results.Cm_P=dCm(4)/fac1;
   results.Cn_P=dCn(4)/fac1;
   
   results.CL_Q=dCL(5)/fac2;
   results.CD_Q=dCD(5)/fac2;
   results.CC_Q=dCC(5)/fac2;
   results.CX_Q=dCX(5)/fac2;
   results.CY_Q=dCY(5)/fac2;
   results.CZ_Q=dCZ(5)/fac2;
   results.Cl_Q=dCl(5)/fac2;
   results.Cm_Q=dCm(5)/fac2;
   results.Cn_Q=dCn(5)/fac2;
   
   results.CL_R=dCL(6)/fac1;
   results.CD_R=dCD(6)/fac1;
   results.CC_R=dCC(6)/fac1;
   results.CX_R=dCX(6)/fac1;
   results.CY_R=dCY(6)/fac1;
   results.CZ_R=dCZ(6)/fac1;
   results.Cl_R=dCl(6)/fac1;
   results.Cm_R=dCm(6)/fac1;
   results.Cn_R=dCn(6)/fac1;
   
   try
    results.CL_d=dCL(7:end);
    results.CD_d=dCD(7:end);
    results.CC_d=dCC(7:end);
    results.CX_d=dCX(7:end);
    results.CY_d=dCY(7:end);
    results.CZ_d=dCZ(7:end);
    results.Cl_d=dCl(7:end);
    results.Cm_d=dCm(7:end);
    results.Cn_d=dCn(7:end);
   end

[results]=spanload6(results,geo,lattice,state);
end%function
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [results,state]=fpgcorr(results,state)
%Prandtl Glauert correction
[state.rho a p_1]=ISAtmosphere(state.ALT);

M=state.AS/a;
corr=1/(sqrt(1-M^2));

         
results.F=results.F*corr;
results.FORCE=results.FORCE*corr;
results.M =results.M*corr;
results.MOMENTS=results.MOMENTS*corr; 

results.cp=results.cp*corr; 
results.CX=results.CX*corr; 
results.CY=results.CY*corr; 
results.CZ=results.CZ*corr; 
results.D=results.D*corr; 
results.C=results.C*corr; 
results.L=results.L*corr; 
results.CL=results.CL*corr; 
results.CD=results.CD*corr; 
results.CC=results.CC*corr; 
results.Cl=results.Cl*corr; 
results.Cm=results.Cm*corr; 
results.Cn=results.Cn*corr; 

results.ForcePerMeter=results.ForcePerMeter*corr; 
results.CL_local=results.CL_local*corr;

   results.CL_a=results.CL_a*corr;
   results.CD_a=results.CD_a*corr;
   results.CC_a=results.CC_a*corr;
   results.CX_a=results.CX_a*corr;
   results.CY_a=results.CY_a*corr;
   results.CZ_a=results.CZ_a*corr;
   results.Cl_a=results.Cl_a*corr;
   results.Cm_a=results.Cm_a*corr;
   results.Cn_a=results.Cn_a*corr;
   
   results.CL_b=results.CL_b*corr;
   results.CD_b=results.CD_b*corr;
   results.CC_b=results.CC_b*corr;
   results.CX_b=results.CX_b*corr;
   results.CY_b=results.CY_b*corr;
   results.CZ_b=results.CZ_b*corr;
   results.Cl_b=results.Cl_b*corr;
   results.Cm_b=results.Cm_b*corr;
   results.Cn_b=results.Cn_b*corr;
   
   results.CL_P=results.CL_P*corr;
   results.CD_P=results.CD_P*corr;
   results.CC_P=results.CC_P*corr;
   results.CX_P=results.CX_P*corr;
   results.CX_P=results.CX_P*corr;
   results.CZ_P=results.CZ_P*corr;
   results.Cl_P=results.Cl_P*corr;
   results.Cm_P=results.Cm_P*corr;
   results.Cn_P=results.Cn_P*corr;
   
   results.CL_Q=results.CL_Q*corr;
   results.CD_Q=results.CD_Q*corr;
   results.CC_Q=results.CC_Q*corr;
   results.CX_Q=results.CX_Q*corr;
   results.CY_Q=results.CY_Q*corr;
   results.CZ_Q=results.CZ_Q*corr;
   results.Cl_Q=results.Cl_Q*corr;
   results.Cm_Q=results.Cm_Q*corr;
   results.Cn_Q=results.Cn_Q*corr;
   
   results.CL_R=results.CL_R*corr;
   results.CD_R=results.CD_R*corr;
   results.CC_R=results.CC_R*corr;
   results.CX_R=results.CX_R*corr;
   results.CY_R=results.CY_R*corr;
   results.CZ_R=results.CZ_R*corr;
   results.Cl_R=results.Cl_R*corr;
   results.Cm_R=results.Cm_R*corr;
   results.Cn_R=results.Cn_R*corr;
   
   try
    results.CL_d=results.CL_d*corr;
    results.CD_d=results.CD_d*corr;
    results.CC_d=results.CC_d*corr;
    results.CX_d=results.CX_d*corr;
    results.CY_d=results.CY_d*corr;
    results.CZ_d=results.CZ_d*corr;
    results.Cl_d=results.Cl_d*corr;
    results.Cm_d=results.Cm_d*corr;
    results.Cn_d=results.Cn_d*corr;
   end



end%function
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [results]=spanload6(results,geo,lattice,state)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%	CONFIG: Basic computation function   	%		 	
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%	Computes the spanload (force/meter) for 
%  all wings
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Author: Tomas Melin, KTH, Department of% 
%	Aeronautics, copyright 2002				%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%	Context: Auxillary function for TORNADO%
%	Called by: TORNADO SOlverloop          %
%	Calls:	None									%
%	Loads:	None									%
%	Generates:	force per meter array 
%     			(ystations X wings)			
%					Ystation array
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%	Revision history post alfa 1.0			%
%  2007-02-14  rho moved to state 
%  2002-05-02
%   input var T (taper) added to get local
%	 chords.
% input var AS (airspeed) added 
%   local chord computation function call added
%

%rho=config('rho');	                            %set density
lemma=size(geo.b);								    %number of partitions and wings

B2WTransform=[cos(state.betha)*cos(state.alpha),        -sin(state.betha),          cos(state.betha)*sin(state.alpha) ;...
              cos(state.alpha)*sin(state.betha),         cos(state.betha),          sin(state.betha)*sin(state.alpha) ;...
                              -sin(state.alpha),                        0,                           cos(state.alpha)];


noofpanels=sum(((geo.nx+geo.fnx).*geo.ny),2).*(geo.symetric'+1); %number of panels in total (symmetry disregarded)			
lemma=size(results.F);

corrx=[];
corry=[];
corrz=[];

lemma2=size(geo.b);
for i=1:lemma2(1)
   corry=[corry;ones(noofpanels(i),1)*geo.starty(i)];
   corrz=[corrz;ones(noofpanels(i),1)*geo.startz(i)];
end



for i=1:lemma(1)
    forceMagn(i)=-results.F(i,:)*lattice.N(i,:)'; %Force magnitude (3Dvector -> scalar)
   										         %Aligned witn panel normals
                                                 
    lemma4(i,:)=B2WTransform*results.F(i,:)';                                         
	forceLift(i)=lemma4(i,3);

end




 
A1=((lattice.XYZ(:,1,:)-lattice.XYZ(:,2,:)));
p_span=sqrt(A1(:,:,2).^2+A1(:,:,3).^2); %span of each panel

p_mid=(lattice.XYZ(:,1,:)+lattice.XYZ(:,2,:))/2;                  	%midpoint of ech panel
p_mid_r=sqrt(((p_mid(:,:,2)-corry).^2+(p_mid(:,:,3)-corrz).^2));	%Radius from centerline to midpoint

FPM=forceMagn'./p_span;					%Force per meter on each panel.
LPM=forceLift'./p_span;					%Lift per meter on each panel.


knx=geo.nx+geo.fnx;									%corrected number of panel in x-direction
lemma2=((knx).*geo.ny);						%number of panels in total (symmetry disregarded)

p=[];
p2=[];

lemma=size(geo.b);

for i=1:lemma(1)
	for j=1:lemma(2)
   
      a=[knx(i,j).*ones(geo.ny(i,j),1)];%computing # x-stations to add to each 
      										%y-station
      c=ones(geo.ny(i,j),1);				%sign vector for y station. !!TROUBLE HERE!!
      if geo.symetric(i);
         a=[a;a];							%Doubling if wing is symmetric.
         c=[c;-c];
      end
      p=[p;a];
      p2=[p2;c];
	end
end

lemma3=size(p);							%Total number of ystations for all wings;

for i=1:lemma3								
      SF(i)=sum(FPM(1:p(i)));		%Moving beginning of FPM into SF
      FPM=FPM(p(i)+1:end);				%Removing beginning of FPM
      
      LF(i)=sum(LPM(1:p(i)));		%Moving beginning of LPM into LF
      LPM=LPM(p(i)+1:end);				%Removing beginning of LPM
      
      R(i)=sum(p_mid_r(1:p(i)))/p(i);%Moving p_mid_r into R
      p_mid_r=p_mid_r(p(i)+1:end);	%Removing beginning of p_mid_r
      
      
      strip_span(i)=p_span(1);
      p_span=p_span(p(i)+1:end);
      
end
ystation=R.*p2';							%Fixing signs on negative symmetric half.
ForcePerMeter=SF;							%Renaming






%A=[ForcePerMeter;ystation];			%Output matrix, spanloads with spanstation.
%y_entries=sum(ny,2).*(1+symetric');	%numer of entries in A that corresponds 
												%to each wing
%local chord computation
lc=fLocal_chord2(geo,lattice);


%%%%%%%
%Sorting algorithm to couple force per meter (fpm) 
%value with corresponding y-station
%

SF3=2*LF./(state.rho*state.AS^2*lc);



kny=sum(geo.ny,2).*(geo.symetric+1)'; %corrected number of spanwise strips per wing
for i=1:geo.nwing
   SF2=(SF(1:kny(i)))';
   SF4=(SF3(1:kny(i)))';
   
   SF=SF(kny(i)+1:end);         %removing beginning
   SF3=SF3(kny(i)+1:end);       %removing beginning
   
   [ystat Or]=sort((ystation(1:kny(i)))');
   ys(1:kny(i),i)=ystat;
   
   ystation=ystation((kny(i)+1):end);
   order(1:kny(i),i)=Or;
   
   fpm(1:kny(i),i)=SF2(Or);
   clpm(1:kny(i),i)=SF4(Or);
   
   
        %Some help functions, remove if necceasry
       strip_span2=(strip_span(1:kny(i)))';
       strip_span=strip_span(kny(i)+1:end);
       strip_span3(1:kny(i),i)=strip_span2(Or);
       
       
       lc2=(lc(1:kny(i)))';
       lc=lc(kny(i)+1:end);
       lc3(1:kny(i),i)=lc2(Or);
       %end help
       
       
    
end

   results.ystation=sparse(ys); 
   results.ForcePerMeter=sparse(fpm);
   results.CL_local=sparse(clpm);


end%function
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [panel_area]=tarea(XYZ)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Tarea: Subsidary function for TORNADO					   
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Calculates the area of each panel								
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%	Author:	Tomas Melin, KTH, Department of Aeronautics	%
%				Copyright 2000											
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% CONTEXT:	Subsidaty function for TORNADO					
% Called by:	coeff_create
% 
% Calls:			MATLAB 5.2 std fcns								
% Loads:	none
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[a b c]=size(XYZ);
for i=1:a
   p1=[XYZ(i,1,1) XYZ(i,1,2) XYZ(i,1,3)];	%sets up the vectors 
   p2=[XYZ(i,2,1) XYZ(i,2,2) XYZ(i,2,3)];	%to the corners of the		
   p3=[XYZ(i,3,1) XYZ(i,3,2) XYZ(i,3,3)];	%panel.
   p4=[XYZ(i,4,1) XYZ(i,4,2) XYZ(i,4,3)];
   
   a=p2-p1;	%sets up the edge vectors
   b=p4-p1;
   c=p2-p3;
   d=p4-p3;
   
   ar1=norm(cross(b,a))/2;	%claculates the ctoss product of
   ar2=norm(cross(c,d))/2;	%two diagonal corners
   
 	panel_area(i)=ar1+ar2;	%Sums up the product to make the
end						    %Area
end% function
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function[lc]=fLocal_chord2(geo,lattice)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%	Geometry function 						 	%		 	
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%	Computes the Local chord at each collocation 
%  point row.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Author: Tomas Melin, KTH, Department of% 
%	Aeronautics, copyright 2002				%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%	Context: Auxillary function for TORNADO%
%	Called by: TORNADO spanload            %
%	Calls:	None									%
%	Loads:	None									%
%	Generates:	Local chord vector lc, same 
%  order as colloc, N, and the others
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[indx1 indx2]=size(geo.b);

for s=1:indx1;	   		%Looping over wings
	CHORDS(s,1)=geo.c(s);		%calculating chords of first element
end

for s=1:indx1				%Looping over wings
	for t=1:indx2			%Looping over partitions
	%Chord loop, generating chords for wing partitions
            CHORDS(s,t+1)=CHORDS(s,t)*geo.T(s,t);	%calculating
      												%element root-chord
   end
end




lc=[];	%Local chord vector.


panelchords1=sqrt(sum((lattice.XYZ(:,1,:)-lattice.XYZ(:,4,:)).^2,3)); %inboard
panelchords2=sqrt(sum((lattice.XYZ(:,2,:)-lattice.XYZ(:,3,:)).^2,3)); %outboard
panelchords3=(panelchords1+panelchords2)/2; %Chord of each panel, CAUTION 
                                            %this is really camber line
                                            %length, so not really chord
                                            %for very cambered profiles

for i=1:indx1;			%Wing	
   for j=1:indx2;		%Partition
      lemma=[]; %local chord lemma vector.
      chordwisepanels=geo.nx(i,j)+geo.fnx(i,j); %number of panels chordwise on 
                                                %this partition 
      for k=1:geo.ny(i,j)                       %loop over panel strips.
          if geo.ny(i,j)~=0
              lemma=[lemma sum(panelchords3(1:chordwisepanels))];
              panelchords3=panelchords3((chordwisepanels+1):end);
              %size(panelchords3);
          end
      end  
      if geo.symetric(i)==1	%symmetric wings got two sides
         lc=[lc lemma lemma];
         panelchords3=panelchords3((chordwisepanels*geo.ny(i,j)+1):end);
      else
         lc=[lc lemma];
      end
          
   end
end
end%function
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
   