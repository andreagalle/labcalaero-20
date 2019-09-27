function [eskndrg,efrmdrg,ecomdrg,etcpdrg]=QDRGPRD(inpt,M,state,results);
% reverse engineer drag polar using geometric manipulation coupled to simplified theory
% ensure the polars are accessed from the correct locale
%dplrhme='C:\technical\000_cleaned\zzx_universities\UoB_Samba\Projects\QCARD-MMVI\polars';
%addpath(dplrhme);
selectf='q728jetp15';% the drag polars file name
load('q728jetp15.dat')
coord=eval(selectf);
% polars file is open, now read in the information   
selcols=coord(1,1);% record no. of columns
selclrs=coord(1,2);% record no. of CL rows
selmhrs=coord(1,3);% record no. of Mach rows
% read in the CL and Mach values
MASTMCH=zeros(selmhrs*selcols,1);MASTCLS=zeros(selclrs*selcols,1);
startct=2;stopcnt=startct+selclrs-1;
[MASTCLS,numbcls]=storedt(startct,stopcnt,selcols,0, ...
                          coord,0,5,10,1,0,0);  
startct=stopcnt+1;stopcnt=startct+selmhrs-1;
[MASTMCH,numbmhs]=storedt(startct,stopcnt,selcols,0, ...
                          coord,0,5,10,1,0,0);
% read in other pertinent data
startct=stopcnt+1;
REFWARE=coord(startct,1);% record the ref. wing area
REFALTD=coord(startct,2)/100;% record the ref. altitude in FL
REFMACH=coord(startct,3);% record the ref. Mach number
REFVOMU=coord(startct,4);% record the ref. Reynolds Number (V/mu)
% provide V/mu if not given
if REFVOMU<=0
      REFVOMU=qxreynd(qxdmtks(REFMACH,REFALTD,0),REFALTD,0,1);
end
startct=stopcnt+2;
REFWASR=coord(startct,1);% ref wing aspect ratio
REFWTPR=coord(startct,2);% ref. wing taper ratio
REFWQSW=coord(startct,3);% ref wing quarter chord sweep
REFWTTC=coord(startct,4);% ref wing mean thickness-to-chord
startct=stopcnt+3;
REFWMAC=coord(startct,1);% ref wing MAC
REFCGLC=coord(startct,2);% ref. centre of gravity
REFAECN=coord(startct,3);% ref. aero centre
THRSARM=coord(startct,4);% thrust arm
startct=stopcnt+4;
HTALVOL=coord(startct,1);% h-tail volume coefficient
REFAHTL=coord(startct,2);% h-tail ref area
REFHTAR=coord(startct,3);% h-tail ref aspect ratio
REFHTPR=coord(startct,4);% ref. wing taper ratio
startct=stopcnt+5;
REFHQSW=coord(startct,1);% ref wing quarter chord sweep
HTALARM=coord(startct,2);% h-tail moment arm
VEHWETD=coord(startct,3);% total vehicular wetted area
% provide h-tail volume coefficient if not given
if HTALVOL<=0
   HTALVOL=REFAHTL*HTALARM/(REFWARE*REFWMAC);
end
% now read the entire drag polar information into a master 3D array
MASTDRG=zeros(numbmhs,numbcls);
startct=startct+1;stopcnt=startct+selcols*selclrs*selmhrs-1;
[MASTDRG,numbdat]=storedt(startct,stopcnt,selcols,selclrs, ...
                          coord,0,5,10000,2,numbmhs,numbcls);
MASTDRG=[MASTCLS(1:numbcls);MASTDRG(1:numbmhs,1:numbcls)];
MASTMCH=[0;flipud(rot90(MASTMCH(1:numbmhs)))];
MASTDRG=[MASTMCH MASTDRG];% final version of formatted drag polar matrix
% identify the lower and upper bounds of CL and Mach for the matrix
lwrmhid=2;% lowest Mach number
uprmhid=numbmhs+1;% highest Mach number
lwrclid=2;% lowest CL
uprclid=numbcls+1;% highest CL                      
% OPTIONAL: record the Reynolds correction
startct=stopcnt+1;
selreyn=coord(startct,1);% record no. of Reynolds correction rows
if selreyn>0
   REYNCOR=zeros(2,selreyn*selcols);
% read in the Reynolds fractional change values
   startct=stopcnt+2;stopcnt=startct+selreyn-1;
   [REYNCOR(1,:),numbrey]=storedt(startct,stopcnt,selcols,0, ...
                                  coord,-999,5,10,1,0,0); 
