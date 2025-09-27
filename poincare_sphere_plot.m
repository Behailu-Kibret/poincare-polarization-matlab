function fig = poincare_sphere_plot(out)
% Solid Poincaré sphere with x,y,z axes (Balanis), great-circle arcs for
% 2τ (equator from +x → +y) and σ=2ε (meridian). Handles circular states.

    % --- Angles (rad)
    sig_r = deg2rad(out.sigma_deg);          % σ = 2ε
    isCircular = isfield(out,'is_circular') && out.is_circular;

    % --- Longitude φB consistent with τ convention
    if ~isnan(out.tau_deg)
        phiB = deg2rad(2*out.tau_deg);       % *** use τ directly ***
        if phiB < 0, phiB = phiB + 2*pi; end
    else
        % Circular: longitude undefined. Pick an arbitrary meridian for σ arc.
        phiB = 0;
    end

    % --- Point on sphere from (σ, φB)
    x = cos(sig_r).*cos(phiB);
    y = cos(sig_r).*sin(phiB);
    z = sin(sig_r);

    % --- Figure & solid sphere
    fig = figure('Color','w'); hold on; axis equal off;
    view([1 1 1]); camtarget([0 0 0]); camup([0 0 1]); axis vis3d;
    [Xs,Ys,Zs] = sphere(200);
    Sface = surf(Xs, Ys, Zs, 'FaceColor',[0.90 0.94 1.00], ...
                           'EdgeColor','none', 'FaceAlpha', 0.5); %#ok<NASGU>
    lighting gouraud; camlight headlight; material dull;

    % Reference great circles (thin)
    t = linspace(0,2*pi,400);
    plot3(cos(t), sin(t), 0*t, 'k-', 'LineWidth', 0.6, 'Color', [0.6 0.6 0.65]); % equator
    plot3(cos(t), 0*t, sin(t), 'k-', 'LineWidth', 0.6, 'Color', [0.6 0.6 0.65]); % xz-plane
    plot3(0*t, cos(t), sin(t), 'k-', 'LineWidth', 0.6, 'Color', [0.6 0.6 0.65]); % yz-plane

    % Axes (x,y,z)
    axLw = 1.1;
    plot3([-1 1],[0 0],[0 0],'k-','LineWidth',axLw);
    plot3([0 0],[-1 1],[0 0],'k-','LineWidth',axLw);
    plot3([0 0],[0 0],[-1 1],'k-','LineWidth',axLw);
    text(1.08,0,0,'x','FontSize',11,'FontWeight','bold');
    text(0,1.08,0,'y','FontSize',11,'FontWeight','bold');
    text(0,0,1.08,'z','FontSize',11,'FontWeight','bold');

    % --- Great-circle arcs ---
    % Equator arc: +x → φB (skip if circular/τ undefined)
    if ~isCircular && isfinite(out.tau_deg)
        phi = linspace(0, phiB, 300);
        xe = cos(phi);  ye = sin(phi);  ze = zeros(size(phi));
        plot3(xe, ye, ze, 'LineWidth', 2.2, 'Color', [0.10 0.30 0.85]);
        midp = max(1, floor(numel(phi)/2));
        text(xe(midp), ye(midp), 0.02, sprintf('2\\tau = %.1f^\\circ', 2*out.tau_deg), ...
             'FontSize',10,'FontWeight','bold','HorizontalAlignment','center');
    end

    % Meridian arc: constant φB from equator to σ
    lam = linspace(0, sig_r, 200);
    xm  = cos(lam).*cos(phiB);
    ym  = cos(lam).*sin(phiB);
    zm  = sin(lam);
    plot3(xm, ym, zm, 'LineWidth', 2.2, 'Color', [0.85 0.20 0.20]);
    midm = max(1, floor(numel(lam)/2));
    text(xm(midm), ym(midm), zm(midm), sprintf('\\sigma = 2\\epsilon = %.1f^\\circ', out.sigma_deg), ...
         'FontSize',10,'FontWeight','bold','HorizontalAlignment','left','VerticalAlignment','bottom');

    % Radius & marker
    plot3([0 x],[0 y],[0 z], '-', 'LineWidth',1.4,'Color',[0.25 0.25 0.30]);
    plot3(x, y, z, 'o', 'MarkerSize', 8, 'MarkerFaceColor',[0.1 0.5 0.95], 'MarkerEdgeColor','k');

    % +x reference mark
    plot3(1,0,0,'s','MarkerSize',6,'MarkerFaceColor',[0.2 0.8 0.4],'MarkerEdgeColor','k');

    % Title
    ttl = sprintf('Poincaré sphere  |  x=%.3f, y=%.3f, z=%.3f  |  %s, %s', ...
                  x, y, z, out.polarization, out.sense);
    title(ttl, 'FontWeight','bold');

    axis([-1 1 -1 1 -1 1]); daspect([1 1 1]); rotate3d on; grid on; box on;
end