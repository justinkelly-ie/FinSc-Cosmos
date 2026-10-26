||| Genesis-to-Cosmos End-to-End Unfolding Engine (∅_Sub ➔ Primorial 210 ➔ 137 Sieve)
|||
||| Traces universal emergence from the absolute empty multiset carrier (∅_Sub),
||| through spontaneous (4, 3) triad bifurcation, pre-geometric non-equilibrium
||| Helmholtz free energy relaxation, condensation into the Primorial 210 ground
||| state (F = -1320), spacetime metric ignition, and hand-off to the continuous
||| 137-scale cosmological simulation stepper.
module Evolution.GenesisUnfolding

import Stage0.BoxInt
import Stage1.MultisetTree
import Stage1.Carrier.SquareMaxel
import Stage1.Carrier.CellMultiset
import Stage1.Basis.CoordCell
import Stage1.Carrier.Vexel
import Stage1.SymmetricMetricTensor
import Stage1.Fields.OctonionGaugeUnification
import Stage1.Math.GalacticRotationCurve
import Compound.SymplecticIntegrator
import Stage1.Epoch.ScaleTrajectorySieve
import Stage1.Multiset.PrimordialUnfolding
import Evolution.SimulationState
import Evolution.SimulationStepper
import Data.Vect

%default total

--------------------------------------------------------------------------------
-- 1. PRE-GEOMETRIC GENESIS UNFOLDING STATE (Regime I: N = 0 .. 209)
--------------------------------------------------------------------------------

||| Pre-geometric genesis state tracking the emergence of spacetime from ∅_Sub:
||| - substrateTokens : total token count N (0 to 209 before condensation)
||| - entropyArrow    : accumulated directional causal entropy ΔS
||| - activeTriad     : active chromogeometric triad (Q_Blue, Q_Red, Q_Green)
||| - internalEnergy  : non-equilibrium internal energy U(N)
||| - entropy         : non-equilibrium combinatorial entropy S(N)
||| - freeEnergy      : non-equilibrium Helmholtz free energy F = U - 2S
||| - isCondensed     : boolean indicating whether N >= 210 and ground state is reached
public export
record GenesisUnfoldingState where
  constructor MkGenesisUnfoldingState
  substrateTokens : Nat
  entropyArrow    : BoxInt
  activeTriad     : TriadQuadrance
  internalEnergy  : BoxInt
  entropy         : BoxInt
  freeEnergy      : BoxInt
  isCondensed     : Bool

public export
Show GenesisUnfoldingState where
  show st =
    "GenesisUnfolding(N=" ++ show st.substrateTokens ++
    ", ΔS=" ++ show (unwrapBox st.entropyArrow) ++
    ", F=" ++ show (unwrapBox st.freeEnergy) ++
    ", condensed=" ++ show st.isCondensed ++ ")"

||| Initial vacuum state at ∅_Sub (N = 0, ΔS = 0, F = 0, no metric, no matter).
public export
initGenesisUnfolding : GenesisUnfoldingState
initGenesisUnfolding =
  let t0 = epochTriadQuadrance 0
  in MkGenesisUnfoldingState 0 (intToBoxInt 0) t0 (intToBoxInt 0) (intToBoxInt 0) (intToBoxInt 0) False

||| Dynamically partitions N tokens across the 3 matter sectors:
||| vm(N) = (N * 27) / 210, de(N) = (N * 128) / 210, dm(N) = N - vm - de.
public export
partitionAtN : Nat -> (BoxInt, BoxInt, BoxInt)
partitionAtN n =
  let nInt = cast {to = Integer} n
      vm = (nInt * 27) `div` 210
      de = (nInt * 128) `div` 210
      dm = nInt - vm - de
  in (intToBoxInt vm, intToBoxInt de, intToBoxInt dm)

||| Computes non-equilibrium thermodynamic energies (U, S, F) for token count N:
||| - U(N) = 10 * VM + 1 * DE
||| - S(N) = 2 * VM + 5 * DE + 3 * DM
||| - F(N) = U - 2 * S (temperature T = 2)
public export
energyAtN : Nat -> (BoxInt, BoxInt, BoxInt)
energyAtN n =
  let (vm, de, dm) = partitionAtN n
      u = (intToBoxInt 10 * vm) + (intToBoxInt 1 * de)
      s = (intToBoxInt 2 * vm) + (intToBoxInt 5 * de) + (intToBoxInt 3 * dm)
      f = u - (intToBoxInt 2 * s)
  in (u, s, f)

||| Single-step causal action influx advancing pre-geometric token count (ΔS = 1).
public export
stepGenesisInflux : GenesisUnfoldingState -> GenesisUnfoldingState
stepGenesisInflux (MkGenesisUnfoldingState n arrow _ _ _ _ _) =
  let nextN = S n
      nextArrow = arrow + intToBoxInt 1
      nextTriad = epochTriadQuadrance nextN
      (nextU, nextS, nextF) = energyAtN nextN
      condensed = nextN >= 210
  in MkGenesisUnfoldingState nextN nextArrow nextTriad nextU nextS nextF condensed

