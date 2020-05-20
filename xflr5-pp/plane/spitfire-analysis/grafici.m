clc
clear all 


NACA0012=[-2,-0.2521,0.0088;
          -1.5,-0.1921,0.0053;
          -1,-0.1322,0.0028;
          -0.5,-0.0727,0.0014;
          0,-0.0131,0.0011;
          0.5,0.0463,0.0017;
          1,0.1054,0.0035;
          1.5,0.1646,0.0062;
          2,0.2234,0.0100;
          2.5,0.2821,0.0148;
          3,0.3403,0.0207;
          3.5,0.3984,0.0276;
          4,0.4561,0.0355;
          4.5,0.5137,0.0445;
          5,0.5709,0.0544];

NACA1012=[-2,-0.1479,0.0057;
          -1.5,-0.0886,0.0032;
          -1,-0.0290,0.0016;
          -0.5,0.0303,0.0011;
          0,0.0895,0.0016;
          0.5,0.1483,0.0032;
          1,0.2071,0.0058;
          1.5,0.2658,0.0094;
          2,0.3241,0.0141;
          2.5,0.3822,0.0198;
          3,0.4401,0.0265;
          3.5,0.4977,0.0343;
          4,0.5549,0.0431;
          4.5,0.6121,0.0529;
          5,0.6687,0.0638];
      
NACA1112=[-2,-0.1461,0.0063;
          -1.5,-0.0862,0.0038;
          -1,-0.0263,0.0023;
          -0.5,0.0333,0.0019;
          0,0.0927,0.0025;
          0.5,0.1522,0.0041;
          1,0.2115,0.0067;
          1.5,0.2703,0.0104;
          2,0.3290,0.0151;
          2.5,0.3876,0.0208;
          3,0.4458,0.0276;
          3.5,0.5039,0.0353;
          4,0.5615,0.0441;
          4.5,0.6189,0.0539;
          5,0.6760,0.0647];
figure(3);

plot(NACA0012(:,1),NACA0012(:,2),'--ro');

hold on
plot(NACA1012(:,1),NACA1012(:,2),'.-.');
hold off

hold on
plot(NACA1112(:,1),NACA1112(:,2));
hold off

xlabel('Angle of Attack')
ylabel('Lift Coefficient')
title('0012 vs 1012 vs 1112')
legend('NACA0012','NACA1012','NACA1112')
ax = gca;
ax.XAxisLocation = 'origin';
ax.YAxisLocation = 'origin';
box  off;

figure(4);

plot(NACA0012(:,1),NACA0012(:,3),'--ro');
ln.Color = [1 0 0];

hold on
plot(NACA1012(:,1),NACA1012(:,3),'.-.');
ln.Color = [0 1 0];
hold off

hold on
plot(NACA1112(:,1),NACA1112(:,3));
hold off

xlabel('Angle of Attack')
ylabel('Drag Coefficient')
title('0012 vs 1012 vs 1112')
legend('NACA0012','NACA1012','NACA1112')
ax = gca;
ax.XAxisLocation = 'origin';
ax.YAxisLocation = 'origin';
box  off;

figure(5);

plot(NACA0012(:,3),NACA0012(:,2),'--ro');

hold on
plot(NACA1012(:,3),NACA1012(:,2),'.-.');
hold off

hold on
plot(NACA1112(:,3),NACA1112(:,2));
hold off

xlabel('Drag Coefficient')
ylabel('Lift Coefficient')
title('Polar plot')
legend('NACA0012','NACA1012','NACA1112')
ax = gca;
ax.XAxisLocation = 'origin';
ax.YAxisLocation = 'origin';
box  off;