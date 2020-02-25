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
% usage: [-] = f_version_geo_transform (-)
%
% Provides the user interface to changes a geometry file 
% from old v126 standard to new v131  file standard.
%
% Example:
%
%  [void]=f_version_geo_transform(void);
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

function []=f_version_geo_transform();

disp(' ******************  ')
disp(' ')
disp(' Geometry conversion function. v126 to v131 standard')
disp(' ')

%% Listing available geometries
cd aircraft
ls
cd ..
%% Reading filename and parsing to next function
fname=input('Convert file: ','s');
fOld2New2(fname);

%% Closeout 
disp(' ')
disp('******************  ')
disp(' ')