% read in the Reynolds corrected drag increments
   startct=stopcnt+1;stopcnt=startct+selreyn-1;
   [REYNCOR(2,:),dumnumb]=storedt(startct,stopcnt,selcols,0, ...
                                  coord,-999,5,10000,1,0,0);
   for j=2:selreyn*selcols-1
       if REYNCOR(1,j)==0 & REYNCOR(1,j-1)~=0 & REYNCOR(1,j+1)~=0
          numbrey=numbrey+1;% size the matrix appropriately
       end
   end
   REYNCOR=REYNCOR(:,1:numbrey); 
end
% OPTIONAL: record the wing+fuse+htail lift-curve slope corrected for Mach
if selreyn==0
   startct=startct+1;
else
   startct=stopcnt+1;
end
selclac=coord(startct,1);% record no. of Mach correction rows
if selclac>0
   CLACCOR=zeros(2,selclac*selcols);
% read in the Mach numbers values
   startct=startct+1;stopcnt=startct+selclac-1;
   [CLACCOR(1,:),numbcla]=storedt(startct,stopcnt,selcols,0, ...
                                  coord,0,999,10,1,0,0); 
% read in the corrected CLa values
   startct=stopcnt+1;stopcnt=startct+selclac-1;
   [CLACCOR(2,:),dumnumb]=storedt(startct,stopcnt,selcols,0, ...
                                  coord,0,999,1,1,0,0);
   CLACCOR=CLACCOR(:,1:numbcla);                       
end
% OPTIONAL: record the wing+fuse lift-curve slope corrected for Mach
if selclac==0
   startct=startct+1;
else
   startct=stopcnt+1;
end
selclaw=coord(startct,1);% record no. of Mach correction rows
if selclaw>0
   CLAWCOR=zeros(2,selclaw*selcols);
% read in the Mach numbers values
   startct=startct+1;stopcnt=startct+selclaw-1;
   [CLAWCOR(1,:),numclaw]=storedt(startct,stopcnt,selcols,0, ...
                                  coord,0,999,10,1,0,0); 
% read in the corrected CLa values
   startct=stopcnt+1;stopcnt=startct+selclaw-1;
   [CLAWCOR(2,:),dumnumb]=storedt(startct,stopcnt,selcols,0, ...
                                  coord,0,999,1,1,0,0);
   CLAWCOR=CLAWCOR(:,1:numclaw);                       
end
% OPTIONAL: record the zero-lift pitching moment corrected for Mach
if selclaw==0
   startct=startct+1;
else
   startct=stopcnt+1;
end
selzlpm=coord(startct,1);% record no. of Mach correction rows
if selzlpm>0
   ZLPMCOR=zeros(2,selzlpm*selcols);
% read in the Mach numbers values
   startct=startct+1;stopcnt=startct+selzlpm-1;
   [ZLPMCOR(1,:),numbzlm]=storedt(startct,stopcnt,selcols,0, ...
                                  coord,0,5,10,1,0,0); 
% read in the corrected zero-lift pitching moment values
   startct=stopcnt+1;stopcnt=startct+selzlpm-1;
   [ZLPMCOR(2,:),dumnumb]=storedt(startct,stopcnt,selcols,0, ...
                                  coord,-999,5,10,1,0,0);
   ZLPMCOR=ZLPMCOR(:,1:numbzlm);                       
end
% OPTIONAL: record the mean downwash at H-tail corrected for Mach
if selzlpm==0
   startct=startct+1;
else
   startct=stopcnt+1;
end
selmdwt=coord(startct,1);% record no. of Mach correction rows
if selmdwt>0
   MDWTCOR=zeros(2,selmdwt*selcols);
% read in the Mach numbers values
   startct=startct+1;stopcnt=startct+selmdwt-1;
   [MDWTCOR(1,:),numbmdw]=storedt(startct,stopcnt,selcols,0, ...
                                  coord,0,5,10,1,0,0); 
% read in the corrected mean downwash at H-tail values
   startct=stopcnt+1;stopcnt=startct+selmdwt-1;
   [MDWTCOR(2,:),dumnumb]=storedt(startct,stopcnt,selcols,0, ...
                                  coord,0,5,1,1,0,0);
   MDWTCOR=MDWTCOR(:,1:numbmdw);                       
end
% OPTIONAL: record the downwash gradient at H-tail corrected for Mach
if selmdwt==0
   startct=startct+1;
