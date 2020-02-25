function []=revdrag14edit4(JID)
%function[A b c d]=revdrag14edit4(JID) %*** to be used once dynamic, tuned
%*** coefficient capability is included

% reverse engineer drag polar using geometric manipulation 
% coupled to simplified theory

settings=config('startup'); % calls config to establish directory paths %***
cd ..
cd(settings.hdir)

DRWSELN=1;
cd(settings.pdir) %***
%qsetpat(3);% set the correct path name for drag files 
%***qsetpat unnecessary if Tornado 'config.m' is used to establish paths instead
%***except for unix, linux capability
[fname,pname]=uigetfile('*.DAT','Drag Calibration Archive');

disp(' ') %***
disp('Solution started, please wait. ') %***
disp(' ') %***

if fname~=0
   winselc{DRWSELN}=strtok(fname,'.');
   coord=load (strcat(pname,fname));%***
   
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
   REFCGLC=coord(startct,1);% ref. centre of gravity
   REFAECN=coord(startct,2);% ref. aero centre
   THRSARM=coord(startct,3);% thrust arm
   startct=stopcnt+3;
   HTALVOL=coord(startct,1);% h-tail volume coefficient
   REFAHTL=coord(startct,2);% h-tail ref area
   REFHTAR=coord(startct,3);% h-tail ref aspect ratio
   HTALARM=coord(startct,4);% h-tail moment arm
   startct=stopcnt+4;
   REFWASR=coord(startct,1);% ref wing aspect ratio
   REFWMAC=coord(startct,2);% ref wing MAC
   VEHWETD=coord(startct,3);% vehicle wetted area
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
% OPTIONAL: record the lift-curve slope corrected for Mach
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
% OPTIONAL: record the zero-lift pitching moment corrected for Mach
   if selclac==0
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
end
% perform manipulation to coalesce out drag constituents
% coalesce out the trim condition and resulting drag constituents
% first approach assuming known neutral point and zero-lift pitching moment
CMALPHA=zeros(numbmhs+1,numbcls+1);% pitching moment gradient due to AoA
DEALPHA=zeros(numbmhs+1,numbcls+1);% difference between given AoA and zero-lift AoA
CMAEROC=zeros(numbmhs+1,numbcls+1);% moment related to change in AoA (no propulsion)
CLHTAIL=zeros(numbmhs+1,numbcls+1);% lift coeff. of h-tail
CLINCWN=zeros(numbmhs+1,numbcls+1);% incremental lift coeff. of wing
CLWINGA=zeros(numbmhs+1,numbcls+1);% actual lift coeff. of wing
for i=lwrmhid:uprmhid
% interpolate neutral point for given Mach and then adjust for centre of gravity
    npointi=0.1*interp1(NPLCCOR(1,1:numbnpl),NPLCCOR(2,1:numbnpl),MASTDRG(i,1),'cubic')-0.01*REFCGLC;
% interpolate lift-curve slope for given Mach
    clawngi=interp1(CLACCOR(1,1:numbcla),CLACCOR(2,1:numbcla),MASTDRG(i,1),'cubic');
% interpolate zero-lift pitching moment for given Mach
    zelipmi=-0.1*interp1(ZLPMCOR(1,1:selzlpm),ZLPMCOR(2,1:selzlpm),MASTDRG(i,1),'cubic');
    for j=lwrclid:uprclid
        CMALPHA(i,j)=-npointi*clawngi;
        DEALPHA(i,j)=-npointi*0.1*MASTDRG(1,j)/CMALPHA(i,j);
        CMAEROC(i,j)=-npointi*0.1*MASTDRG(1,j);
        CLWINGA(i,j)=-(zelipmi+1e-4*MASTDRG(i,j)*THRSARM+ ...
                      HTALVOL*REFWARE/REFAHTL*0.1*MASTDRG(1,j))/(0.01*(REFCGLC-REFAECN)- ...
                      HTALVOL*REFWARE/REFAHTL);
        CLINCWN(i,j)=CLWINGA(i,j)-0.1*MASTDRG(1,j);
        CLHTAIL(i,j)=-CLINCWN(i,j)*REFWARE/REFAHTL;
    end
