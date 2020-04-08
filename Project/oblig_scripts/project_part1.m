clear all;
%clf;

% Set working folder
cd C:\Users\krisl\.Matlab\FYS4565\Project\oblig_scripts\

% Add to path getters and setters
addpath("get", "set");

n = 2e4;
setParticleNumber(n);

% Run MAD-X
resetKickers;
energy = 1.0;
setEnergy(energy);
setEnergySpread(0.01);
setBpmMisalignments(0.0, 0.0);
setQuadMisalignments(0,0);

runMADX;

%% Importing beam in workspace
% get initial beam 
BEAM = getInitialBeam();
mass = 0.511e-3; % GeV

energy = getEnergy();
beta = 1.0;
gamma = energy/mass;
%fprintf("Initial beam:\n")
%fprintf("%d %d %d %d %d %d \n", BEAM(1:3,:))


%% Calculating RMS emittance
% geometric
[Ex, Ey] = emittance(BEAM);

fprintf("\n============================\n")
fprintf("Geometric emittance: \n")
fprintf("Ex = %d\nEy = %d\n",Ex,Ey)

% normalized

fprintf("----------------------------\n")
fprintf("Normalized emittance: \n")
fprintf("Ex_norm = %d\nEy_norm = %d\n",beta*gamma*Ex,beta*gamma*Ey)
fprintf("============================\n")


%% Calculating Twiss parameters
[beta_x, beta_y, alpha_x, alpha_y] = twiss(BEAM);

fprintf("\n============================\n")
fprintf("TWISS parameters: \n")
fprintf("alpha_x = %d, beta_x=%d\nalpha_y = %d, beta_y=%d\n",alpha_x,...
        beta_x,alpha_y,beta_y)


%% Plot beam orbit   
[xs, ys, ss] = getBPMreadings();
    
fig1 = figure();
plot(ss, xs, "Linestyle", "--", "Marker", "o", "Linewidth", 1);
hold on;
grid on;
plot(ss, ys, "Linestyle", "-.", "Marker", "x", "Linewidth", 1);
axs = gca;
set(gcs, "TickLabelInterpreter", "Latex", "fontsize", 11);
ylabel("Mean BPM positions [m]", "Interpreter", "Latex", "fontsize", 15);
xlabel("BPM s-position [s]", "Interpreter", "Latex", "fontsize", 15);
legend(axs, "$x$ orbit", "$y$ orbit", "Interpreter", "Latex",... 
        "fontsize", 15, "Location", "best");
title("BPM orbit", "Fontsize", 18, "Interpreter", "Latex");
%saveas(gcf,"../Figures/orbit","jpg");


%% Introduce quadrupole misalignments
setEnergy(energy);
setQuadMisalignments(0.001, 0.001);
runMADX;

% Plot new orbits
[xs, ys, ss] = getBPMreadings();
    
fig2 = figure();
plot(ss, xs, "Linestyle", "--", "Marker", "o", "Linewidth", 1);
hold on;
grid on;
plot(ss, ys, "Linestyle", "-.", "Marker", "x", "Linewidth", 1);
axs = gca;
set(gcs, "TickLabelInterpreter", "Latex", "fontsize", 11);
ylabel("Mean BPM positions [m]", "Interpreter", "Latex", "fontsize", 15);
xlabel("BPM s-position [s]", "Interpreter", "Latex", "fontsize", 15);
legend(axs, "$x$ orbit", "$y$ orbit", "Interpreter", "Latex",... 
        "fontsize", 15, "Location", "best");
title("BPM orbit - misalignment", "Fontsize", 18, "Interpreter", "Latex");
%saveas(gcf,"../Figures/orbit_mis","jpg");


%% Dispersion function
% Generate beam with different energies
energy = 1.0;
setEnergy(energy);
setQuadMisalignments(0.001, 0.001);
setEnergyOffset(0.0);
runMADX;

[x0, y0, s0] = getBPMreadings();
P0 = sqrt(energy^2+mass^2);

new_energy = 1.05;
setEnergyOffset(new_energy-energy);
runMADX;

[x1, y1, s]= getBPMreadings();
P1 = sqrt(new_energy^2 + mass^2);

dP = P1-P0;
Disp_x = (x1-x0)*P0/dP;
Disp_y = (y1-y0)*P0/dP;

% plot dispersion function
fig3 = figure();
plot(s,Disp_x,"Linestyle","--","Marker","none","linewidth",1.5)
hold on
plot(s,Disp_y,"Linestyle","-.","Marker","none","linewidth",1.5);
grid on
axs = gca;
set(gca,"TickLabelInterpreter","Latex","fontsize",11);
ylabel("Dispersion [m]","Interpreter","Latex", "fontsize", 15);
xlabel("BPM s-position [m]", "Interpreter", "Latex", "fontsize", 15);
legend(axs,"$D_x$","$D_y$","Interpreter","Latex","fontsize",15,...
        "Location","best");
title("Dispersion function","Fontsize",18,"Interpreter","Latex");
%saveas(gcf,"../Figures/dispersion","jpg");


%% Emittance growth
n = 10;
setEnergy(1.0);
setEnergySpread(0);
setEnergyOffset(0.01);
misalign = linspace(0, 2e-3, n);

