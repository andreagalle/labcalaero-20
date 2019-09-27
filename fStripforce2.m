function [out]=fStripforce(geo,results,lattice,state,ref,vCfraction)
%This lemma function computes the aerodynamic force on each strip.



q=0.5*state.rho*state.AS^2;
S=ref.S_ref;

F=results.F;                            %Reassigning to save some space
%% Vortex points
[s1 s2 s3]=size(lattice.VORTEX);
if s2==8
    pV1=squeeze(lattice.VORTEX(:,4,:));
    pV2=squeeze(lattice.VORTEX(:,5,:));
elseif s2==4
    pV1=squeeze(lattice.VORTEX(:,2,:));
    pV2=squeeze(lattice.VORTEX(:,3,:));
end
pV=(pV1+pV2)/2;
%%    

[ai bi]=size(geo.nx);                       %number of wings and panels
cnx=geo.nx+geo.fnx;                     %corrected number of xpanels


for i=1:geo.nwing;
    cny(i,:)=geo.ny(i,:).*(geo.symetric(i)+1); %corrected number of ypanels
end

stripsperwing=sum(cny);

%% Compute force action point and  strip moment axis

m=0;

lastindex1=0;
lastindex2=0;
index1=    1+lastindex1;
index2=    cnx(1,1)+lastindex2;

for i=1:ai          %loop per wing
    for j=1:bi      %loop per partition
        for k=1:cny(i,j)  
            %per strip loop
            m=m+1;
            
            %% Compute force action point and  strip moment axis
            cornerp=squeeze([lattice.XYZ(index1,1,:);
                              lattice.XYZ(index1,2,:);
                              lattice.XYZ(index2,3,:);
                              lattice.XYZ(index2,4,:)]);
            
           localC1(m,:)=[(cornerp(1,:)+cornerp(2,:))/2];
           localC2(m,:)=[(cornerp(3,:)+cornerp(4,:))/2];
           Mpoint(m,:)=(1-vCfraction)*localC1(m,:)+(vCfraction)*localC2(m,:);
           yprimestation(m)=sign(Mpoint(m,2))*sqrt(Mpoint(m,2)^2+Mpoint(m,3)^2);
           
           %Local chord
           lemma1=localC1(m)-localC2(m);
           lc(m)=sqrt(sum(lemma1.^2));
           
           %local span
           lemma1=(-cornerp(1,:)+cornerp(2,:));
           lemma2=lemma1.*[0 1 1];%Disregarding x component
           ls(m)=sqrt(sum(lemma2.^2));
           
           %Strip Area
           la(m)=ls(m)*lc(m);
           
            %%
            %Forces
            F0(m)=sum(sqrt(F(index1:index2,2).^2+F(index1:index2,3).^2)); %Only Z and Y component
            
            F0X(m,:)=F(index1:index2,1);
            F0Y(m,:)=F(index1:index2,2);
            F0Z(m,:)=F(index1:index2,3);
                   
            %Moments
            %difference(:,1)=Mpoint(m,1)-pV(index1:index2,1);
            %difference(:,2)=Mpoint(m,2)-pV(index1:index2,2);
            %difference(:,3)=Mpoint(m,3)-pV(index1:index2,3); 
            
            PV(m,:,:)=pV(index1:index2,:);
            
            
            F2=F(index1:index2,:);
            %M=cross(F2,difference);
            %M2=sum(M);
            %M3(m)=sqrt(sum(M2.^2));
            
            %% Coefficients
            CZprime(m)=F0(m)/(q*la(m));
            %Cmprime(m)=M3(m)/(q*la(m)*lc(m));
  
            index1=index2+1;
            index2=index2+cnx(i,j);
            %i
            %j
            %m
            %cnx(i,j)
            %pans=index2-index1+1
            
        end
    end
    [yps or]=sort(yprimestation);
    
    out.ypstation=yps;
    out.stripforce=F0(or);
    %out.pitchmoment=M3(or);
    out.CZprime=CZprime(or);
    %out.Cmprime=Cmprime(or);
    out.forcepermeter=F0(or)./ls(or);
    %out.pitchmomentpermeter=M3(or)./ls(or);
    
    %% EXTRA TWIST
    twaxis=Mpoint(or,:);
    
    F0X2=F0X(or);
    F0Y2=F0Y(or);
    F0Z2=F0Z(or);
    
    FF(:,:,1)=F0X(or,:);
    FF(:,:,2)=F0Y(or,:);
    FF(:,:,3)=F0Z(or,:);
    
    PV2=PV(or,:,:);

    
    for i=1:stripsperwing/2
        Dx=PV2(1:i,:,1)-twaxis(i,1);
        Dy=PV2(1:i,:,2)-twaxis(i,2);
        Dz=PV2(1:i,:,3)-twaxis(i,3);
        
        D(:,:,1)=Dx;
        D(:,:,2)=Dy;
        D(:,:,3)=Dz;
        
        MT=cross(D,FF(1:i,:,:));
        clear D
        
        MMB(i)=sum(sum(MT(:,:,1),2));
        MMT(i)=sum(sum(MT(:,:,2),2));
        MML(i)=sum(sum(MT(:,:,3),2));       
    end
    
    %for i=(stripsperwing/2+1):stripsperwing 
    %    Dx=PV2(1:i,:,1)-twaxis(i,1);
    %    Dy=PV2(1:i,:,2)-twaxis(i,2);
    %    Dz=PV2(1:i,:,3)-twaxis(i,3);
        
    %    D(:,:,1)=Dx;
    %    D(:,:,2)=Dy;
    %    D(:,:,3)=Dz;
        
    %    MT2=cross(D,FF(1:i,:,:));
    %    clear D
        
    %    MMB2(i)=sum(sum(MT2(:,:,1),2));
    %    MMT2(i)=sum(sum(MT2(:,:,2),2));
    %    MML2(i)=sum(sum(MT2(:,:,3),2));       
    %end
    
    
    
    
    
    
    out.Twist=[MMT fliplr(MMT)];
    out.Bend=[MMB fliplr(MMB)];
    out.LES=[MML fliplr(MML)];
    %out.Twist=[MMT];
    %out.Bend=[MMB];
    %out.LES=[MML];

    
  
    %% Shearload, bending moment and integrated twist moment computation
    stripforce_p=out.stripforce(1:(stripsperwing/2));
    stripforce_sb=out.stripforce((stripsperwing/2+1):end);
    
    load=sum(F0);
    
    shear_p=cumsum(stripforce_p);
    shear_sb=-(fliplr(cumsum(fliplr(stripforce_sb))));
    out.shear=[shear_p shear_sb];
  %return  
    %striptwist_p=out.pitchmoment(1:(stripsperwing/2));
    %striptwist_sb=out.pitchmoment((stripsperwing/2+1):end);
    
   % twist_p=vumsum
    
    
