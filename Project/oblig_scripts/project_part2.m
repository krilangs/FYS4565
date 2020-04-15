clear all;
%clf;

% Set working folder
cd C:\Users\krisl\.Matlab\FYS4565\Project\oblig_scripts\

% Add to path getters and setters
addpath("get", "set");

n = 2e4;
setParticleNumber(n);

mass = 0.511e-3; % GeV

% Running original orbit
resetKickers;
setEnergy(1.0);
setEnergySpread(0.01);
setEnergyOffset(0.0);
setQuadStrength(1.4142);
setQuadMisalignments(0.001,0.001);
setBpmMisalignments(0.0,0.0);

runMADX;
%{
[x0,y0,s] = getBPMreadings();


%% Adding the 1-to-1 steering corrections
x1 = OneToOne();

% Plotting the orbits
fig1 = figure();
plot(s,x0,"Linestyle","--","Marker","o","linewidth",1.5);
hold on;
plot(s,x1,"Linestyle","-.","Marker","x","linewidth",1.5);
grid on;
axs = gca;
set(gca,"TickLabelInterpreter","Latex","fontsize",11);
ylabel("Mean BPM positions [m]", "Interpreter", "Latex", "fontsize", 15);
xlabel("BPM s-position [m]", "Interpreter", "Latex", "fontsize", 15);
legend(axs,"Original","Corrected","Interpreter","Latex","fontsize",...
        15,"Location","best");
title("BPM orbit - 1-to-1 corrected","Fontsize",18,"Interpreter","Latex");
%saveas(gcf,"../Figures/1-to-1-orbits","jpg");


%% Plot emittance growth 
setEnergy(1.0);
setEnergySpread(0.01);

n_points = 10;
misalign = linspace(0,2e-3,n_points);

resetKickers;
EmGrowthX0 = EmittanceGrowth(misalign,"none");
EmGrowthX_c = EmittanceGrowth(misalign,"1to1");

fig2 = figure();
plot(misalign,EmGrowthX_c,"Linestyle","--","Marker","o","linewidth",1.5);
hold on;
plot(misalign,EmGrowthX0,"Linestyle","-.","Marker","x","linewidth",1.5);
grid on;
axs = gca;
set(gca,"TickLabelInterpreter","Latex","fontsize",11);
ylabel("Relative emittance growth [$\%$]","Interpreter","Latex", "fontsize", 15);
xlabel("Quadrupole misalignment [m]","Interpreter","Latex", "fontsize", 15);
legend(axs,"1-to-1 steer","Uncorrected","Interpreter","Latex",...
        "fontsize",15,"Location","best");
title("Emittance growth - 1-to-1","Fontsize",18,"Interpreter","Latex");
%saveas(gcf,"../Figures/growth_1-to-1","jpg");


%% Introduce BPM misalignments
setBpmMisalignments(0.001,0.001);
setQuadMisalignments(0.001,0.001);
resetKickers;
runMADX;

[x0,y0,s] = getBPMreadings();
x1 = OneToOne();

% Plotting the orbits
fig3 = figure();
plot(s,x0,"Linestyle","--","Marker","o","linewidth",1.5);
hold on;
plot(s,x1,"Linestyle","-.","Marker","x","linewidth",1.5);
grid on;
axs = gca;
set(gca,"TickLabelInterpreter","Latex","fontsize",11);
ylabel("Mean BPM positions [m]", "Interpreter", "Latex", "fontsize", 15);
xlabel("BPM s-position [m]", "Interpreter", "Latex", "fontsize", 15);
legend(axs,"Original","Corrected","Interpreter","Latex","fontsize",...
        15,"Location","best");
title("BPM orbit - BPM misalignments 1-to-1","Fontsize",18,"Interpreter","Latex");
%saveas(gcf,"../Figures/1-to-1-orbits_BPM","jpg");


%% Plot emittance growth w/misalignments
setBpmMisalignments(0.001,0.001);
setEnergySpread(0.01);

n_points = 10;
misalign = linspace(0,2e-3,n_points);

resetKickers;
EmGrowthX0 = EmittanceGrowth(misalign,"none");
EmGrowthX_c = EmittanceGrowth(misalign,"1to1");

fig4 = figure();
plot(misalign,EmGrowthX_c,"Linestyle","--","Marker","none","linewidth",1.5);
hold on;
plot(misalign,EmGrowthX0,"Linestyle","-.","Marker","none","linewidth",1.5);
grid on;
axs = gca;
set(gca,"TickLabelInterpreter","Latex","fontsize",11);
ylabel("Emittance growth [$\%$]","Interpreter","Latex", "fontsize", 15);
xlabel("Quadrupole misalignment [m]","Interpreter","Latex", "fontsize", 15);
legend(axs,"1-to-1 steer","Uncorrected","Interpreter","Latex",...
        "fontsize",15,"Location","best");
title("Emittance growth - 1-to-1 correction","Fontsize",18,...
        "Interpreter","Latex");
%saveas(gcf,"../Figures/growth_1-to-1_BPM","jpg");
%}
%{
%% Dispersion-free steering
% Get uncorrected trajectory
resetKickers;
setEnergy(1.0);
%setQuadStrength(1.4142);
setEnergySpread(0.01);
setEnergyOffset(0.0);
setBpmMisalignments(0.001,0.001);
setQuadMisalignments(0.001,0.001);
runMADX;

[x0, y0, s0] = getBPMreadings();

% Get DFS corrected orbits
[x_c, y_c, s] = DFS(0.001);

% Plotting the orbits
fig5 = figure();
plot(s,x0,"Linestyle","--","Marker","o","linewidth",1.5);
hold on;
plot(s,x_c,"Linestyle","-.","Marker","x","linewidth",1.5);
grid on;
axs = gca;
set(gca,"TickLabelInterpreter","Latex","fontsize",11);
ylabel("Mean BPM positions [m]", "Interpreter", "Latex", "fontsize", 15);
xlabel("BPM s-position [m]", "Interpreter", "Latex", "fontsize", 15);
legend(axs,"Original","Corrected","Interpreter","Latex","fontsize",...
        15,"Location","best");
title("BPM orbit - DFS correction","Fontsize",18,"Interpreter","Latex");
%saveas(gcf,"../Figures/DFS-orbits","jpg");


%% Plot emittance growth DFS quadrupole misalignment
setEnergy(1.0);
BPMMis = 0.001;
setBpmMisalignments(BPMMis,BPMMis);

n_points = 10;
misalign = linspace(0,2e-3,n_points);

resetKickers;
EmGrowthX0 = EmittanceGrowth(misalign,BPMMis,"none");
EmGrowthX_c = EmittanceGrowth(misalign,BPMMis,"dfs");

fig6 = figure();
plot(misalign,EmGrowthX_c,"Linestyle","--","Marker","o","linewidth",1.5);
hold on;
plot(misalign,EmGrowthX0,"Linestyle","-.","Marker","x","linewidth",1.5);
grid on;
axs = gca;
set(gca,"TickLabelInterpreter","Latex","fontsize",11);
ylabel("Relative emittance growth [$\%$]","Interpreter","Latex", "fontsize", 15);
xlabel("Quadrupole misalignment [m]","Interpreter","Latex", "fontsize", 15);
legend(axs,"DFS steer","Uncorrected","Interpreter","Latex",...
        "fontsize",15,"Location","best");
title("Emittance growth - DFS correction","Fontsize",18,...
        "Interpreter","Latex");
%saveas(gcf,"../Figures/growth_DFS","jpg");
%}

