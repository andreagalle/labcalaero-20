A=[-2,-0.1494,0.0057;
  -1,-0.0274,0.0017; 
   0,0.0938,0.0018;
   1,0.2147,0.0062;
   2,0.3343,0.0147;
   3,0.4531,0.0273;
   4,0.5707,0.0441;
   5,0.6871,0.0650;
   6,0.8020,0.0900;
   7,0.9154,0.1190;
   8,1.0270,0.1521;
   9,1.1368,0.1891;
  10,1.2446,0.2301;
  11,1.3504,0.2750;
  12,1.4539,0.3237;
  13,1.5551,0.3762;
  14,1.6537,0.4324;
  15,1.7497,0.4922;
  16,1.8430,0.5556;
  17,1.9336,0.6225;
  18,2.0210,0.6929];

figure(3);
plot(A(:,1),A(:,2));

hold on
plot(A(:,1),A(:,3),'.-');
hold off

figure(4);
plot(A(:,3),A(:,2));
hold off