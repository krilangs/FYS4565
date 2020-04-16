% RUNS SCRIPT "main.madx" IN MADX
function [] = runMADX()
    
    % main file
    mainFile = 'main.madx';
    
    % run MADX and print progress
    fprintf('Running MADX... ');
    %syscmd = ['./madx ' mainFile]; % MAC/linux 
    syscmd = ['madx.exe < ' mainFile]; % Windows
    evalc('system(syscmd)'); % quiet execution
    %system(syscmd); % verbose execution
    disp('Done.');

end