end
%return
H=figure(1);
hold on
set(H,'Position',[10 10 0.8*3*210 0.8*3*297])
%Changing variables to plot only partition outline
g2=geo;
g2.nx=double(g2.nx>0);
g2.ny=double(g2.ny>0); 
g2.fnx=double(g2.fnx>0); 
s2.AS=1;
s2.alpha=0;
s2.betha=0;
s2.P=0;
s2.Q=0;
s2.R=0;
s2.ALT=0;
s2.rho=1;
s2.pgcorr=0;


        
        [l2,ref]=fLattice_setup2(g2,s2,1);

subplot(4,1,1,'position',[0.1 0.8 0.8 0.17]); hold on 
%axes('position',[0.1 0.8 0.8 0.17])
g=fill3(l2.XYZ(:,:,1)',l2.XYZ(:,:,2)',l2.XYZ(:,:,3)','w');
set(g,'LineWidth',2);
view([90,90]);
%axis equal
hold on
%xlabel('Aircraft body x-coordinate')
%ylabel('Aircraft body y-coordinate')
%zlabel('Aircraft body z-coordinate')
title('Wing aerodynamic loading')
axis off


subplot(4,1,2)
%axes()
h1=plot(out.ypstation,out.shear);
hold on
set(h1,'LineWidth',2)
h2=gca;
%set(h2,'XTickLabel',[],'position',[0.1 0.6 0.8 0.17])
grid on
ylabel('Shear force, F_z, [N]')

subplot(4,1,3)
%axes();
h1=plot(out.ypstation,out.Bend);
hold on
set(h1,'LineWidth',2)
h2=gca;
%set(h2,'XTickLabel',[],'position',[0.1 0.4 0.8 0.17])


grid on
ylabel('Bend moment, M_x, [Nm]')

subplot(4,1,4)
%axes('position',[0.1 0.2 0.8 0.17]);
h1=plot(out.ypstation,out.Twist);
hold on
set(h1,'LineWidth',2)
%h2=gca;
%set(h5,'OuterPosition',[0 0.0 1 0.2])
grid on
ylabel('Twist moment, M_y, [Nm]')
xlabel('Span station, y, [m]')
h2=gca;
%set(h2,'position',[0.1 0.2 0.8 0.17])
















    end %function stripforce    
        