else
   startct=stopcnt+1;
end
seldwht=coord(startct,1);% record no. of Mach correction rows
if seldwht>0
   DWHTCOR=zeros(2,seldwht*selcols);
% read in the Mach numbers values
   startct=startct+1;stopcnt=startct+seldwht-1;
   [DWHTCOR(1,:),numbdwh]=storedt(startct,stopcnt,selcols,0, ...
                                  coord,0,5,10,1,0,0); 
% read in the corrected downwash gradient at H-tail values
   startct=stopcnt+1;stopcnt=startct+seldwht-1;
   [DWHTCOR(2,:),dumnumb]=storedt(startct,stopcnt,selcols,0, ...
                                  coord,0,5,10,1,0,0);
   DWHTCOR=DWHTCOR(:,1:numbdwh);                       
end
% OPTIONAL: record the neutral point corrected for Mach
if seldwht==0
   startct=startct+1;
else
   startct=stopcnt+1;
end
selnplc=coord(startct,1);% record no. of Mach correction rows
if selnplc>0
   NPLCCOR=zeros(2,selnplc*selcols);
% read in the Mach numbers values
   startct=startct+1;stopcnt=startct+selnplc-1;
   [NPLCCOR(1,:),numbnpl]=storedt(startct,stopcnt,selcols,0, ...
                                  coord,0,5,10,1,0,0); 
% read in the corrected neutral point values
   startct=stopcnt+1;stopcnt=startct+selnplc-1;
   [NPLCCOR(2,:),dumnumb]=storedt(startct,stopcnt,selcols,0, ...
                                  coord,0,5,10,1,0,0);
   NPLCCOR=NPLCCOR(:,1:numbnpl);                       
end
% end of data recording and formatting
% perform manipulation to coalesce out drag constituents
% estimate the vortex-induce drag contribution
dcddcls=zeros(numbmhs+1,numbcls+1);dcddclp=zeros(numbmhs+1,numbcls+1);
dcddcln=zeros(numbmhs+1,numbcls+1);trmtwrd=zeros(numbmhs+1,numbcls+1);
for i=lwrmhid:uprmhid
    for j=lwrclid:uprclid
        if MASTDRG(i,j)>0
           if j==lwrclid
              clsqure=0.01*[MASTDRG(1,j)^2 MASTDRG(1,j+1)^2 MASTDRG(1,j+2)^2];
              cllinre=0.1*[MASTDRG(1,j)   MASTDRG(1,j+1)   MASTDRG(1,j+2)];
              cdvidta=1e-4*[MASTDRG(i,j)   MASTDRG(i,j+1)   MASTDRG(i,j+2)];
           elseif j==uprclid | MASTDRG(i,j+1)==0
              clsqure=0.01*[MASTDRG(1,j-2)^2 MASTDRG(1,j-1)^2 MASTDRG(1,j)^2];
              cllinre=0.1*[MASTDRG(1,j-2)   MASTDRG(1,j-1)   MASTDRG(1,j)];
              cdvidta=1e-4*[MASTDRG(i,j-2)   MASTDRG(i,j-1)   MASTDRG(i,j)];
           else
              clsqure=0.01*[MASTDRG(1,j-1)^2 MASTDRG(1,j)^2 MASTDRG(1,j+1)^2];
              cllinre=0.1*[MASTDRG(1,j-1)   MASTDRG(1,j)   MASTDRG(1,j+1)];
              cdvidta=1e-4*[MASTDRG(i,j-1)   MASTDRG(i,j)   MASTDRG(i,j+1)];
           end
           vorincf=polyfit(clsqure,cdvidta,2);
           trmtwcf=polyfit(cllinre,cdvidta,2);
           dcddcls(i,j)=(vorincf(2)+2*vorincf(1)*0.01*MASTDRG(1,j)^2);
           dcddcln(i,j)=(trmtwcf(2)+2*trmtwcf(1)*0.1*MASTDRG(1,j));
           dcddclp(i,j)=dcddcls(i,j);
           if dcddcls(i,j)<0
              dcddclp(i,j)=0;
           end
        end
    end
