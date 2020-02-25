function[TW2]=fAdjusted_twist(TW,b,net_twist,Wing)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%	Geometry function 						 			 	
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%	Computes the twist tensor with a linear 
%  variance across the whole span.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Author: Tomas Melin, KTH, Department of% 
%	Aeronautics, copyright 2002				
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%	Context: Auxillary function for TORNADO
%	Called by: none-yet                    
%	Calls:	None						   
%	Loads:	None						   
%	Generates: Twist tensor TW2
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  lemma function to create an linear twist 
%  form root to tip of wing (# Wing) when the 
%  partition spans vary.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%! Remember, twist input in radians here !


root_twist=TW(Wing,1,1);
span=b(Wing,:);			%selecting appropriate wing.
span2=span(find(span));	%just using nonzero span.

span_part=cumsum(span2)./(sum(span2));
total_twist=net_twist-root_twist;		  %		
twist2=total_twist.*span_part;           %partial twist linear increment across partitions

TW2=TW;
TW2(Wing,:,2)=twist2;
TW2(Wing,:,1)=[0 twist2(1:end-1)];
