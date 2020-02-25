%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Copyright (C) 1999, 2007 Tomas Melin
%
% This file is part of Tornado
%
% Tornado is free software; you can redistribute it and/or
% modify it under the terms of the GNU General Public
% License as published by the Free Software Foundation;
% either version 2, or (at your option) any later version.
%
% Tornado is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied
% warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR
% PURPOSE.  See the GNU General Public License for more
% details.
%
% You should have received a copy of the GNU General Public
% License along with Tornado; see the file GNU GENERAL 
% PUBLIC LICENSE.TXT.  If not, write to the Free Software 
% Foundation, 59 Temple Place -Suite 330, Boston, MA
% 02111-1307, USA.
%
% usage: [-] = fOld2New (FILENAME)
%
% Changes a geometry file FILENAME 
% from old v126 standard to new v131 file standard.
%
% Example:
%
%  [void]=fOld2New('Cessna172');
%
% Calls:
%       fOld2New2                   Does the actual transformation. 
%
% Author: Tomas Melin <melin@kth.se>
% Keywords: Tornado text based user interface
%
% Revision History:
%   Bristol,  2007 06 27:  Addition of new header. TM.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function []=old2new(ac_name);

cd aircraft
    try
        load(ac_name);
    catch
        cd ..
        terror(4);
        disp('no file changed')
        return
    end
for i=1:geo.nwing
    for j=1:geo.nelem(i)
        foo(i,j,1)={num2str(geo.foil(i,j,1))};
        foo(i,j,2)={num2str(geo.foil(i,j,2))};
    end
end
geo.foil=foo;
geo.CG=[0 0 0];
tor_version=131;

save(strcat(ac_name,'_v131'),'geo','tor_version') ;  
 disp(strcat('Converted file saved as:',strcat(ac_name,'_v131')));
cd ..