end
% identify a suitable reference vortex-induced drag factor, i.e. min rate change pt
dvfcdcl=zeros(lwrmhid,numbcls+1);
[dvfcdcl]=numdifd(lwrmhid-1,numbcls,lwrmhid,lwrmhid,lwrclid,uprclid,MASTDRG,dcddcls,0.1,1,1);
% identify CL that will define the wing auto-induced drag factor
lockvif=1;diffmin=dvfcdcl(lwrmhid,lwrclid+2);lockout=0;
for j=lwrclid+3:uprclid    
    if dvfcdcl(lwrmhid,j)<0
       lockout=1;
    end
    if dvfcdcl(lwrmhid,j)<diffmin & dvfcdcl(lwrmhid,j)>=0 & lockout==0
       diffmin=dvfcdcl(lwrmhid,j);lockvif=j;
    end
end
VORINDF=dcddcls(2,lockvif);% wing auto-induced drag factor
VOINFCL=0.1*MASTDRG(1,lockvif);% corresponding ref CL for auto-induced factor
if selreyn>0
% perform non-linear regression in order to derive the Eckert skin friction coefficients
   reyindp=REYNCOR(1,1:numbrey)/10;
   rftldrg=interp2(MASTDRG(1,lwrclid:uprclid),rot90(MASTDRG(lwrmhid:uprmhid,1)),MASTDRG(lwrmhid:uprmhid,lwrclid:uprclid),VOINFCL*10,MASTDRG(2,1),'cubic');
   reydepn=REYNCOR(2,1:numbrey)/rftldrg;
   reyvar0=[2.58 0.144 0.58];reyvarm=[0 0 0];reyvarx=[10 10 10];
   options=optimset('MaxFunEvals',1e10,'MaxIter',1e10,'TolFun',1e-10,'TolX',1e-10,'TolCon',1e-10);
   [reyvar1]=lsqcurvefit('reysfit',reyvar0,reyindp,reydepn,reyvarm,reyvarx,options);
end
OSWALDF=1/(VORINDF*pi*REFWASR);% equivalent Oswald factor
VORINDD=zeros(numbcls+1,1);% wing auto-vortex-induced drag matrix
MASTDRI=zeros(numbmhs+1,numbcls+1);% drag polar minus the vortex-induced drag
for i=lwrmhid:uprmhid
    for j=lwrclid:uprclid
        if MASTDRG(i,j)>0
           VORINDD(j)=1e4*VORINDF*0.01*MASTDRG(1,j)^2;
           MASTDRI(i,j)=MASTDRG(i,j)-VORINDD(j);
        end
    end
end
% coalesce out the trim condition and resulting drag constituents
% first approach assuming known neutral point and zero-lift pitching moment
CLAHTAL=zeros(numbmhs+1,numbcls+1);% h-tail lift-curve slope
DCLHDCL=zeros(numbmhs+1,numbcls+1);% rate change of CLht w.r.t. CL
DCLWDCL=zeros(numbmhs+1,numbcls+1);% rate change of CLw w.r.t. CL
ETAFUNQ=zeros(numbmhs+1,numbcls+1);% ratio of dynamic pressure at h-tail and freestream
DCMWDCL=zeros(numbmhs+1,numbcls+1);% rate change of wing+fuse pitching moment w.r.t. CL
CDALPHA=zeros(numbmhs+1,numbcls+1);% rate change of total drag w.r.t. AoA
CMALPWF=zeros(numbmhs+1,numbcls+1);% rate change of wing+fuse moment coeff. w.r.t. AoA
CMALPHA=zeros(numbmhs+1,numbcls+1);% vehicular pitching moment gradient due to AoA
DEALPHA=zeros(numbmhs+1,numbcls+1);% difference between given AoA and zero-lift AoA
ZRLALPH=zeros(numbmhs+1,numbcls+1);% zero-lift AoA
CLHTAIL=zeros(numbmhs+1,numbcls+1);% lift coeff. of h-tail
CLINCWN=zeros(numbmhs+1,numbcls+1);% incremental lift coeff. of wing
CLWINGA=zeros(numbmhs+1,numbcls+1);% actual lift coeff. of wing
for i=lwrmhid:uprmhid
% interpolate neutral point for given Mach and then adjust for centre of gravity
    npointi=0.1*interp1(NPLCCOR(1,1:numbnpl),NPLCCOR(2,1:numbnpl),MASTDRG(i,1),'cubic')-0.01*REFAECN;
% interpolate vehicular lift-curve slope for given Mach
    clacngi=interp1(CLACCOR(1,1:numbcla),CLACCOR(2,1:numbcla),MASTDRG(i,1),'cubic');
% interpolate tail-off lift-curve slope for given Mach
    clawngi=interp1(CLAWCOR(1,1:numclaw),CLAWCOR(2,1:numclaw),MASTDRG(i,1),'cubic');
