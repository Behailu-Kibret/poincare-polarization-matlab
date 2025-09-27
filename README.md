# Poincaré Polarization (MATLAB)

**Toolbox-free MATLAB toolkit for polarization analysis and Poincaré-sphere visualization.**

> Implements formulas from Advanced Engineering Electromagnetics (C. A. Balanis). Matches the book’s tau (τ) convention; handles linear and circular edge cases (τ = NaN for circular). No Mapping Toolbox or other add-ons required.

---

## Features
- **Calculator**: (|Ex|, ∠Ex, |Ey|, ∠Ey → γ, δ, ε, σ = 2ε, τ), axial ratio, type (Linear/Elliptical/Circular), and sense (IEEE, looking along +z).
- **Poincaré sphere plot**: solid sphere, x–y–z axes per Balanis, great-circle arcs 2τ (equator, +x→+y) and σ = 2ε (meridian); camera preset with +x vertical and observer looking along +z.
- **Ellipse plot (z=0 plane)**: draws the polarization ellipse with x plotted vertically (observer along +z) and time-direction arrows (CW/CCW).
- **Robust edge handling**: linear tolerance near ε≈0°; circular ⇒ τ = NaN; AR reported (∞ for linear).

---

## Functions
| Function | Purpose |
|---|---|
| `polarization_calculate_and_plot` | Single-entry wrapper: computes the polarization state from (\|Ex\|, ∠Ex, \|Ey\|, ∠Ey) and produces both plots. Returns `out`, the sphere figure handle `fig`, and the ellipse figure handle `fig1`. |
| `polarization_state_calculate` | Core calculator using Balanis (γ, δ) relations only (Eqs. 4-58…4-61). Outputs γ, δ, ε, σ = 2ε, τ (NaN if circular), AR, type, and sense (IEEE, +z). |
| `poincare_sphere_plot` | Solid Poincaré-sphere visualization with great-circle arcs 2τ and σ; +x is screen-up, view along +z; skips the 2τ arc for circular states. |
| `polarization_trace_plot` | Polarization ellipse on the x–y plane with x drawn vertically and arrows indicating rotation direction (IEEE sense for +z). |

---

## Quick start

```matlab
% One-call compute + both plots
[out, fig, fig1] = polarization_calculate_and_plot(1, 0, 0.6, 40);

% Compute only
out = polarization_state_calculate(1, 0, 1, 90);   % circular example → tau = NaN

% Plots (can be called independently)
fig  = poincare_sphere_plot(out);      % draws σ meridian; omits 2τ arc if circular
fig1 = polarization_trace_plot(out);   % ellipse with x vertical + direction arrows

% Adjust sphere transparency (0 = transparent, 1 = opaque)
% In poincare_sphere_plot: set 'FaceAlpha', e.g., 0.5
```

---

## Conventions and notes
- **Propagation**: along +z. IEEE sense (observer looking along +z):  
  RHCP = clockwise, LHCP = counter-clockwise on the ellipse plot (with x vertical).
- **Angles**:  
  γ = atan2(|Ey|, |Ex|), δ = ∠Ey − ∠Ex.  
  sin(2ε) = sin(2γ) sin δ.  
  τ (degrees); τ is undefined (NaN) for circular.
- **Linear / Circular**: linear if |ε| ≲ 1°; circular ⇒ τ = NaN.
- **Axial ratio**: AR = 1/|tan ε| (∞ for linear).

---

## Requirements
- MATLAB R2014b or newer recommended (graphics object syntax).  
- No additional toolboxes required.

---

## Reference
C. A. Balanis, Advanced Engineering Electromagnetics — polarization and Poincaré-sphere relations (γ–δ ↔ ε–τ).

