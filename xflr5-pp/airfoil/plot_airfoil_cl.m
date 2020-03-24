
clear

filename       = 'data/NACA 0012.dat';
delimiterIn    = ' ';
headerlinesIn  = 1;
format long;

airfoil_struct = importdata(filename,delimiterIn,headerlinesIn);

fields = fieldnames(airfoil_struct);
coord  = char(fields(1));

airfoil_coord = airfoil_struct.(coord);

x = airfoil_coord(:,1); % airfoil coordinates 
y = airfoil_coord(:,2); % airfoil coordinates  

npoints = length(x)

aoa = 4.0; % deg

aoa = aoa*3.14/180; % rad

% Specify the coordinates of the center of rotation

Xc = 0.25;
Yc = 0.00;

X = x; 
Y = y; 

% Rotating the airfoil about the 1/4 chord point 

x =   (X - Xc)*cos(aoa) + (Y - Yc)*sin(aoa) + Xc;
y = - (X - Xc)*sin(aoa) + (Y - Yc)*cos(aoa) + Yc;

figure(1);
plot(x,y,'.','MarkerSize',20);

axis equal;
hold off;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

filename       = 'data/naca12-cp-a40.txt';
delimiterIn    = ' ';
headerlinesIn  = 6;
format long;

analysis_struct = importdata(filename,delimiterIn,headerlinesIn);

fields = fieldnames(analysis_struct);
analysis  = char(fields(1));

airfoil_analysis = analysis_struct.(analysis);

p = airfoil_analysis(:,2); % just the pressure distribution

figure(2);
plot(airfoil_analysis(:,1),airfoil_analysis(:,2),'g.','MarkerSize',20);

hold on
set(gca, 'YDir','reverse');
% axis equal;
hold off

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

npanels = npoints - 1

for k = 1 : npanels 
  
  deltaX = x(k+1) - x(k); 
  deltaY = y(k+1) - y(k);

  Cpress = (p(k+1) + p(k))/2;

  panlen = sqrt(deltaX^2 + deltaY^2);

  ny = deltaX/panlen;
  nx = deltaY/panlen;

  lift(k) = ny*Cpress*panlen;
  drag(k) = nx*Cpress*panlen;

end

cl = sum(lift)

cd = sum(drag)