% interpolate the mean downwash angle
    mdnwhti=interp1(MDWTCOR(1,1:numbmdw),MDWTCOR(2,1:numbmdw),MASTDRG(i,1),'cubic');
% interpolate downwash gradient for given Mach
    dnwashi=0.1*interp1(DWHTCOR(1,1:numbdwh),DWHTCOR(2,1:numbdwh),MASTDRG(i,1),'cubic');
% interpolate zero-lift pitching moment for given Mach
    zelipmi=0.1*interp1(ZLPMCOR(1,1:numbzlm),ZLPMCOR(2,1:numbzlm),MASTDRG(i,1),'cubic');
    findcnt=0;% flag used to estimate the zero-lift AoA
    for j=lwrclid:uprclid
        DCLWDCL(i,j)=clawngi/clacngi;
        CMALPHA(i,j)=-npointi*clacngi;
        DCLHDCL(i,j)=REFWARE/REFAHTL*(1-DCLWDCL(i,j));
        CLAHTAL(i,j)=DCLHDCL(i,j)*clacngi/(1-dnwashi);%(clacngi-clawngi)*REFWARE/(REFAHTL*(1-dnwashi));
        ETAFUNQ(i,j)=((npointi+0.01*REFAECN)*REFWMAC*clacngi-clawngi*0.01*REFAECN*REFWMAC+npointi*clacngi)/(REFAHTL/REFWARE*CLAHTAL(i,j)*(1- ...
                      dnwashi)*(HTALARM+0.01*REFAECN*REFWMAC));
        DCMWDCL(i,j)=CLAHTAL(i,j)/clacngi*ETAFUNQ(i,j)*HTALVOL*(1-dnwashi);
        CMALPWF(i,j)=DCMWDCL(i,j)*clacngi;
        DEALPHA(i,j)=-npointi*0.1*MASTDRG(1,j)/CMALPHA(i,j);
        CDALPHA(i,j)=dcddcln(i,j)*clacngi;
        CLWINGA(i,j)=(zelipmi+DCMWDCL(i,j)*0.1*MASTDRG(1,j)+1e-4*MASTDRG(i,j)*THRSARM- ...
                      ETAFUNQ(i,j)*HTALVOL*REFWARE/REFAHTL*0.1*MASTDRG(1,j))/(0.01*(REFAECN-REFCGLC)- ...
                      ETAFUNQ(i,j)*HTALVOL*REFWARE/REFAHTL);
        CLINCWN(i,j)=CLWINGA(i,j)-0.1*MASTDRG(1,j);
        CLHTAIL(i,j)=-CLINCWN(i,j)*REFWARE/REFAHTL;
        ZRLALPH(i,j)=CLHTAIL(i,j)/CLAHTAL(i,j)+mdnwhti/180*pi-DEALPHA(i,j);
    end
end
TCDWINC=zeros(numbmhs+1,numbcls+1);% trim drag due to wing incremental vortex-induced
TTTHRST=zeros(numbmhs+1,numbcls+1);% tail thrust (negative drag) due to wing downwash
TCDTINC=zeros(numbmhs+1,numbcls+1);% trim drag due to h-tail vortex-induced
for i=lwrmhid:uprmhid
    for j=lwrclid:uprclid
        TCDTINC(i,j)=1/(pi*REFHTAR*0.65)*(CLHTAIL(i,j)^2)*REFAHTL/REFWARE*1e4;
        TCDWINC(i,j)=VORINDF*((CLWINGA(i,j)^2)-(0.01*MASTDRG(1,j)^2))*1e4;
        mdnwhti=interp1(MDWTCOR(1,1:numbmdw),MDWTCOR(2,1:numbmdw),MASTDRG(i,1),'cubic');
        TTTHRST(i,j)=CLHTAIL(i,j)*sin(mdnwhti/180*pi)*REFAHTL/REFWARE*1e4;
    end
end
EZELDRG=MASTDRI(lwrmhid,lockvif)-(TCDTINC(lwrmhid,lockvif)+TCDWINC(lwrmhid,lockvif)+ ...
                                  TTTHRST(lwrmhid,lockvif));% zero-lift drag coefficient
if VEHWETD>0
   REFSKCF=EZELDRG*1e-4*REFWARE/VEHWETD;% vehicular equivalent lift coefficient
else
   efrmdrg='N/A';
