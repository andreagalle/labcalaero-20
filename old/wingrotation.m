function[l2]=wingrotation(lattice,Raxle,hinge_pos,alpha)


%%Move to rotation centre
lattice.VORTEX(:,:,1)=lattice.VORTEX(:,:,1)-hinge_pos(1);
lattice.VORTEX(:,:,2)=lattice.VORTEX(:,:,2)-hinge_pos(2);
lattice.VORTEX(:,:,3)=lattice.VORTEX(:,:,3)-hinge_pos(3);

lattice.COLLOC(:,1)=lattice.COLLOC(:,1)-hinge_pos(1);
lattice.COLLOC(:,2)=lattice.COLLOC(:,2)-hinge_pos(2);
lattice.COLLOC(:,3)=lattice.COLLOC(:,3)-hinge_pos(3);

lattice.XYZ(:,:,1)=lattice.XYZ(:,:,1)-hinge_pos(1);
lattice.XYZ(:,:,2)=lattice.XYZ(:,:,2)-hinge_pos(2);
lattice.XYZ(:,:,3)=lattice.XYZ(:,:,3)-hinge_pos(3);


[ai bi ci]=size(lattice.VORTEX);

l2.COLLOC=trot4(Raxle,lattice.COLLOC,alpha)';
l2.N=trot4(Raxle,lattice.N,alpha)';

for i=2:(bi-1)
    A=squeeze(lattice.VORTEX(:,i,:))   ;
    B=trot4(Raxle,A,alpha)';
    l2.VORTEX(:,i,:)=B;
end

    l2.VORTEX(:,1,:)=lattice.VORTEX(:,1,:);
    l2.VORTEX(:,bi,:)=lattice.VORTEX(:,bi,:);
    
    
for i=1:5
    A=squeeze(lattice.XYZ(:,i,:)) ;  
    B=trot4(Raxle,A,alpha)';
    l2.XYZ(:,i,:)=B;
end

%%Move back from rotation centre
l2.VORTEX(:,:,1)=l2.VORTEX(:,:,1)+hinge_pos(1);
l2.VORTEX(:,:,2)=l2.VORTEX(:,:,2)+hinge_pos(2);
l2.VORTEX(:,:,3)=l2.VORTEX(:,:,3)+hinge_pos(3);

l2.COLLOC(:,1)=l2.COLLOC(:,1)+hinge_pos(1);
l2.COLLOC(:,2)=l2.COLLOC(:,2)+hinge_pos(2);
l2.COLLOC(:,3)=l2.COLLOC(:,3)+hinge_pos(3);


l2.XYZ(:,:,1)=l2.XYZ(:,:,1)+hinge_pos(1);
l2.XYZ(:,:,2)=l2.XYZ(:,:,2)+hinge_pos(2);
l2.XYZ(:,:,3)=l2.XYZ(:,:,3)+hinge_pos(3);


end%function wingrotation
function[p2]=trot4(hinge,p,alpha)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% TROT: Auxillary rotation function			
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% rotates point p around hinge alpha rads.%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ref: 	Råde, Westergren, BETA 4th ed,   
%			studentlitteratur, 1998			    	
%			pp:107-108							   	
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Author: 	Tomas Melin, KTH,Department of%
% 				aeronautics, Copyright 2000	
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Context:	Auxillary function for			
%				TORNADO.								
% Called by: setrudder, normals			
% Calls:		norm (MATLAB std fcn)			
%				sin			"						
%				cos			"						
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% HELP:		Hinge=vector around rotation  
%						takes place.				
%				p=point to be rotated			
%				alpha=radians of rotation		
%				3D-workspace						
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
a=hinge(1);
b=hinge(2);
c=hinge(3);

rho=sqrt(a^2+b^2);
r=sqrt(a^2+b^2+c^2);

if r==0
   cost=0
   sint=1;
else
   cost=c/r;
   sint=rho/r;
end

if rho==0
   cosf=0;
   sinf=1;
else
   cosf=a/rho;
	sinf=b/rho;
end   

cosa=cos(alpha);
sina=sin(alpha);

RZF=[[cosf -sinf 0];[sinf cosf 0];[0 0 1]];
RYT=[[cost 0 sint];[0 1 0];[-sint 0 cost]];
RZA=[[cosa -sina 0];[sina cosa 0];[0 0 1]];
RYMT=[[cost 0 -sint];[0 1 0];[sint 0 cost]];
RZMF=[[cosf sinf 0];[-sinf cosf 0];[0 0 1]];

P=RZF*RYT*RZA*RYMT*RZMF;
p2=P*p';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end%function wingrotation