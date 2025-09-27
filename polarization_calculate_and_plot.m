function [out, fig, fig1] = polarization_calculate_and_plot(Ex_mag, Ex_ang_deg, Ey_mag, Ey_ang_deg)
% Compute Polarization state params (γ, δ, τ, and ε) of a plane wave traveloing laong =z direction.
% The params are calculated based on the equation 4-58 to 4-61 in Balanis, Advanced Engineering Electromganetics, Second Edition
% It also plots Poincaré shere and the polarization trace based on the computed params.
% Inputs are phasor magnitudes and angles (deg).

     if nargin < 4
        Ex_mag     = input('Enter |Ex| amplitude: ');
        Ex_ang_deg = input('Enter ∠Ex (deg): ');
        Ey_mag     = input('Enter |Ey| amplitude: ');
        Ey_ang_deg = input('Enter ∠Ey (deg): ');
    end
    if Ex_mag==0 && Ey_mag==0, error('Both |Ex| and |Ey| are zero.'); end

    out = polarization_state_calculate(Ex_mag, Ex_ang_deg, Ey_mag, Ey_ang_deg);
    fig = poincare_sphere_plot(out);
    fig1 = polarization_trace_plot(out);
end