end
% this can only be accomplished if the user has defined Reynolds based corrections in the
% original drag polar file
   if selreyn>0
      reyvar1(4)=REFSKCF*(log(qxreynd(qxdmtks(REFMACH,REFALTD,0),REFALTD,0,...
                 REFWMAC)^reyvar1(1)))*(1+reyvar1(2)*(REFMACH^2))^reyvar1(3);
   end
PROFCOR=zeros(1,numbcls+1);% form drag as a function of operating lift coefficient                              
MASTDIY=zeros(numbmhs+1,numbcls+1);% total compressibility drag matrix
for i=lwrmhid:uprmhid
    for j=lwrclid:uprclid
        if MASTDRI(i,j)~=0
           MASTDIY(i,j)=MASTDRI(i,j)-EZELDRG-(TCDTINC(i,j)+TCDWINC(i,j)+TTTHRST(i,j));
           if i<lwrmhid+1
              PROFCOR(1,j)=MASTDIY(i,j);
              if PROFCOR(1,j)<0
                 PROFCOR(1,j)=0;
              end
           end
           MASTDIY(i,j)=MASTDIY(i,j)-PROFCOR(1,j);
        end
    end
end
TCDCINC=zeros(numbmhs+1,numbcls+1);% incremental compressibility drag due to wing lift increment
for i=lwrmhid:uprmhid
    for j=lwrclid:uprclid
        if MASTDIY(i,j)>0
           incclci=interp1(MASTDRG(1,lwrclid:uprclid),MASTDIY(i,lwrclid:uprclid),10*CLWINGA(i,j),'cubic');
           TCDCINC(i,j)=incclci-MASTDIY(i,j);
        end
    end
end
TTLTRMD=zeros(numbmhs+1,numbcls+1);% total trim drag matrix
TTLTRMD=TCDTINC+TCDWINC+TTTHRST+TCDCINC;
MASTDIZ=zeros(numbmhs+1,numbcls+1);% final compressibility drag matrix
for i=lwrmhid:uprmhid
    for j=lwrclid:uprclid
        MASTDIZ(i,j)=MASTDIY(i,j)-TCDCINC(i,j);% compresibility drag matrix adjusted for wing incremental lift effect
        if MASTDIZ(i,j)<1
           MASTDIZ(i,j)=0;
       end
    end
end
MASTDIN=zeros(numbmhs+1,numbcls+1);% final compressibility drag matrix normalised by 20 cts
MASTDIN=MASTDIZ/20;% compresibility drag matrix normalised for 20 cts drag divergence criterion
DDVMACH=zeros(numbcls+1,1);% drag divergence mach maxtrix
MREFCAL=zeros(numbcls+1,1);% technology ref mach for drag rise + divergence behaviour
for j=lwrclid:uprclid
    tempsto=find(MASTDIN(lwrmhid:uprmhid,j)>0);L=length(tempsto);
    DDVMACH(j)=interp1(MASTDIN(tempsto(1):tempsto(L),j),MASTDRG(tempsto(1):tempsto(L),1)/10,1,'cubic');
    MREFCAL(j)=DDVMACH(j)*cos(REFWQSW*pi/180)+0.1*((MASTDRG(1,j)/10/(cos(REFWQSW*pi/180)^2))^1.5)+REFWTTC/cos(REFWQSW*pi/180);
end
%MASTDRG
%VORINDD
%VORINDF
%VOINFCL
%OSWALDF
%EZELDRG
%PROFCOR
%TCDTINC
%CLHTAIL
%TCDWINC
%TTTHRST
%TCDCINC
%CLWINGA
%TTLTRMD
%CMALPHA
%CDALPHA
%DEALPHA*57.3
%MASTDIY
%MASTDIZ
%MASTDIN
%DDVMACH
%MREFCAL
%DGRMTRX
%DGDMTRX
%ZRLALPH*57.3
%CLAHTAL
%DCLHDCL
%DCLWDCL
%ETAFUNQ
%CMALPWF
%DCMWDCL
%==========================================================================
% prediction of drag due to form, skin friction and compressibility
tarlift=results.CL;% target global operating lift coefficient
clwingx=results.CLwing(1);% local wing operating lift coefficient (due to trim)
tarmach=M;% target Mach number
taraltd=state.ALT;% target altitude
tardisa=0;% target ISA deviation
% input array nomenclature is as follows:
% first array dim with 1 pointer - wing
% first array dim with 2 pointer - h-tail
% first array dim with 3 pointer - v-tail
% first array dim with 4 pointer - nacelles
% second array dim with 1  pointer - actual wetted area
% second array dim with 2  pointer - wetted area of original TORNADO model
% second array dim with 3  pointer - wetted area of revised TORNADO model
% second array dim with 4  pointer - MAC or length of original TORNADO model
% second array dim with 5  pointer - MAC or length of revised TORNADO model
% second array dim with 6  pointer - actual form factor
% second array dim with 7  pointer - revised form factor multiplier
% second array dim with 8  pointer - actual skin friction coefficient
% second array dim with 9  pointer - revised skin friction coefficient multiplier
% second array dim with 10 pointer - quarter-chord sweep of original TORNADO model
% second array dim with 11 pointer - quarter-chord sweep of revised TORNADO model
% second array dim with 12 pointer - thickness-to-chord of original TORNADO modeln Mac
% second array dim with 13 pointer - thickness-to-chord of revised TORNADO model
% second array dim with 14 pointer - nacelle diameter of original TORNADO model
% second array dim with 15 pointer - nacelle diameter of revised TORNADO model
% second array dim with 16 pointer - CDo of component with skin friction adjusted for speed/altitude 

