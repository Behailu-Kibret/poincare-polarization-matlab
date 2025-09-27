function fig = polarization_trace_plot(out, scale, n_arrows)
% Plot polarization ellipse in the x–y plane (z=0) with +x drawn vertically
% (observer looking along +z), and arrows indicating rotation direction.
%
% INPUTS:
%   out      : struct from poincare_balanis_gd
%   scale    : optional overall scale (default 1)
%   n_arrows : optional number of arrows along the locus (default 16)

    if nargin < 2 || isempty(scale),    scale = 1;  end
    if nargin < 3 || isempty(n_arrows), n_arrows = 16; end

    % Reconstruct normalized phasors from (γ, δ)
    gamma = deg2rad(out.gamma_deg);
    delta = deg2rad(out.delta_deg);
    Ex = scale * cos(gamma);
    Ey = scale * sin(gamma);
    phix = 0;                 % reference phase for Ex
    phiy = delta;             % Ey phase relative to Ex

    % Time-locus
    t  = linspace(0, 2*pi, 1000);
    Ex_t = Ex * cos(t + phix);
    Ey_t = Ey * cos(t + phiy);

    % --- Plot with x vertical: horizontal axis = Ey, vertical axis = Ex
    fig = figure('Color','w'); hold on; axis equal;
    plot(Ey_t, Ex_t, 'k-', 'LineWidth', 1.6);   % (Ey, Ex)

    % Axes lines
    xl = [min(Ey_t) max(Ey_t)]; yl = [min(Ex_t) max(Ex_t)];
    plot(xl, [0 0], 'k:');  % Ey-axis horizontal zero for Ex
    plot([0 0], yl, 'k:');  % Ex-axis vertical zero for Ey

    % Direction arrows (use quiver on sampled points along t)
    idx = round(linspace(1, numel(t)-1, n_arrows));
    % Derivatives wrt time
    dEx = -Ex * sin(t + phix);
    dEy = -Ey * sin(t + phiy);
    % Map to screen coords (u,v) = (dEy, dEx)
    U = dEy(idx); V = dEx(idx);
    % Normalize arrow length for aesthetics
    L = sqrt(U.^2 + V.^2) + eps;
    U = 0.15*scale * U ./ L;   % tune 0.15 if you want longer/shorter arrows
    V = 0.15*scale * V ./ L;
    quiver(Ey_t(idx), Ex_t(idx), U, V, 0, 'Color',[0.1 0.3 0.85], 'LineWidth',1.1, 'MaxHeadSize',2);

    % Major/minor axes (skip if circular)
    tol = deg2rad(1);
    eps_r = deg2rad(out.epsilon_deg);
    isCircular = abs(abs(eps_r) - pi/4) <= tol;

    % Semi-axes lengths and tilt about +x (geometric, not Poincaré τ)
    A = Ex^2; B = Ey^2; c = cos(delta);
    root = sqrt((A - B)^2 + 4*A*B*c^2);
    a = sqrt(0.5*(A + B + root));
    b = sqrt(0.5*(A + B - root));
    two_tau_x = atan2( 2*Ex*Ey*cos(delta), (Ex^2 - Ey^2) );
    tau_x = 0.5*two_tau_x; if tau_x < 0, tau_x = tau_x + pi; end

    if ~isCircular
        % Unit vectors of major/minor axes in (Ey,Ex) plotting coords
        % Geometry is defined in the (Ex, Ey) frame; when plotting (Ey,Ex), swap components.
        ux = [ sin(tau_x);  cos(tau_x) ];  % major axis as (Ey,Ex)
        vx = [ -cos(tau_x);  sin(tau_x) ]; % minor axis as (Ey,Ex)
        plot(a*[-ux(1) ux(1)], a*[-ux(2) ux(2)], 'Color',[0.1 0.3 0.85], 'LineWidth', 2.0);
        plot(b*[-vx(1) vx(1)], b*[-vx(2) vx(2)], 'Color',[0.85 0.2 0.2],  'LineWidth', 2.0);
    else
        % Circle center marker
        plot(0,0,'o','MarkerFaceColor',[0.2 0.7 0.9],'MarkerEdgeColor','k','MarkerSize',5);
    end

    grid on; box on;
    xlabel('E_y (horizontal)'); ylabel('E_x (vertical)');
    title('Polarization ellipse at z=0 (observer looking along +z; +x is up)');

    % Small legend text
    if ~isCircular
        txt = sprintf('a=%.3g, b=%.3g,  \\tau_x=%.2f^\\circ,  \\epsilon=%.2f^\\circ  (%s, %s)', ...
                      a, b, rad2deg(tau_x), out.epsilon_deg, out.polarization, out.sense);
    else
        txt = sprintf('Circle (|\\epsilon|=45^\\circ)  (%s, %s)', out.polarization, out.sense);
    end
    text(0.02, 0.98, txt, 'Units','normalized','VerticalAlignment','top');
end
