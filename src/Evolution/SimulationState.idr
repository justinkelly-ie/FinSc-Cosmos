module Evolution.SimulationState

import Stage0.BoxInt
import Stage1.MultisetTree
import Stage1.SymmetricMetricTensor
import Stage1.Fields.OctonionGaugeUnification
import Stage1.Math.GalacticRotationCurve
import Compound.SymplecticIntegrator
import Stage1.Epoch.ScaleTrajectorySieve
import Stage1.Epoch.ObserverPredictions
import Stage1.FourGeometries
import Data.Vect

%default total

------------------------------------------------------------------------
-- 1. DISCRETE CAPACITY BUDGET PARTITION (27 + 128 + 55 = 210)
------------------------------------------------------------------------

||| Formal Primorial 210 capacity partition:
||| vm = 27 (Elliptic), de = 128 (Hyperbolic), dm = 55 (Parabolic).
public export
record DiscreteCapacityBudget (vm : Nat) (de : Nat) (dm : Nat) where
  constructor MkDiscreteCapacityBudget
  0 budgetPrf : vm + de + dm = 210

public export
canonicalCapacityBudget : DiscreteCapacityBudget 27 128 55
canonicalCapacityBudget = MkDiscreteCapacityBudget Refl

------------------------------------------------------------------------
-- 2. DISCRETE HELMHOLTZ FREE ENERGY STATE (F = U - TS)
------------------------------------------------------------------------

||| Discrete thermodynamic Helmholtz Free Energy state.
||| Ground state uniquely minimizes at F = -1320 (398 - 2 * 859).
public export
record DiscreteHelmholtzState (vm : Nat) (de : Nat) (dm : Nat) (temp : Nat) where
  constructor MkDiscreteHelmholtzState
  internalEnergy : BoxInt
  entropy        : BoxInt
  freeEnergy     : BoxInt
  0 freeEnergyPrf: freeEnergy = internalEnergy - (intToBoxInt (cast temp) * entropy)

public export
canonicalHelmholtzGroundState : DiscreteHelmholtzState 27 128 55 2
canonicalHelmholtzGroundState =
  MkDiscreteHelmholtzState (intToBoxInt 398) (intToBoxInt 859) (intToBoxInt (-1320)) Refl

------------------------------------------------------------------------
-- 3. UNIFIED UNIVERSE SIMULATION STATE (Rule 03 §5)
------------------------------------------------------------------------

||| Complete constructivist simulation state tracking the universal evolution:
||| - Relational Clock: time is exactly the accumulated action quanta (substrateTicks: Delta S = 1).
||| - Geometry & Bulk: 10D SymmetricMetricTensor (55 components), projected to 4D leaf (10 components).
||| - Uncompactified Moduli: 45 moduli driving dark matter rotation curves.
||| - Gauge Symmetry: 8 discrete Gell-Mann matrices of SU(3) subset G_2.
||| - Matter & Dynamics: PhaseState (q, p) symplectic carrier.
||| - Curvature Back-Reaction: active G_00 defect perturbing spacetime.
||| - Rational Trig: 2x2 companion spread matrix M(s)^k in O(log k).
||| - Observer Branch: active inference & biomolecules at k=38 (Observer Epoch).
||| - Thermodynamics: canonical 137-scale sieve & Helmholtz free energy.
public export
record UniverseSimulationState where
  constructor MkUniverseSimulationState
  epochIndex          : Nat                                    -- Trajectory scale step k (0 to 136)
  substrateTicks      : Nat                                    -- Action count Delta S = total ticks elapsed
  capacityBudget      : DiscreteCapacityBudget 27 128 55       -- 210 Master partition
  metricTensor        : SymmetricMetricTensor 10               -- 10D Spacetime bulk metric (55 DoF)
  projectedLeaf       : BoxSquareMaxel 4                       -- 4D Spacetime projected leaf (10 DoF)
  moduliDOF           : Nat                                    -- 45 uncompactified Dark Matter moduli
  gellMannGluons      : Vect 8 (BoxSquareMaxel 3)              -- SU(3) subset G_2 gauge fields
  galacticProfile     : GalacticProfile                        -- Active baryonic core & disk slope
  phaseState          : PhaseState                             -- Symplectic (q, p) phase space
  curvatureDefect     : BoxInt                                 -- Active G_00 energy-momentum defect
  spreadMatrix        : BoxSquareMaxel 2                       -- Companion spread transfer matrix M(s)^k
  observerEpochActive : Bool                                   -- True specifically at k=38 (Observer Epoch)
  coherenceStatus     : CoherenceStatus CosmicSmoothHorizon (S epochIndex) -- 13-smoothness status
  freeEnergyState     : DiscreteHelmholtzState 27 128 55 2     -- Discrete F = U - TS

||| Canonical 2x2 companion spread transfer matrix for multiple spread recurrence:
||| M(s) = [[2 - 4s, -1], [1, 0]]. For s = 0, [[2, -1], [1, 0]].
public export
pythagoreanCompanionMaxel : BoxSquareMaxel 2
pythagoreanCompanionMaxel =
  let c11 = intToBoxInt 2
      c12 = intToBoxInt (-1)
      c21 = intToBoxInt 1
      t0 = singletonCell (mkCell2 0 0) c11
      t1 = setBoxTree (mkCell2 0 1) c12 t0
      t2 = setBoxTree (mkCell2 1 0) c21 t1
  in MkSquareMaxel t2

||| Genesis / Vacuum Initial Universe Simulation State (Epoch k = 0, Delta S = 0).
public export
initUniverseSimulation : UniverseSimulationState
initUniverseSimulation =
  let g10 = spacetime10DMetric
      g4  = project10Dto4D g10.metricMaxel
      gluons = [ gellMannMaxel 1, gellMannMaxel 2, gellMannMaxel 3, gellMannMaxel 4
               , gellMannMaxel 5, gellMannMaxel 6, gellMannMaxel 7, gellMannMaxel 8
               ]
      gal = MkGalacticProfile (intToBoxInt 100) (intToBoxInt 0)
      q0 = singletonCell (mkCell1 1) (intToBoxInt 1)
      p0 = singletonCell (mkCell1 1) (intToBoxInt 0)
      phase0 = MkPhaseState q0 p0
      status0 = evalScaleStepCoherence Z
  in MkUniverseSimulationState
       0
       0
       canonicalCapacityBudget
       g10
       g4
       45
       gluons
       gal
       phase0
       (intToBoxInt 0)
       (identityBoxSquareMaxel 2)
       False
       status0
       canonicalHelmholtzGroundState