--------------------------------------------------------------------------------
-- 2. CONDENSATION TRANSITION TO MACROSCOPIC SPACETIME (Regime II: N = 210)
--------------------------------------------------------------------------------

||| Phase Transition Morphism: Condenses the saturated 210-budget pre-geometric state
||| into the continuous macroscopic UniverseSimulationState.
public export
condenseGenesisToUniverse : GenesisUnfoldingState -> Maybe UniverseSimulationState
condenseGenesisToUniverse st =
  if st.substrateTokens < 210 then Nothing
  else
    let g10 = spacetime10DMetric
        g4  = project10Dto4D g10.metricMaxel
        gluons : Vect 8 (BoxSquareMaxel 3) =
          [ gellMannMaxel 1, gellMannMaxel 2, gellMannMaxel 3, gellMannMaxel 4
          , gellMannMaxel 5, gellMannMaxel 6, gellMannMaxel 7, gellMannMaxel 8
          ]
        gal = MkGalacticProfile (intToBoxInt 100) (intToBoxInt 0)
        q0 = singletonCell (mkCell1 1) (intToBoxInt 1)
        p0 = singletonCell (mkCell1 1) (intToBoxInt 0)
        phase0 = MkPhaseState q0 p0
        status0 = evalScaleStepCoherence Z
    in Just (MkUniverseSimulationState
               0
               st.substrateTokens
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
               canonicalHelmholtzGroundState)

--------------------------------------------------------------------------------
-- 3. UNIFIED COSMOLOGICAL EVOLUTION STATE & TRANSDUCER
--------------------------------------------------------------------------------

||| Unified 2-phase cosmological state spanning pre-geometric and post-geometric evolution:
public export
data CosmosEvolutionState : Type where
  PreGeometric  : GenesisUnfoldingState -> CosmosEvolutionState
  PostGeometric : UniverseSimulationState -> CosmosEvolutionState

public export
Show CosmosEvolutionState where
  show (PreGeometric g)   = "PreGeometric(" ++ show g ++ ")"
  show (PostGeometric st) = "PostGeometric(ticks=" ++ show st.substrateTicks ++ ", epoch=" ++ show st.epochIndex ++ ")"

||| Advances the unified cosmological state by exactly 1 action quantum (ΔS = 1).
||| Seamlessly transitions across the 210 condensation phase boundary.
public export
stepCosmosUnified : CosmosEvolutionState -> CosmosEvolutionState
stepCosmosUnified (PreGeometric st) =
  let nextSt = stepGenesisInflux st
  in if nextSt.isCondensed
        then case condenseGenesisToUniverse nextSt of
               Just simSt => PostGeometric simSt
               Nothing    => PreGeometric nextSt
        else PreGeometric nextSt
stepCosmosUnified (PostGeometric simSt) =
  PostGeometric (stepUniverseSimulation simSt)

||| Unified initial vacuum state at ∅_Sub.
public export
initCosmosUnified : CosmosEvolutionState
initCosmosUnified = PreGeometric initGenesisUnfolding

||| Advance the unified simulation by n action steps.
public export
runCosmosUnifiedSteps : (n : Nat) -> CosmosEvolutionState -> CosmosEvolutionState
runCosmosUnifiedSteps Z st = st
runCosmosUnifiedSteps (S k) st = runCosmosUnifiedSteps k (stepCosmosUnified st)

--------------------------------------------------------------------------------
-- 4. THE 4 BREAKDOWN BOUNDARY DIAGNOSTICS
--------------------------------------------------------------------------------

public export
record BreakdownDiagnostic where
  constructor MkBreakdownDiagnostic
  boundaryIndex : Nat
  boundaryName  : String
  isMitigated   : Bool
  failureReason : String
  resolution    : String

public export
diagnoseBreakdownBoundaries : List BreakdownDiagnostic
diagnoseBreakdownBoundaries =
  [ MkBreakdownDiagnostic
      1
      "Absorbing Vacuum Attractor (0 * M = 0)"
      True
      "Without causal entropy arrow (Delta S = 0), matrix operator M * 0 = 0 freezes universe in timeless zero-state."
      "Mitigated by spontaneous asymmetric causal token injection (Delta S >= 1) via SubstrateToken."
  , MkBreakdownDiagnostic
      2
      "Null Metric Singularity (det g = 0)"
      True
      "In pre-geometric void, spacetime metric tensor is empty (g_00 = 0); continuous geodesic acceleration is undefined."
      "Mitigated by suspending continuous symplectic integration until 55 parabolic dark matter tokens condense."
  , MkBreakdownDiagnostic
      3
      "Pre-Equilibrium Capacity Gap (N < 210)"
      True
      "For N < 210, partition function does not factorize and discrete free energy F(N) > -1320 (un-thermalized)."
      "Mitigated by modeling non-equilibrium thermodynamic relaxation F(N) descending from 0 to -1320."
  , MkBreakdownDiagnostic
      4
      "Type-Level Smoothness Failure (N not in Smooth(13))"
      True
      "Intermediate capacities (e.g. N = 17, 19, 23) lack SmoothWitness 13 certificates and experience decoherent turbulence."
      "Mitigated by two-phase architecture: runtime dynamic tracking in Regime I, compile-time certified in Regime II."
  ]
