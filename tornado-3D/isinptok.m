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
% usage: [-] = ISINPTOK (A)
%
% This function check if an input conforms to the Tornado interface
% standard. A is the input from an interface question.
%
% Example:
%
%  while ok1==0
%       data=input('Number of Wings: ','s');
%       if isinptok(data)==1;
%           geo.nwing=str2num(data);
%           ok1=1;
%       end
%  end
%
% Calls:
%       None.
%
% Author: Tomas Melin <melin@kth.se>
% Keywords: Input checker.
%
% Revision History:
%   Future             :  move to input function?    
%   Bristol, 2007-06-27:  Addition of new header. TM
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [ok,data]=isinptok(data)%is input ok?

if ischar(data)
   if sum(strcmp(data,{'b' 'B'}));		%is data 'b' or 'B'? 
      ok=-1;										%signal back menue
      return
   elseif sum(strcmp(data,{'q' 'Q'}));	%is data 'q' or 'Q'?       
      ok=-2;										%signal escape menu
      return
   end
   %data=str2num(data);
end
if isempty(data)
   ok=0;
   return
end

data=data(1);
ok=1; 