%% Plot emittance growth all BPM misalignment
resetKickers;
setEnergy(1.0);
setQuadStrength(1.4142);
setEnergySpread(0.01);
setEnergyOffset(0);
QuadMis = 0.001;
setQuadMisalignments(QuadMis,QuadMis);
runMADX;

BPMMis = linspace(0,0.01,10);

resetKickers;
EmGrowthX0 = EmittanceGrowth_BPM(QuadMis,BPMMis,"none");
EmGrowthX_1 = EmittanceGrowth_BPM(QuadMis,BPMMis,"1to1");
EmGrowthX_D = EmittanceGrowth_BPM(QuadMis,BPMMis,"dfs");

fig7 = figure();
plot(BPMMis,EmGrowthX0,"Linestyle","--","Marker","o","linewidth",1.5);
hold on;
plot(BPMMis,EmGrowthX_1,"Linestyle","-.","Marker","none","linewidth",1.5);
hold on;
plot(BPMMis,EmGrowthX_D,"Linestyle","--","Marker","x","linewidth",1.5);
grid on;
axs = gca;
set(gca,"TickLabelInterpreter","Latex","fontsize",11);
ylabel("Relative emittance growth [$\%$]","Interpreter","Latex", "fontsize", 15);
xlabel("BPM misalignment [m]","Interpreter","Latex", "fontsize", 15);
legend(axs,"Uncorrected","1-to-1","DFS","Interpreter",...
        "Latex","fontsize",15,"Location","best");