[EmGrowthX, EmGrowthY] = EmittanceGrowth(misalign);

fig4 = figure();
plot(misalign,EmGrowthX,"Linestyle","--","Marker","o","linewidth",1)
hold on
plot(misalign,EmGrowthY,"Linestyle","-.","Marker","x","linewidth",1);
grid on
axs = gca;
set(gca,"TickLabelInterpreter","Latex","fontsize",11);
ylabel("Relative emittance growth [$\%$]","Interpreter","Latex", "fontsize", 15);
xlabel("Quadrupole misalignment [m]","Interpreter","Latex", "fontsize", 15);
legend(axs,"$\Delta\varepsilon_x/\varepsilon_x$",...
        "$\Delta\varepsilon_y/\varepsilon_y$","Interpreter","Latex",...
        "fontsize",15,"Location","best");
title("Emittance growth","Fontsize",18,"Interpreter","Latex");
%saveas(gcf,"../Figures/growth","jpg");


%% Emittance growth with energy spread
n = 10;
setEnergy(1.0);
setEnergySpread(0.01);
misalign = linspace(0,2e-3,n);

[EmGrowthX, EmGrowthY] = EmittanceGrowth(misalign);

fig5 = figure();
plot(misalign,EmGrowthX,"Linestyle","--","Marker","o","linewidth",1)
hold on
plot(misalign,EmGrowthY,"Linestyle","-.","Marker","x","linewidth",1);
grid on
axs = gca;
set(gca,"TickLabelInterpreter","Latex","fontsize",11);
ylabel("Relative emittance growth [$\%$]","Interpreter","Latex", "fontsize", 15);
xlabel("Quadrupole misalignment [m]","Interpreter","Latex", "fontsize", 15);
legend(axs,"$\Delta\varepsilon_x/\varepsilon_x$",...
        "$\Delta\varepsilon_y/\varepsilon_y$","Interpreter","Latex",...
        "fontsize",15,"Location","best");
title("Emittance growth - $\Delta E/E=0.01$","Fontsize",18,...
        "Interpreter","Latex");
%saveas(gcf,"../Figures/growth_spread","jpg");


%% Change quad strength
n = 8;
setEnergy(1.0);
setEnergySpread(0.01);
misalign = linspace(0,2e-3,n);
k = [0.8, 1.0, 1.2];

fig6 = figure();

for i=1:length(k)
    setQuadStrength(k(i));
    
    [EmGrowthX, EmGrowthY] = EmittanceGrowth(misalign);
    
    plot(misalign,EmGrowthX,'Linestyle','--','Marker','x','linewidth',1.5)
    hold on
    plot(misalign,EmGrowthY,'Linestyle','-.','Marker','none','linewidth',1.5)
end

grid on
axs = gca;
set(gca, "TickLabelInterpreter", "Latex", "fontsize", 11);
ylabel("Relative emittance growth [$\%$]","Interpreter","Latex", "fontsize", 15);
xlabel("Quadrupole misalignment [m]","Interpreter","Latex", "fontsize", 15);
legend(axs,"$k_x=$"+string(k(1)),"$k_y=$"+string(k(1)),...
        "$k_x=$"+string(k(2)),"$k_y=$"+string(k(2)),...
        "$k_x=$"+string(k(3)),"$k_y=$"+string(k(3)),...
        "Interpreter","Latex","fontsize",15,"Location","best");
title(["Emittance growth -", "change quad strength k"],"Fontsize",18,...
        "Interpreter","Latex");
%saveas(gcf,"../Figures/growth_spread_k","jpg");


%-----------------------------
%% Functions:

% RMS emittance
function [Ex, Ey] = emittance(BEAM)
    Covx = cov(BEAM(:,1), BEAM(:,2));
    Covy = cov(BEAM(:,3), BEAM(:,4));
    
    Ex = sqrt(det(Covx));
    Ey = sqrt(det(Covy));
    
end
    
% Twiss parameters
function [beta_x, beta_y, alpha_x, alpha_y] = twiss(BEAM)
    Covx = cov(BEAM(:,1), BEAM(:,2));
    Covy = cov(BEAM(:,3), BEAM(:,4));
    
    Ex = sqrt(det(Covx));
    Ey = sqrt(det(Covy));
    
    M_x = Covx/Ex;
    M_y = Covy/Ey;
    
    beta_x = M_x(1,1);
    alpha_x = -M_x(1,2);
    
    beta_y = M_y(1,1);
    alpha_y = -M_y(1,2);
    
end

% Emittance growth
function [EmGrowthX, EmGrowthY] = EmittanceGrowth(misalign)
    EmGrowthX = zeros(size(misalign));
    EmGrowthY = zeros(size(misalign));
    
    for i=1:length(misalign)
        setQuadMisalignments(misalign(i),misalign(i));
        resetKickers;
        runMADX;    
   
        Beam0 = getInitialBeam();
        Beam1 = getFinalBeam();
   
        [ex0, ey0] = emittance(Beam0);
        [ex1, ey1] = emittance(Beam1);
   
        EmGrowthX(i) = (ex1-ex0)/ex0;
        EmGrowthY(i) = (ey1-ey0)/ey0; 
   
        clear ex0 ey0 ex1 ey1
    end
end