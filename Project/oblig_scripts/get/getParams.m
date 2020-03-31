% GET PARAMETERS FROM FILE "params.tfs"
% Format: [ nParticles, energy, emit_Nx, emit_Ny, sigma_E, quad_dx, quad_dy, bpm_dx, bpm_dy, kQuad, deltaE ]
function [ params ] = getParams()

    % declare parameter file
    paramsFile = 'params.tfs';
    
    headerLinesIn = 4;
    
    %Return parameter list
    params = readAsciiData(paramsFile,headerLinesIn);
end


