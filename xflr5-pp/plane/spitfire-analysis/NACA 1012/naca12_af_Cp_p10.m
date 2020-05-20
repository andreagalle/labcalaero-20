clc


filename       = 'NACA 1112.dat';
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
filename       = 'cp_aoa_14.txt';
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

n=length(airfoil_coord);
F=zeros(n-1);
F=F(:,1);
Cd=0;
Cl=0;
for i=1:n-1
    X(i)=airfoil_coord(i+1,1)-airfoil_coord(i,1);
    Y(i)=airfoil_coord(i+1,2)-airfoil_coord(i,2);
    L(i)=(X(i)^2 + Y(i)^2)^(1/2);
    %%%cordinate locali (versorex=(x2-x1)/modX)versorey= (x2-x1)/modx)
    P(i,1)=airfoil_analysis(i,2)*L(i);
    Cl=Cl + P(i,1)*X(i)/L(i);
    Cd=Cd + P(i,1)*Y(i)/L(i);
    
end
format short
Cl
Cd
