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
import Stage1.Carrier.ChromogeometricMetric
import Stage1.Carrier.SquareMaxel
import Stage0.Biology.ActiveInferenceNeuralNetwork
import Stage1.Thermodynamics.EntropicArrow
import Data.Vect

%default total

------------------------------------------------------------------------
-- 1. DISCRETE CAPACITY BUDGET PARTITION (27 + 128 + 55 = 210)
------------------------------------------------------------------------

||| Formal Primorial 210 capacity partition:
||| vm = 27 (Elliptic), de = 128 (Hyperbolic), dm = 55 (Parabolic).
||| Formal Primorial 210 capacity partition across all 4 geometries:
||| vm = 27 (Elliptic), de = 128 (Hyperbolic), dm = 55 (Parabolic), sub = 210 (Master Substrate).
public export
record DiscreteQuadCapacityBudget (vm : Nat) (de : Nat) (dm : Nat) (sub : Nat) where
  constructor MkDiscreteQuadCapacityBudget
  0 budgetPrf : vm + de + dm = 210
  0 masterPrf : sub = 210

public export
Eq (DiscreteQuadCapacityBudget vm de dm sub) where
  _ == _ = True

public export
canonicalQuadCapacityBudget : DiscreteQuadCapacityBudget 27 128 55 210
canonicalQuadCapacityBudget = MkDiscreteQuadCapacityBudget Refl Refl

public export
DiscreteCapacityBudget : (vm : Nat) -> (de : Nat) -> (dm : Nat) -> Type
DiscreteCapacityBudget vm de dm = DiscreteQuadCapacityBudget vm de dm 210

public export
canonicalCapacityBudget : DiscreteCapacityBudget 27 128 55
canonicalCapacityBudget = canonicalQuadCapacityBudget

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
-- 2B. OBSERVER LIVING-MATTER ACTIVE INFERENCE STATE (Rule 03 §5)
------------------------------------------------------------------------

||| Observer branch lifecycle: dormant during cosmic trunk, living at k=38.
public export
data ObserverBranchState : Type where
  DormantObserver : ObserverBranchState
  LivingObserver  : ObserverLivingState -> ObserverBranchState

public export
Eq ObserverBranchState where
  DormantObserver == DormantObserver = True
  (LivingObserver l1) == (LivingObserver l2) = l1 == l2
  _ == _ = False

public export
Show ObserverBranchState where
  show DormantObserver = "DormantObserver"
  show (LivingObserver liv) = show liv

------------------------------------------------------------------------
-- 2C. COSMIC EXPANSION PARADIGM (Rule 03)
------------------------------------------------------------------------

||| The two constructivist cosmic expansion paradigms governed by the Substrate Metric:
||| - MonotonicOpenExpansion: Irreversible forward arrow Delta S >= 1; scale factor accumulates monotonically across eons.
||| - ConformalCyclicBounce: Conformal rescaling at grid wall k=136 -> 137 -> 0 bouncing back to ground state (25, 18).
public export
data ExpansionParadigm = MonotonicOpenExpansion | ConformalCyclicBounce

public export
Eq ExpansionParadigm where
  MonotonicOpenExpansion == MonotonicOpenExpansion = True
  ConformalCyclicBounce  == ConformalCyclicBounce  = True
  _                      == _                      = False

