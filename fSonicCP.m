function [output]=fsonicCP(state)

[state.rho sos p_1]=ISAtmosphere(state.ALT);
output=1-sos^2/state.AS.^2;