title("Emittance growth - BPM misalignments","Fontsize",18,...
        "Interpreter","Latex");
saveas(gcf,"../Figures/growth_all_BPM","jpg");


%-----------------------------
%% Functions:

% 1-to-1 steering
function [x,y,s] = OneToOne()

    [x0,y0,s] = getBPMreadings();
    [Rx, Ry] = getResponseMatrix(0.0);
    DthetaX = -pinv(Rx)*x0;
    DthetaY = -pinv(Ry)*y0;
    setKickers(DthetaX,DthetaY); 
    runMADX;

    [x,y] = getBPMreadings();
end

% RMS emittance
function [Ex, Ey] = emittance(BEAM)
    Covx = cov(BEAM(:,1), BEAM(:,2));
    Covy = cov(BEAM(:,3), BEAM(:,4));
    
    Ex = sqrt(det(Covx));
    Ey = sqrt(det(Covy));
    
end

% Emittance growth
function [EmGrowthX, EmGrowthY] = EmittanceGrowth(QuadMis,BPMMis,varargin)
    EmGrowthX = zeros(size(QuadMis));
    EmGrowthY = zeros(size(QuadMis));
    
    for i=1:length(QuadMis)
        
        kick = char(varargin{1});
        switch kick
            case "dfs"
                DFS(QuadMis(i), BPMMis);
        
            case "1to1"
                setQuadMisalignments(QuadMis(i),QuadMis(i));
                resetKickers;
                runMADX;
                OneToOne();
                
            case "none"
                setQuadMisalignments(QuadMis(i),QuadMis(i));
                resetKickers;
                runMADX;
        end     
   
        BEAM0 = getInitialBeam();
        BEAM1 = getFinalBeam();
   
        [ex0, ey0] = emittance(BEAM0);
        [ex1, ey1] = emittance(BEAM1);
   
        EmGrowthX(i) = (ex1-ex0)/ex0;
        EmGrowthY(i) = (ey1-ey0)/ey0; 
   
        clear ex0 ey0 ex1 ey1
    end
end

% DFS steering 
function [x,y,s] = DFS(QuadMis,BPMMis)
    % Get reference orbit 
    resetKickers;
    energy = 1.0;
    setEnergy(energy);
    setEnergySpread(0.01);
    setEnergyOffset(0.0);
    setQuadStrength(1.4142);
    setBpmMisalignments(BPMMis,BPMMis);
    setQuadMisalignments(QuadMis,QuadMis);
    runMADX;

    [x0, y0] = getBPMreadings();
    [Rx0, Ry0] = getResponseMatrix(0.0);

    % Get trajectories and response matrix for test beam
    setQuadStrength(1.3);
    runMADX;

    [x1, y1] = getBPMreadings();
    [Rx1, Ry1] = getResponseMatrix(0.0);

    setEnergy(1.0);
    setEnergyOffset(0.0);
    setQuadStrength(1.4142);
    % Set up kickers
    DthetaY = -pinv(Ry1-Ry0)*(y1-y0);
    DthetaX = -pinv(Rx1-Rx0)*(x1-x0);

    % Correct orbit
    setKickers(DthetaX,DthetaY);
    runMADX;

    [x, y, s] = getBPMreadings();
    
end

% Emittance growth BPM
function [EmGrowthX, EmGrowthY] = EmittanceGrowth_BPM(QuadMis,BPM,varargin)
    EmGrowthX = zeros(size(BPM));
    EmGrowthY = zeros(size(BPM));
    
    for i=1:length(BPM)
        
        kick = char(varargin{1});
        switch kick
            case "dfs"
                DFS(QuadMis,BPM(i));
        
            case "1to1"
                setBpmMisalignments(BPM(i),BPM(i));
                resetKickers;
                runMADX;
                OneToOne();
                
            case "none"
                setBpmMisalignments(BPM(i),BPM(i));
                resetKickers;
                runMADX;
        end     
   
        BEAM0 = getInitialBeam();
        BEAM1 = getFinalBeam();
   
        [ex0, ey0] = emittance(BEAM0);
        [ex1, ey1] = emittance(BEAM1);
   
        EmGrowthX(i) = (ex1-ex0)/ex0;
        EmGrowthY(i) = (ey1-ey0)/ey0; 
   
        clear ex0 ey0 ex1 ey1
    end
end