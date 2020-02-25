function [state,results,lattice,ref]=iterateAlpha(engine,state,weight,qS,results,geo,lattice,ref,solvertype,TZtot,CD,toggle,trimwing,Raxle,hinge_pos,rudderangle)
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
% usage: []=iterateAlpha(engine,state,weight,qS,results,geo,lattice,ref,solvertype,max_iterations);
%
% This is a function to iterate the angle of attack, state.alpha, such that
% the heave forces due to the lift, aircraft weight and engine thrust are balanced. 
%
% Example:
%
%   []=iterateAlpha(engine,state,weight,qS,results,geo,lattice,ref,solvertype,max_iterations);
%
% Calls:
%           engine
%           state
%           weight
%           qS
%           results
%           geo
%           lattice
%           ref
%           solvertype
%           max_iterations
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Baseline results
max_iterations=30;
da=0.0005;
alpha_old=state.alpha;
k=0;
CW=-(weight.gravity*weight.unitvector(3)+TZtot)/qS;
CZ0=results.CZ+CD(3);

%% Iterating
if abs(CW-CZ0)>=0.001
    converged=0;
    while ~converged
        k=k+1;
        state.alpha=state.alpha+da;
        
    if trimwing
        lattice=wingrotation2(trimwing,geo,lattice,Raxle,hinge_pos,rudderangle);
    else
        [lattice,ref]=fLattice_setup2(geo,state,solvertype);
    end
    
        [results]=solver9(results,state,geo,lattice,ref);
        [results]=coeff_create3(results,lattice,state,ref,geo);
        CZ1=results.CZ+CD(3);
        
        if abs(CW-CZ1)<0.001
            converged=1;
            if toggle>0
                state.alpha=2*state.alpha-alpha_old; %increases alpha step to speed up iteration
            end
            return 
        end

        if k>max_iterations
            tdisp('NOT CONVERGED!!!')
            results=[];
            return
        end
    
        dEQ_da=(CZ0-CZ1)/da;
        da=-0.5*(CW-CZ1)/dEQ_da;
        CZ0=CZ1;
	end
end