% wing related parameter values 
pdrgprd(1,1)=116.7;
pdrgprd(1,2)=inpt.Swet(1,1);    pdrgprd(1,3)=inpt.Swet(1,2);
pdrgprd(1,4)=inpt.mac(1,1);     pdrgprd(1,5)=inpt.mac(1,2);
pdrgprd(1,6)=1.297;             pdrgprd(1,8)=0.00294;
pdrgprd(1,10)=inpt.qcws(1,1);   pdrgprd(1,11)=inpt.qcws(1,2);
pdrgprd(1,12)=inpt.tc(1,1);     pdrgprd(1,13)=inpt.tc(1,2);
% h-tail related parameter values 
pdrgprd(2,1)=41.5;
pdrgprd(2,2)=inpt.Swet(2,1);    pdrgprd(2,3)=inpt.Swet(2,2);
pdrgprd(2,4)=inpt.mac(2,1);     pdrgprd(2,5)=inpt.mac(2,2);
pdrgprd(2,6)=1.248;             pdrgprd(2,8)=0.00306;
pdrgprd(2,12)=inpt.tc(2,1);     pdrgprd(2,13)=inpt.tc(2,2);
% v-tail related parameter values 
pdrgprd(3,1)=29.7;
pdrgprd(3,2)=inpt.Swet(3,1);    pdrgprd(3,3)=inpt.Swet(3,2);
pdrgprd(3,4)=inpt.mac(3,1);     pdrgprd(3,5)=inpt.mac(3,2);
pdrgprd(3,6)=1.221;             pdrgprd(3,8)=0.00281;
pdrgprd(3,12)=inpt.tc(3,1);     pdrgprd(3,13)=inpt.tc(3,2);
% nacelle related parameter values 
pdrgprd(4,1)=20.7;
pdrgprd(4,2)=inpt.nacelle_Swet(1);      pdrgprd(4,3)=inpt.nacelle_Swet(2);
pdrgprd(4,4)=inpt.nacelle_length(1);    pdrgprd(4,5)=inpt.nacelle_length(2);
pdrgprd(4,6)=1.889;                     pdrgprd(4,8)=0.00304;
pdrgprd(4,14)=inpt.nacelle_diam(1);      pdrgprd(4,15)=inpt.nacelle_diam(2);
% component build-up of CDo
pdrgprd(1,16)=1e4*pdrgprd(1,1)*pdrgprd(1,6)*pdrgprd(1,8)/REFWARE;% original CDo of wing
pdrgprd(2,16)=1e4*pdrgprd(2,1)*pdrgprd(2,6)*pdrgprd(2,8)/REFWARE;% original CDo of h-tail
pdrgprd(3,16)=1e4*pdrgprd(3,1)*pdrgprd(3,6)*pdrgprd(3,8)/REFWARE;% original CDo of v-tail
pdrgprd(4,16)=1e4*pdrgprd(4,1)*pdrgprd(4,6)*pdrgprd(4,8)/REFWARE;% original CDo of nacelles
ancsko=EZELDRG-(pdrgprd(1,16)+pdrgprd(2,16)+pdrgprd(3,16)+ ...
                              pdrgprd(4,16));% original CDo of ancillary components
