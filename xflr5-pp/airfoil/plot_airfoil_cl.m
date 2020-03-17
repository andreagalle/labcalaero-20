
filename       = 'data/NACA 0012.dat';
delimiterIn    = ' ';
headerlinesIn  = 1;
format long;

airfoil_struct = importdata(filename,delimiterIn,headerlinesIn);

fields = fieldnames(airfoil_struct);
coord  = char(fields(1));

airfoil_coord = airfoil_struct.(coord);

x = airfoil_coord(:,1); 
y = airfoil_coord(:,2); 

%figure(1);
%plot(airfoil_coord(:,1),airfoil_coord(:,2),'.','MarkerSize',20);
%
%axis equal;
%hold off;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

filename       = 'data/naca12-cp-a40.txt';
delimiterIn    = ' ';
headerlinesIn  = 6;
format long;

analysis_struct = importdata(filename,delimiterIn,headerlinesIn);

fields = fieldnames(analysis_struct);
analysis  = char(fields(1));

airfoil_analysis = analysis_struct.(analysis);

p = airfoil_analysis(:,2);

%figure(2);
%plot(airfoil_analysis(:,1),airfoil_analysis(:,2),'g.','MarkerSize',20);
%
%hold on
%set(gca, 'YDir','reverse');
%% axis equal;
%hold off

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for k = 1 : (length(x) - 1)
  
  l(k) = sqrt((x(k+1)-x(k))^2+(y(k+1)-y(k))^2);
  t(k) = (x(k+1)-x(k))/l(k);
  n(k) = t(k)*l(k);
  a(k) = n(k)*p(k);

end

cl = sum(a)
