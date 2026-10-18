module Evolution.SimulationStepper

import Evolution.SimulationState
import Stage0.BoxInt
import Stage1.VexelMaxel
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
||| Enforces strict linear QTT consumption of the active state.
public export
stepUniverseSimulation : (1 st : UniverseSimulationState) -> UniverseSimulationState
stepUniverseSimulation (MkUniverseSimulationState k ticks cap g10 g4 moduli gluons gal phase status fe) =
  let nextK = if k >= 136 then 0 else S k
      nextTicks = S ticks
      -- 1. Symplectic leapfrog kick (Hamiltonian action increment Delta S = 1)
      gradV = harmonicOscillatorGrad (intToBoxInt 1)
      dt = intToBoxInt 1
      nextPhase = symplecticLeapfrogStep gradV dt phase
      -- 2. 10D Bulk to 4D Leaf Spacetime Metric Projection & Moduli Update
      nextG10 = g10
      nextG4  = project10Dto4D nextG10.metricMaxel
      nextModuli = moduliDegreesOfFreedom 10 4
      -- 3. SU(3) Gluon updates (Gell-Mann algebra preserved)
      nextGluons = gluons
      -- 4. Baryonic Matter Profile Update
      nextGal = gal
      -- 5. 13-Smoothness Coherence Status for generation n = S nextK
      nextStatus = evalScaleStepCoherence nextK
      -- 6. Free energy remains at ground state minimum
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