public export
Show ExpansionParadigm where
  show MonotonicOpenExpansion = "MonotonicOpen"
  show ConformalCyclicBounce  = "ConformalCyclic"

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
||| - Substrate Metric: 4th Geometry governing capacity & thermodynamic dissipation.
public export
record UniverseSimulationState where
  constructor MkUniverseSimulationState
  epochIndex          : Nat                                    -- Trajectory scale step k (0 to 136)
  superEpoch          : Nat                                    -- Macro cosmic cycle count (rebound at k=136)
  substrateTicks      : Nat                                    -- Action count Delta S = total ticks elapsed
  capacityBudget      : DiscreteCapacityBudget 27 128 55       -- 210 Master partition
  metricTensor        : SymmetricMetricTensor 10               -- 10D Spacetime bulk metric (55 DoF)
  projectedLeaf       : SquareMaxel 4                          -- 4D Spacetime projected leaf (10 DoF)
  moduliDOF           : Nat                                    -- 45 uncompactified Dark Matter moduli
  gellMannGluons      : Vect 8 (SquareMaxel 3)                 -- SU(3) subset G_2 gauge fields
  galacticProfile     : GalacticProfile                        -- Active baryonic core & disk slope
  galacticHalo        : GalacticHaloMultiset                   -- Active dark matter halo phase points
  phaseState          : PhaseState                             -- Symplectic (q, p) phase space
  curvatureDefect     : BoxInt                                 -- Active G_00 energy-momentum defect
  spreadMatrix        : SquareMaxel 2                          -- Companion spread transfer matrix M(s)^k
  scaleFactor         : BoxInt                                 -- Instantaneous scale factor a_k = Q_Blue(k) = x_k^2 + y_k^2
  hubbleExpansionRate : BoxInt                                 -- Discrete Hubble expansion parameter H_k = 2 * y_k^2
  substrateGovernor   : SquareMaxel 2                          -- Substrate Metric Governor (4th Geometry: g_22 = 0)
  expansionMode       : ExpansionParadigm                      -- Cosmic expansion mode (Monotonic Open vs CCC Bounce)
  observerEpochActive : Bool                                   -- True specifically at k=38 (Observer Epoch)
  observerState       : ObserverBranchState                    -- Living matter active inference carrier
  coherenceStatus     : CoherenceStatus CosmicSmoothHorizon (S epochIndex) -- 13-smoothness status
  freeEnergyState     : DiscreteHelmholtzState 27 128 55 2     -- Discrete F = U - TS
  dissipatedEntropy   : BoxInt                                 -- Landauer dissipated thermal entropy from decoherent sieve scales

||| Canonical 2x2 companion spread transfer matrix for multiple spread recurrence:
||| M(s) = [[2 - 4s, -1], [1, 0]]. For s = 0, [[2, -1], [1, 0]].
public export
pythagoreanCompanionMaxel : SquareMaxel 2
pythagoreanCompanionMaxel =
  let c11 = intToBoxInt 2
      c12 = intToBoxInt (-1)
      c21 = intToBoxInt 1
      t0 = singletonCell (mkCell2 0 0) c11
      t1 = setBoxTree (mkCell2 0 1) c12 t0
      t2 = setBoxTree (mkCell2 1 0) c21 t1
  in MkSquareMaxel t2

||| Genesis / Vacuum Initial Universe Simulation State parameterized by ExpansionParadigm.
public export
initUniverseSimulationMode : ExpansionParadigm -> UniverseSimulationState
initUniverseSimulationMode mode =
  let g10 = spacetime10DMetric
      g4  = project10Dto4D g10.metricMaxel
      gluons = [ gellMannMaxel 1, gellMannMaxel 2, gellMannMaxel 3, gellMannMaxel 4
               , gellMannMaxel 5, gellMannMaxel 6, gellMannMaxel 7, gellMannMaxel 8
               ]
      gal = MkGalacticProfile (intToBoxInt 100) (intToBoxInt 0)
      halo = canonicalGalacticHalo
      q0 = singletonCell (mkCell1 1) (intToBoxInt 1)
      p0 = singletonCell (mkCell1 1) (intToBoxInt 0)
      phase0 = MkPhaseState q0 p0
      status0 = evalScaleStepCoherence Z
  in MkUniverseSimulationState
       0
       0
       0
       canonicalCapacityBudget
       g10
       g4
       45
       gluons
       gal
       halo
       phase0
       (intToBoxInt 0)
       (pythagoreanCompanionSquareMaxel (intToBoxInt 4) (intToBoxInt 3))
       (intToBoxInt 25)
       (intToBoxInt 18)
       (parameterizedSubstrateSquareMaxel (intToBoxInt 1) (intToBoxInt 1))
       mode
       False
       DormantObserver
       status0
       canonicalHelmholtzGroundState
       (intToBoxInt 0)

||| Canonical Genesis / Vacuum Initial Universe Simulation State (Default: MonotonicOpenExpansion).
public export
initUniverseSimulation : UniverseSimulationState
initUniverseSimulation = initUniverseSimulationMode MonotonicOpenExpansion
