function []=old2new(ac_name);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% old2new, subsidary function to TORNADO     %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%	ac_name = name of geometry file (string)
%
%   This function translates old geometry files
%   into the new geometry standard (T123b)
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%




cd aircraft
	load(ac_name);

    ref_point=[0 0 0];
    flap_vector=zeros(size(flapped));


save(ac_name,'fnx','ny','nx','fsym','fc','flapped','TW','foil','T','SW','c','dihed','b','symetric','startx','starty','startz','nwing','nelem','flap_vector','ref_point') ;  
disp('*** File Converted. ****');

    
    
    
cd ..



