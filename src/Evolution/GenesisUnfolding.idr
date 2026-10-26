||| Genesis-to-Cosmos End-to-End Unfolding Engine (∅_Sub ➔ Primorial 210 ➔ 137 Sieve)
|||
||| Traces universal emergence from the absolute empty multiset carrier (∅_Sub),
||| through spontaneous (4, 3) triad bifurcation, pre-geometric non-equilibrium
||| Helmholtz free energy relaxation, condensation into the Primorial 210 ground
||| state (F = -1320), spacetime metric ignition, and hand-off to the continuous
||| 137-scale cosmological simulation stepper.
module Evolution.GenesisUnfolding

import Stage0.BoxInt
import Stage0.StructuralFuel
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
-- 0. THE 4 GOH PRIME ADJUNCTION GATES (p ∈ {2, 3, 5, 7})
--------------------------------------------------------------------------------

||| The 4 primitive Goh prime adjunction gates driving pre-geometric inflation:
||| - Gate2DyadicBit   : p = 2, φ(2) = 1, Fuel = 3 (N ∈ [1, 2]: Dyadic bit, Pauli spin)
||| - Gate3TriadSpace  : p = 3, φ(3) = 2, Fuel = 4 (N ∈ [3, 6]: Spontaneous (25, 7, 24) Triad)
||| - Gate5ParabolicDM : p = 5, φ(5) = 4, Fuel = 7 (N ∈ [7, 30]: 55 DM dissipation drain)
||| - Gate7SpectralROM : p = 7, φ(7) = 6, Fuel = 10 (N ∈ [31, 210]: 128 DE ROM & Fano octonions)
public export
data GohPrimeGate : Type where
  Gate2DyadicBit    : GohPrimeGate
  Gate3TriadSpace   : GohPrimeGate
  Gate5ParabolicDM  : GohPrimeGate
  Gate7SpectralROM  : GohPrimeGate

public export
Eq GohPrimeGate where
  Gate2DyadicBit   == Gate2DyadicBit   = True
  Gate3TriadSpace  == Gate3TriadSpace  = True
  Gate5ParabolicDM == Gate5ParabolicDM = True
  Gate7SpectralROM == Gate7SpectralROM = True
  _ == _ = False

public export
Show GohPrimeGate where
  show Gate2DyadicBit    = "Gate2(DyadicBit,p=2,φ=1)"
  show Gate3TriadSpace   = "Gate3(TriadSpace,p=3,φ=2)"
  show Gate5ParabolicDM  = "Gate5(ParabolicDM,p=5,φ=4)"
  show Gate7SpectralROM  = "Gate7(SpectralROM,p=7,φ=6)"

||| Classifies current token count N into its active Goh prime gate:
public export
activeGohGate : Nat -> GohPrimeGate
activeGohGate n =
  if n <= 2 then Gate2DyadicBit
  else if n <= 6 then Gate3TriadSpace
  else if n <= 30 then Gate5ParabolicDM
  else Gate7SpectralROM

||| Totient degree φ(p) associated with each primitive Goh prime gate:
public export
gohGateTotient : GohPrimeGate -> Nat
gohGateTotient Gate2DyadicBit    = 1
gohGateTotient Gate3TriadSpace   = 2
gohGateTotient Gate5ParabolicDM  = 4
gohGateTotient Gate7SpectralROM  = 6

||| Structural fuel steps derived from totient degree: Fuel(p) = gohFuelNat(φ(p)):
public export
gohGateFuelSteps : GohPrimeGate -> Nat
gohGateFuelSteps g = gohFuelNat (gohGateTotient g)

||| TOTIENT HORIZON THEOREM (Gauss-Goh Prime Sieve):
||| The sum of totient root degrees across the 4 Goh prime divisors of 210
||| identically equals the Cosmic Smooth Horizon (Bound = 13):
|||   φ(2) + φ(3) + φ(5) + φ(7) = 1 + 2 + 4 + 6 = 13
public export
0 prfGateTotientSum : (gohGateTotient Gate2DyadicBit +
                      gohGateTotient Gate3TriadSpace +
                      gohGateTotient Gate5ParabolicDM +
                      gohGateTotient Gate7SpectralROM = 13)
prfGateTotientSum = Refl

public export
0 prfCosmicSmoothHorizonTotientSum : (1 + 2 + 4 + 6 = 13)
prfCosmicSmoothHorizonTotientSum = Refl

||| Model-derived structural fuel for the Cosmic Smooth Horizon:
public export
cosmicSmoothHorizonGohFuel : GohFuel 13
cosmicSmoothHorizonGohFuel = gohFuelForCapacity 13

public export
0 prfHorizonGohFuelSteps : (gohFuelForCapacity 13).fuelSteps = 21
prfHorizonGohFuelSteps = Refl

--------------------------------------------------------------------------------
-- 1. PRE-GEOMETRIC GENESIS UNFOLDING STATE (Regime I: N = 0 .. 209)
--------------------------------------------------------------------------------

||| Pre-geometric genesis state tracking the emergence of spacetime from ∅_Sub:
||| - substrateTokens : total token count N (0 to 209 before condensation)
||| - entropyArrow    : accumulated directional causal entropy ΔS
||| - activeGate      : active Goh prime adjunction gate
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
  activeGate      : GohPrimeGate
  activeTriad     : TriadQuadrance
  internalEnergy  : BoxInt
  entropy         : BoxInt
  freeEnergy      : BoxInt
  isCondensed     : Bool

public export
Show GenesisUnfoldingState where
  show st =
    "GenesisUnfolding(N=" ++ show st.substrateTokens ++
    ", Gate=" ++ show st.activeGate ++
    ", ΔS=" ++ show (unwrapBox st.entropyArrow) ++
    ", F=" ++ show (unwrapBox st.freeEnergy) ++
    ", condensed=" ++ show st.isCondensed ++ ")"

||| Initial vacuum state at ∅_Sub (N = 0, ΔS = 0, F = 0, no metric, no matter).
public export
initGenesisUnfolding : GenesisUnfoldingState
initGenesisUnfolding =
  let t0 = epochTriadQuadrance 0
  in MkGenesisUnfoldingState 0 (intToBoxInt 0) Gate2DyadicBit t0 (intToBoxInt 0) (intToBoxInt 0) (intToBoxInt 0) False

||| Computes exact matter partition via the 4 Goh prime gates:
public export
gohPrimePartition : (n : Nat) -> GohFuel 13 -> (BoxInt, BoxInt, BoxInt)
gohPrimePartition n _ =
  let nBounded = if n > the Nat 210 then the Nat 210 else n
      nInt = cast {to = Integer} nBounded
      vm = (nInt * 27) `div` 210
      de = (nInt * 128) `div` 210
      dm = nInt - vm - de
  in (intToBoxInt vm, intToBoxInt de, intToBoxInt dm)

||| Dynamically partitions N tokens across the 3 matter sectors using Cosmic Goh Fuel.
public export
partitionAtN : Nat -> (BoxInt, BoxInt, BoxInt)
partitionAtN n = gohPrimePartition n cosmicSmoothHorizonGohFuel

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
stepGenesisInflux (MkGenesisUnfoldingState n arrow _ _ _ _ _ _) =
  let nextN = S n
      nextArrow = arrow + intToBoxInt 1
      nextGate = activeGohGate nextN
      nextTriad = epochTriadQuadrance nextN
      (nextU, nextS, nextF) = energyAtN nextN
      condensed = nextN >= 210
  in MkGenesisUnfoldingState nextN nextArrow nextGate nextTriad nextU nextS nextF condensed

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
               DormantObserver
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
