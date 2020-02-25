
filename       = 'data/NACA 0012.dat';
delimiterIn    = ' ';
headerlinesIn  = 1;
format long;

airfoil_struct = importdata(filename,delimiterIn,headerlinesIn);

fields = fieldnames(airfoil_struct);
coord  = char(fields(1));

airfoil_coord = airfoil_struct.(coord);

figure(1);
plot(airfoil_coord(:,1),airfoil_coord(:,2),'.','MarkerSize',20);

axis equal;
hold off;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

filename       = 'data/naca12-cp-a10.txt';
delimiterIn    = ' ';
headerlinesIn  = 6;
format long;

analysis_struct = importdata(filename,delimiterIn,headerlinesIn);

fields = fieldnames(analysis_struct);
analysis  = char(fields(1));

airfoil_analysis = analysis_struct.(analysis);

figure(2);
plot(airfoil_analysis(:,1),airfoil_analysis(:,2),'g.','MarkerSize',20);

hold on
set(gca, 'YDir','reverse');
% axis equal;
hold off