%initialise the primary outputs
tarrefc=0;precdrg=0;eskndrg=0;
% perform a global skin friction correction due to change in speed and/or altitude only
if (selreyn>0 & taraltd~=REFALTD) | (selreyn>0 & tarmach~=REFMACH)
    tarrefc=qxreynd(qxdmtks(tarmach,taraltd/100,tardisa),taraltd/100,tardisa,1)/REFVOMU-1;
% drag count incremental correction based upon supplied data
    precdrg=interp1(REYNCOR(1,1:numbrey),REYNCOR(2,1:numbrey),tarrefc*10,'cubic');
else
    precdrg=EZELDRG*(qxskfrc(qxdmtks(tarmach,taraltd/100,tardisa),taraltd/100,tardisa,1, ...
                             tarmach)/qxskfrc(qxdmtks(REFMACH,REFALTD,0),REFALTD,0,1,REFMACH)-1);
end
% perform correction to skin friction due to change in planform and/or nacelle parameters
for i=1:4
    if i<4
       pdrgprd(i,7)=(2+4*pdrgprd(i,13)+240*pdrgprd(i,13)^4)/(2+4*pdrgprd(i,12)+240*pdrgprd(i,12)^4);
    else
       pdrgprd(i,7)=(1+0.35*(pdrgprd(i,15)/pdrgprd(i,5)))/(1+0.35*(pdrgprd(i,14)/pdrgprd(i,4)));
    end   
    pdrgprd(i,9)=qxskfrc(qxdmtks(REFMACH,REFALTD,0),REFALTD,0,pdrgprd(i,5), ...
                        REFMACH)/qxskfrc(qxdmtks(REFMACH,REFALTD,0),REFALTD,0,pdrgprd(i,4),REFMACH);
% CDo of component adjusted for Reynolds, i.e. wetted area, length, speed and altitude    
    eskndrg=eskndrg+1e4*pdrgprd(i,1)*pdrgprd(i,3)/pdrgprd(i,2)*pdrgprd(i,6)*pdrgprd(i, ...
            7)*pdrgprd(i,8)*pdrgprd(i,9)/REFWARE+precdrg*pdrgprd(i,16)/EZELDRG;
end     
% look up the aerofoil technology level
emrefcl=interp1(MASTDRG(1,lwrclid:uprclid),rot90(MREFCAL(lwrclid:uprclid)),tarlift*10,'cubic');
% predict a revised drag divergence Mach 
eddmach=(emrefcl-(0.1*((tarlift/(cos(pdrgprd(1,13)*pi/180)^2))^1.5)+ ...
                          pdrgprd(1,13)/cos(pdrgprd(1,11)*pi/180)))/cos(pdrgprd(1,11)*pi/180);
% identify an equivalent CL according to the revised geometry
eeqopcl=interp1(rot90(DDVMACH(lwrclid:uprclid)),MASTDRG(1,lwrclid:uprclid),eddmach,'cubic')/10;                      
% final results of drag constituents
eskndrg=eskndrg+ancsko*(1+precdrg/EZELDRG);% revised CDo
efrmdrg=interp1(MASTDRG(1,lwrclid:uprclid),PROFCOR(lwrclid:uprclid),tarlift*10,'cubic');% form drag
% vehicular compressibility drag
ecomdrg=interp2(MASTDRG(1,lwrclid:uprclid),rot90(MASTDRG(lwrmhid:uprmhid,1)), ...
                          MASTDIZ(lwrmhid:uprmhid,lwrclid:uprclid),eeqopcl*10,tarmach*10,'cubic');
% incremental compressibility due to increment in wing lift
ocomdrg=interp2(MASTDRG(1,lwrclid:uprclid),rot90(MASTDRG(lwrmhid:uprmhid,1)), ...
                          MASTDIZ(lwrmhid:uprmhid,lwrclid:uprclid),tarlift*10,tarmach*10,'cubic');
etcpdrg=(interp2(MASTDRG(1,lwrclid:uprclid),rot90(MASTDRG(lwrmhid:uprmhid,1)), ...
                 MASTDIY(lwrmhid:uprmhid,lwrclid:uprclid),clwingx*10, ...
                 tarmach*10,'cubic')- ...
         interp2(MASTDRG(1,lwrclid:uprclid),rot90(MASTDRG(lwrmhid:uprmhid,1)), ...
         MASTDIY(lwrmhid:uprmhid,lwrclid:uprclid),tarlift*10,tarmach*10,'cubic'))/ocomdrg*ecomdrg;  
if etcpdrg<0
   etcpdrg=0;
end

end