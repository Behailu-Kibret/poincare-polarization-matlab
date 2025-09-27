function out = polarization_state_calculate(Ex_mag, Ex_ang_deg, Ey_mag, Ey_ang_deg)
% Polarization state params (γ, δ, τ, and ε) are calculated based on the equation 4-58 to 4-61 in 
% Balanis, Advanced Engineering Electromganetics, Second Edition
% τ is computed via Eq. (4-61b),
% BUT τ is undefined (NaN) for circular polarization.


    % ---- (γ, δ) per Balanis (4-58a,b) ----
    gamma = atan2(Ey_mag, Ex_mag);                        % 0..π/2
    delta = deg2rad( wrapTo180deg(Ey_ang_deg - Ex_ang_deg) ); % −π..π

    % ---- ε via (4-61a): sin(2ε) = sin(2γ) sin δ ----
    sin2e   = sin(2*gamma) * sin(delta);
    sin2e   = max(min(sin2e,1),-1);     % numeric guard
    epsilon = 0.5 * asin(sin2e);        % ε in [−45°, +45°]
    sigma   = 2*epsilon;

    % ---- circular / linear tolerance ----
    tol = deg2rad(1);                        % ~1°
    isCircular = abs(abs(epsilon) - pi/4) <= tol;
    isLinear   = abs(epsilon) <= tol;

    % ---- τ via (4-61b) (Balanis executable convention), unless circular ----
    if isCircular
        tau = NaN;                       % undefined for circular polarization
    else
        % tan(2τ) = tan(2γ) cos δ  ⇒ 2τ = atan2( -sin(2γ)cosδ, cos(2γ) )
        two_tau = atan2( -sin(2*gamma) * cos(delta), cos(2*gamma) );
        tau     = 0.5 * two_tau;        % (−π/2, π/2]
        if tau < 0, tau = tau + pi; end % map to [0, π)
    end

    % ---- Axial ratio (AR ≥ 1) and sense ----
    t = tan(epsilon);
    if abs(t) < 1e-12
        AR = Inf; AR_dB = Inf;
    else
        AR = 1/t;                   % ensure AR ≥ 1
        AR_dB = 20*log10(abs(AR));
    end

    % Sense (IEEE, looking along +z): sign of sin(2γ) sin δ
    s3sign = sin(2*gamma)*sin(delta);
    if isLinear
        polType = 'Linear';   sense = 'N/A (linear)';
    elseif isCircular
        polType = 'Circular'; sense = ternary(s3sign < 0, 'RHCP (IEEE, +z)', 'LHCP (IEEE, +z)');
    else
        polType = 'Elliptical'; sense = ternary(s3sign < 0, 'RHCP (IEEE, +z)', 'LHCP (IEEE, +z)');
    end

    % ---- Output ----
    out = struct( ...
        'gamma_deg',   rad2deg(gamma), ...
        'delta_deg',   rad2deg(delta), ...
        'epsilon_deg', rad2deg(epsilon), ...
        'sigma_deg',   rad2deg(sigma), ...
        'tau_deg',     rad2deg(tau), ...        % NaN if circular
        'axial_ratio', AR, 'axial_ratio_dB', AR_dB, ...
        'polarization', polType, 'sense', sense, ...
        'is_circular', isCircular, 'is_linear', isLinear );

    % ---- Pretty print ----
    fprintf('\n=== Poincaré (Balanis γ,δ-based) ===\n');
    fprintf('(γ,δ) = (%.3f°, %.3f°)\n', out.gamma_deg, out.delta_deg);
    fprintf('ε = %.3f°   σ = 2ε = %.3f°\n', out.epsilon_deg, out.sigma_deg);
    if isnan(out.tau_deg)
        fprintf('τ = NaN (undefined for circular)\n');
    else
        fprintf('τ (Balanis executable) = %.3f°\n', out.tau_deg);
    end
    if isinf(AR), fprintf('AR = ∞ (linear)\n'); else, fprintf('AR = %.6g  (%.2f dB)\n', AR, AR_dB); end
    fprintf('Type: %s | Sense: %s\n\n', polType, sense);
end

% ---- helpers (toolbox-free) ----
function a = wrapTo180deg(a), a = mod(a+180,360)-180; end
function y = ternary(c,a,b), if c, y=a; else, y=b; end, end
