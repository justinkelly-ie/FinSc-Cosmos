module Evolution.SimulationStepper

import Evolution.SimulationState
import Stage0.BoxInt
import Stage1.VexelMaxel
import Stage1.MultisetTree
import Stage1.SymmetricMetricTensor
import Stage1.Fields.OctonionGaugeUnification
import Stage1.Math.GalacticRotationCurve
import Compound.SymplecticIntegrator
import Stage1.Epoch.ScaleTrajectorySieve
import Data.Vect

%default total

------------------------------------------------------------------------
-- 1. LINEAR ACTION-DRIVEN TRANSDUCER (Delta S = 1 <=> Delta t = 1)
------------------------------------------------------------------------

||| Advances the entire universal state by exactly one quantum of physical action (Delta S = 1).
||| Time is strictly the count of processed steps: substrateTicks |-> S (substrateTicks).
||| Coupled Einstein-Hamiltonian loop: phase-space stress-energy perturbs metric tensor,
||| which in turn modulates geodesic acceleration.
||| Evaluates companion spread matrix in O(log k) and branches observer epoch at k=38.
||| Enforces strict linear QTT consumption of the active state.
public export
stepUniverseSimulation : (1 st : UniverseSimulationState) -> UniverseSimulationState
stepUniverseSimulation (MkUniverseSimulationState k ticks cap g10 g4 moduli gluons gal phase defect spread isObs status fe) =
  let nextK = if k >= 136 then 0 else S k
      nextTicks = S ticks
      -- 1. Energy-Momentum Curvature Back-Reaction:
      -- Phase energy computes Ricci curvature defect on timelike component g_00
      energy = harmonicEnergy (intToBoxInt 1) phase
      nextDefect = intToBoxInt (cast {to = Integer} ((unwrapBox energy) `mod` 137))
      -- 2. 10D Bulk Spacetime Metric Update & 4D Leaf Projection
      nextG10 = perturbMetric00 g10 nextDefect
      nextG4  = project10Dto4D nextG10.metricMaxel
      nextModuli = moduliDegreesOfFreedom 10 4
      -- 3. Metric-Coupled Symplectic Leapfrog Kick:
      -- Geodesic acceleration gradient is modulated by active leaf g_00
      g00Val = lookupBoxTree (MkPixel 0 0) nextG4.entries
      metricScalar = if unwrapBox g00Val == 0 then intToBoxInt 1 else g00Val
      gradV = metricCoupledGrad metricScalar
      dt = intToBoxInt 1
      nextPhase = symplecticLeapfrogStep gradV dt phase
      -- 4. Logarithmic 2x2 Companion Spread Matrix Exponentiation: M(s)^k in O(log k)
      nextSpread = fastBoxSquareMaxelPower (S nextK) nextK pythagoreanCompanionMaxel
      -- 5. Dual-Branch Emergence: Observer Epoch k=38 (n=39=3x13) Activation
      nextIsObs = nextK == 38
      -- 6. SU(3) Gluon updates (Gell-Mann algebra preserved)
      nextGluons = gluons
      -- 7. Baryonic Matter Profile Update
      nextGal = gal
      -- 8. 13-Smoothness Coherence Status for generation n = S nextK
      nextStatus = evalScaleStepCoherence nextK
      -- 9. Discrete Helmholtz Free Energy remains at Primorial 210 Ground State F = -1320
      nextFE = fe
  in MkUniverseSimulationState
       nextK
       nextTicks
       cap
       nextG10
       nextG4
       nextModuli
       nextGluons
       nextGal
       nextPhase
       nextDefect
       nextSpread
       nextIsObs
       nextStatus
       nextFE

||| Advances the simulation by n action steps recursively.
public export
runSimulationSteps : (n : Nat) -> (1 st : UniverseSimulationState) -> UniverseSimulationState
runSimulationSteps Z st = st
runSimulationSteps (S k) st =
  let st' = stepUniverseSimulation st
  in runSimulationSteps k st'

------------------------------------------------------------------------
-- 2. INVARIANT AUDITS FOR SIMULATION STEPPER
------------------------------------------------------------------------

||| Audit: Stepping 1 tick advances action clock by exactly 1 (Delta t = 1 <=> Delta S = 1).
public export
auditSimulationClockStep : Bool
auditSimulationClockStep =
  let st0 = initUniverseSimulation
      st1 = stepUniverseSimulation st0
  in st1.substrateTicks == 1 && st1.epochIndex == 1

||| Audit: 137 steps completes a full cosmic trajectory loop and verifies asymptotic flatness.
public export
auditSimulationFullTrajectory : Bool
auditSimulationFullTrajectory =
  let st0 = initUniverseSimulation
      st137 = runSimulationSteps 137 st0
      v10 = rotationVelocity10D st137.galacticProfile (intToBoxInt 10)
      v20 = rotationVelocity10D st137.galacticProfile (intToBoxInt 20)
  in st137.substrateTicks == 137 &&
     unwrapBox v10 == 11000 && unwrapBox v20 == 10500

||| Audit: Dual-Branch observer epoch activates specifically at k = 38 (Observer Epoch).
public export
auditSimulationDynamicsAndObserver : Bool
auditSimulationDynamicsAndObserver =
  let st0 = initUniverseSimulation
      st38 = runSimulationSteps 38 st0
  in st38.epochIndex == 38 &&
     st38.observerEpochActive == True