end
% quantify the CDa of the aircraft
CDALPHA=zeros(numbmhs+1,numbcls+1);% rate change of total drag w.r.t. AoA
[CDALPHA]=numdifd(numbmhs,numbcls,lwrmhid,uprmhid,lwrclid,uprclid,DEALPHA,MASTDRG,1,1e-4,0);
CLWINGA(1,:)=0.1*MASTDRG(1,:);CLWINGA(:,1)=0.1*MASTDRG(:,1);
% solve for the lift-curve slope of the h-tail
dclwdcl=zeros(numbmhs+1,numbcls+1);% rate change of wing lift w.r.t. global lift coefficient
tauclah=zeros(numbmhs+1,numbcls+1);% lift-curve slope of H-tail factored by qt/q
HTALPHA=zeros(numbmhs+1,numbcls+1);% AoA of H-tail when trimmed
[dclwdcl]=numdifd(numbmhs,numbcls,lwrmhid,uprmhid,lwrclid,uprclid,MASTDRG,CLWINGA,0.1,1,1);
for i=lwrmhid:uprmhid
    for j=lwrclid:uprclid
        dnwashi=0.1*interp1(DWHTCOR(1,1:numbdwh),DWHTCOR(2,1:numbdwh),MASTDRG(i,1),'cubic');
        clawngi=interp1(CLACCOR(1,1:numbcla),CLACCOR(2,1:numbcla),MASTDRG(i,1),'cubic');
        tauclah(i,j)=clawngi*(1-dclwdcl(i,j))*REFWARE/(REFAHTL*(1-dnwashi));        
        HTALPHA(i,j)=CLHTAIL(i,j)/tauclah(i,j);
    end
end
% estimate the vortex-induced drag contribution
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
OSWALDF=1/(VORINDF*pi*REFWASR);% equivalent Oswald factor
vorinrd=zeros(numbcls+1,1);
MASTDRI=zeros(numbmhs+1,numbcls+1);% drag polar minus the vortex-induced drag
for i=lwrmhid:uprmhid
    for j=lwrclid:uprclid
        if MASTDRG(i,j)>0
           vorinrd(j)=1e4*VORINDF*0.01*MASTDRG(1,j)^2;
           MASTDRI(i,j)=MASTDRG(i,j)-vorinrd(j);
        end
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
MASTDIZ=zeros(numbmhs+1,numbcls+1);
EZELDRG=MASTDRI(lwrmhid,lockvif)-(TCDTINC(lwrmhid,lockvif)+TCDWINC(lwrmhid,lockvif)+ ...
                                  TTTHRST(lwrmhid,lockvif));% zero-lift drag coefficient
PROFCOR=zeros(1,numbcls+1);% form drag as a function of operating lift coefficient                              
for i=lwrmhid:uprmhid
    for j=lwrclid:uprclid
        if MASTDRI(i,j)~=0
           MASTDIZ(i,j)=MASTDRI(i,j)-EZELDRG-(TCDTINC(i,j)+TCDWINC(i,j)+TTTHRST(i,j));
           if i<lwrmhid+1
              PROFCOR(1,j)=MASTDIZ(i,j);
           end
           MASTDIZ(i,j)=MASTDIZ(i,j)-PROFCOR(1,j);
        end
    end
end
TCDCINC=zeros(numbmhs+1,numbcls+1);% incremental compressibility drag due to wing lift increment
for i=lwrmhid:uprmhid
    for j=lwrclid:uprclid
        if MASTDIZ(i,j)>0
           incclci=interp1(MASTDRG(1,lwrclid:uprclid),MASTDIZ(i,lwrclid:uprclid),10*CLWINGA(i,j),'cubic');
           TCDCINC(i,j)=incclci-MASTDIZ(i,j);
        end
    end
end
MASTDIZ=MASTDIZ-TCDCINC;% compressibility drag matrix adjusted for wing incremental lift effect
TTLTRMD=zeros(numbmhs+1,numbcls+1);% total trim drag matrix
TTLTRMD=TCDTINC+TCDWINC+TTTHRST+TCDCINC;

%MASTDRG
%vorinrd
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
%dclwdcl
%TTLTRMD
%CMALPHA
%CDALPHA
%DEALPHA*57.3
%MASTDIZ

cd(settings.odir) % moves to Tornado output directory %*** 

infofile; % calls function infofile to write results to file %***
drgfile; % calls function drgfile to write drag results to file %***

cd(settings.hdir) % returns to Tornado home directory %***


% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function qsetpat(dummy)
% % modified for unix, mac, linux
% % and blanks in filenames
% % directory names only lower case 070603
% %QSETPAT This routine allows the user to pre-define the paths used during
% %        QCARD's access to various working files. 
% % tested 070618 (Windows)
% %============================================================================
% global ledpath
% %=====
% %qcardhome    = 'C:\Documents and Settings\Owner\My Documents\Rizzi\simsac\qcard-mmvi';
% %simsachome = 'C:\Documents and Settings\Owner\My Documents\Rizzi\simsac';
% %qcardhome='P:\Projects\QCARD-MMVI';
% qcardhome='C:\Documents and Settings\at4119\My Documents\Polars\QCARD-MMVI-edit2'; %***
% %qcardhome='D:\Aerospace Engineering\Drag Polar Research\Polars\QCARD-MMVI-edit2'; %***
% %qcardhome='D:\Aerospace Engineering\Drag Polar Research\Tornado\tornadocode\T134export'; %***
% qcardhome='C:\Documents and Settings\at4119\My Documents\Tornado\tornadocode\T134exportedit'; %***
% % set path
% addpath(qcardhome);
% %addpath([qcardhome,filesep,'tornado']);
% %addpath([qcardhome,filesep,'mitchell']); %***
% %addpath([simsachome,filesep,'T131e']); %***
% ledpath=['cd(''',qcardhome];
% if dummy==0
% % common leading path
%    eval(strcat(ledpath,''');'));% set path for the project management interface   
% elseif dummy==1
% % set path for the aircraft projects library   
%    eval(strcat(ledpath,filesep,'projects'');'));
% elseif dummy==2
% % set path for the aerofoil library 
%    eval(strcat(ledpath,filesep,'aerofoil'');'));
% elseif dummy==3
% % set path for the drag polars library
%    eval(strcat(ledpath,filesep,'polars'');'));
% elseif dummy==4
% % set path for the propulsion library   
%    eval(strcat(ledpath,filesep,'engines'');'));
% elseif dummy==5
% % set path for exporting any figure snapshots   
%    eval(strcat(ledpath,filesep,'snapshots'');'));
% end
% return
% end %qsetpat function
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [senddat,numbdat]=storedt(startc1,stopcn1,selcol1,selclr1, ...
                                   origfil,lwrlimt,uprlimt,valfact,datflag,numdat1,numdat2);
% This routine reads information from an external aero file and produces a
% format compatible with subsequent processing 
%=====
if datflag<2
   numbdat=1;% special case for reading in absciccas for the drag polar
   senddat=zeros(1,(stopcn1-startc1)*selcol1);
else
   senddat=zeros(numdat1,numdat2);
   numbdat=0;
end
k=1;h=1;% variable counters for array
for i=startc1:stopcn1
    for j=1:selcol1
        if origfil(i,j)>=lwrlimt & origfil(i,j)<uprlimt 
           if datflag<2
              senddat(h)=valfact*origfil(i,j);% read in the values
              if datflag==1
                 if h~=1 & senddat(h)~=0
                    numbdat=numbdat+1;
                 end
              end
           else
              senddat(k,h)=valfact*origfil(i,j);    % read in and factor all values in specified input data by multiplier "valfact"
           end
        end
        if datflag<2
           h=h+1;% counter
        else
           if h<selclr1*selcol1
              h=h+1;% record new Mach number
           else
              h=1;% cycle through CL values again
              k=k+1;% record new Mach number
           end
        end   
    end
end
return

end %storedt function
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [diffres]=numdifd(numdta1,numdta2,lwrlimm,uprlimm,lwrlimc,uprlimc,indepnt,dependt, ...
                           valfac1,valfac2,ilockvr)        
% This routine performs numerical differentiation using 3-point asymmetric finite difference,
% backward difference and 3-point symmetric finite difference algorithms
%=====
diffres=zeros(numdta1+1,numdta2+1);
for i=lwrlimm:uprlimm
    for j=lwrlimc:uprlimc
        if ilockvr~=0
           t=ilockvr;
        else
           t=i;
        end
        if j==lwrlimc
% employ the 3-point asymmetric finite difference algorithm
           delalj1=valfac1*(indepnt(t,j+1)-indepnt(t,j));delalj2=valfac1*(indepnt(t,j+2)-indepnt(t,j+1));
           diffres(i,j)=(-delalj2*(2*delalj1+delalj2)*valfac2*dependt(i,j)+ ...
                        ((delalj1+delalj2)^2)*valfac2*dependt(i,j+1)- ...
                        (delalj1^2)*valfac2*dependt(i,j+2))/(delalj1*delalj2*(delalj1+delalj2));
        elseif j==uprlimc | dependt(i,j+1)==0
% employ the backward difference algorithm
               delalj0=valfac1*(indepnt(t,j)-indepnt(t,j-1));
               diffres(i,j)=valfac2*(dependt(i,j)-dependt(i,j-1))/delalj0;
        else
% employ the 3-point symmetric finite difference algorithm
               delalj0=valfac1*(indepnt(t,j)-indepnt(t,j-1));delalj1=valfac1*(indepnt(t,j+1)-indepnt(t,j));
               diffres(i,j)=((delalj0^2)*valfac2*dependt(i,j+1)-(delalj1^2)*valfac2*dependt(i,j-1)+ ...
                            ((delalj1^2)-(delalj0^2))*valfac2*dependt(i,j))/(delalj0*delalj1*(delalj0+ ...
                            delalj1));
        end
    end
end
return

end % numdifd function
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function infofile() %***
    
fname=strcat(JID,'-Cx_drginf'); %***
cd(settings.odir) %***
save(fname,'numbmhs','numbcls','MASTDRG','vorinrd','VORINDF','VOINFCL','OSWALDF','EZELDRG', ... %***
    'PROFCOR','TCDTINC','CLHTAIL','TCDWINC','TTTHRST','TCDCINC', ... %***
    'CLWINGA','dclwdcl','TTLTRMD','CMALPHA','CDALPHA','DEALPHA','MASTDIZ') %***

disp(' ') %***
disp(strcat(' Solution available in output/',fname)) %***

end %infofile function %***
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function drgfile() %***

fname=strcat(JID,'-Cx_drgout'); %***
cd(settings.odir) %***
save(fname,'numbmhs','numbcls','MASTDRG','vorinrd','VORINDF','VOINFCL','OSWALDF','EZELDRG', ... %***
    'PROFCOR','TCDTINC','CLHTAIL','TCDWINC','TTTHRST','TCDCINC', ... %***
    'CLWINGA','dclwdcl','TTLTRMD','CMALPHA','CDALPHA','DEALPHA','MASTDIZ') %***
cd(settings.hdir) %***

disp(strcat(' Solution available in output/',fname)) %***
disp(' ') %***

end %drgfile function %***
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


end %revdrag



