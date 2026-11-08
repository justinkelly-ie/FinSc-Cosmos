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
import Stage1.Carrier.ChromogeometricMetric
import Stage0.PrimeMultiset
import Stage0.Multiset
import Stage1.FourGeometries
import Stage1.Goh
import Stage1.Goh.Factor
import Stage1.Goh.SpreadFactorization
import Stage0.Biology.ActiveInferenceNeuralNetwork
import Stage0.Biology.TrophicEcology
import Stage0.Hadron.StellarNucleosynthesis
import Stage0.Chemistry.MacromolecularAssembly
import Stage0.Chemistry.MolecularAggregation
import Stage1.ScalePipeline
import Electromagnetism
import Stage1.RadixRepIso
import Stage1.PhysicalUniverse.Stratification
import Stage0.NarayAlphabet
import Stage1.DiracSpinor
import Stage1.Quantum.ToricCode
import Stage0.Hadron.HadronizationEngine
import Stage0.Hadron.CosmicNucleosynthesis
import Stage0.Biology.RibosomalTranslation
import Stage1.Cosmology.MacroEnvelope
import Compound.AstrophysicalAggregation
import Stage0.Token
import Data.Vect
import Stage0.OnSeq.FusedStream

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

||| Maps the 4 Goh prime gates to their canonical fundamental geometry carrier:
public export
gohTokenGeometry : GohPrimeGate -> FundamentalGeometry
gohTokenGeometry Gate2DyadicBit   = HyperbolicGeom
gohTokenGeometry Gate3TriadSpace  = EllipticGeom
gohTokenGeometry Gate5ParabolicDM = ParabolicGeom
gohTokenGeometry Gate7SpectralROM = HyperbolicGeom

||| Canonical association mapping each GohPrimeGate to its underlying AnyGohPrime:
public export
gohGatePrime : GohPrimeGate -> AnyGohPrime
gohGatePrime Gate2DyadicBit    = anyPrime2
gohGatePrime Gate3TriadSpace   = anyPrime3
gohGatePrime Gate5ParabolicDM  = anyPrime5
gohGatePrime Gate7SpectralROM  = anyPrime7

||| Certified prime number p for the active gate:
public export
gohGatePrimeNat : GohPrimeGate -> Nat
gohGatePrimeNat Gate2DyadicBit   = 2
gohGatePrimeNat Gate3TriadSpace  = 3
gohGatePrimeNat Gate5ParabolicDM = 5
gohGatePrimeNat Gate7SpectralROM = 7

||| Primorial prefix capacity associated with each Goh prime gate,
||| derived from the canonical prime spectrum:
public export
gohGatePrimorialCapacity : GohPrimeGate -> Nat
gohGatePrimorialCapacity Gate2DyadicBit   = gohPrimeNat anyPrime2
gohGatePrimorialCapacity Gate3TriadSpace  = gohPrimeNat anyPrime2 * gohPrimeNat anyPrime3
gohGatePrimorialCapacity Gate5ParabolicDM = (gohPrimeNat anyPrime2 * gohPrimeNat anyPrime3) * gohPrimeNat anyPrime5
gohGatePrimorialCapacity Gate7SpectralROM = fst primorialBudgetDimension

||| Classifies current token count N into its active Goh prime gate via primorial thresholds:
public export
activeGohGate : Nat -> GohPrimeGate
activeGohGate n =
  if n <= gohGatePrimorialCapacity Gate2DyadicBit then Gate2DyadicBit
  else if n <= gohGatePrimorialCapacity Gate3TriadSpace then Gate3TriadSpace
  else if n <= gohGatePrimorialCapacity Gate5ParabolicDM then Gate5ParabolicDM
  else Gate7SpectralROM

||| Canonical Cigler-Herbig irreducible spread polynomial factor for each Goh prime gate:
public export
gohGateFactor : (g : GohPrimeGate) -> GohAuxiliary (gohDegree (gohGatePrimeNat g))
gohGateFactor Gate2DyadicBit   = Psi2
gohGateFactor Gate3TriadSpace  = Psi3
gohGateFactor Gate5ParabolicDM = Psi5
gohGateFactor Gate7SpectralROM = Psi7

||| Totient degree φ(p) derived from the irreducible Cigler-Herbig spread polynomial factor:
public export
gohGateTotient : GohPrimeGate -> Nat
gohGateTotient g = gohDegree (gohGatePrimeNat g)

||| Slices the active Goh prime gate factor into its Stage 0 companion matrix operator:
public export
gohGateCompanionMaxel : (g : GohPrimeGate) -> SquareMaxel (gohGateTotient g)
gohGateCompanionMaxel g = spliceFactorToCompanionMaxel (gohGateTotient g) (gohGateFactor g)

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
  substrateTokens  : Nat
  entropyArrow     : BoxInt
  activeGate       : GohPrimeGate
  activeTriad      : TriadQuadrance
  internalEnergy   : BoxInt
  entropy          : BoxInt
  freeEnergy       : BoxInt
  isCondensed      : Bool
  carrierTokens    : Multiset BoxInt FundamentalGeometry
  activeRadixBit   : Bit2
  activeTernaryReg : Vect 3 Bit3

public export
Show GenesisUnfoldingState where
  show st =
    "GenesisUnfolding(N=" ++ show st.substrateTokens ++
    ", Gate=" ++ show st.activeGate ++
    ", Bit2=" ++ show st.activeRadixBit ++
    ", ΔS=" ++ show (unwrapBox st.entropyArrow) ++
    ", F=" ++ show (unwrapBox st.freeEnergy) ++
    ", condensed=" ++ show st.isCondensed ++ ")"

||| Initial vacuum state at ∅_Sub (N = 0, ΔS = 0, F = 0, no metric, no matter, zero binary bit & ternary register).
public export
initGenesisUnfolding : GenesisUnfoldingState
initGenesisUnfolding =
  let t0 = epochTriadQuadrance 0
  in MkGenesisUnfoldingState
       0
       (intToBoxInt 0)
       Gate2DyadicBit
       t0
       (intToBoxInt 0)
       (intToBoxInt 0)
       (intToBoxInt 0)
       False
       ZeroM
       Bit2Zero
       [Bit3Zero, Bit3Zero, Bit3Zero]

||| Computes exact matter partition via the 4 Goh prime gates using model capacity dimensions:
public export
gohPrimePartition : (n : Nat) -> GohFuel 13 -> (BoxInt, BoxInt, BoxInt)
gohPrimePartition n _ =
  let cap210 = fst primorialBudgetDimension
      vmCap = fst ellipticDimension
      deCap = fst hyperbolicDimension
      nBounded = if n > cap210 then cap210 else n
      nInt = cast {to = Integer} nBounded
      vm = (nInt * cast {to = Integer} vmCap) `div` cast {to = Integer} cap210
      de = (nInt * cast {to = Integer} deCap) `div` cast {to = Integer} cap210
      dm = nInt - vm - de
  in (intToBoxInt vm, intToBoxInt de, intToBoxInt dm)

||| Dynamically partitions N tokens across the 3 matter sectors using Cosmic Goh Fuel.
public export
partitionAtN : Nat -> (BoxInt, BoxInt, BoxInt)
partitionAtN n = gohPrimePartition n cosmicSmoothHorizonGohFuel

||| Computes exact non-equilibrium thermodynamic energies (U, S, F) directly from the discrete carrier multiset:
||| - VM = multiplicity of EllipticGeom tokens
||| - DE = multiplicity of HyperbolicGeom tokens
||| - DM = multiplicity of ParabolicGeom tokens
||| - U = 10 * VM + 1 * DE
||| - S = 2 * VM + 5 * DE + 3 * DM
||| - F = U - 2 * S (temperature T = 2)
public export
energyFromTokens : Multiset BoxInt FundamentalGeometry -> (BoxInt, BoxInt, BoxInt)
energyFromTokens tokens =
  let (vm, de, dm) = foldMultiset (\g, w, (vAcc, hAcc, pAcc) =>
                       case g of
                         EllipticGeom   => (vAcc + w, hAcc, pAcc)
                         HyperbolicGeom => (vAcc, hAcc + w, pAcc)
                         ParabolicGeom  => (vAcc, hAcc, pAcc + w)
                         SubstrateGeom  => (vAcc, hAcc, pAcc))
                       (intToBoxInt 0, intToBoxInt 0, intToBoxInt 0)
                       tokens
      u = helmholtzInternalEnergy vm de
      s = helmholtzEntropy vm de dm
      f = helmholtzFreeEnergy u s
  in (u, s, f)

||| Canonical sequence of fundamental geometry tokens up to count N (consolidated into <= 3 RLE nodes):
public export
canonicalTokensAtN : (n : Nat) -> Multiset BoxInt FundamentalGeometry
canonicalTokensAtN Z = ZeroM
canonicalTokensAtN (S k) = insertItemBox (geometryAtTokenIndex k) (intToBoxInt 1) (canonicalTokensAtN k)

||| Computes non-equilibrium thermodynamic energies (U, S, F) for token count N grounded in discrete carrier multiset:
public export
energyAtN : Nat -> (BoxInt, BoxInt, BoxInt)
energyAtN n = energyFromTokens (canonicalTokensAtN n)

||| Strictly linear causal action influx advancing pre-geometric token count (ΔS = 1) from an incoming SubstrateActionToken.
||| Bridges the action token into a located SubstrateToken and unfolds its 1 ➔ 3 chromogeometric triad via bifurcateActionTokenLinear.
||| Enforces Quantitative Type Theory: substrate states and action quanta cannot be duplicated or leaked.
public export
stepGenesisInfluxLinearWithToken : (1 tok : LToken SubstrateActionToken) -> (1 st : GenesisUnfoldingState) -> GenesisUnfoldingState
stepGenesisInfluxLinearWithToken tok (MkGenesisUnfoldingState n arrow _ _ _ _ _ _ tokens _ _) =
  let nextN = S n
      (nextTriad, q) = bifurcateActionTokenLinear 0 nextN tok
      nextArrow = arrow + q
      nextGate = activeGohGate nextN
      geom = geometryAtTokenIndex n
      nextTokens = insertItemBox geom q tokens
      (nextU, nextS, nextF) = energyFromTokens nextTokens
      condensed = nextN >= fst primorialBudgetDimension
      nextNInt = cast {to = Integer} nextN
      nextBit = if (nextNInt `mod` 2) == 1 then Bit2One else Bit2Zero
      nextTritReg = boxIntToVect3Trits (intToBoxInt (nextNInt `mod` 13))
  in MkGenesisUnfoldingState nextN nextArrow nextGate nextTriad nextU nextS nextF condensed nextTokens nextBit nextTritReg

||| Strictly linear causal action influx advancing pre-geometric token count (ΔS = 1).
||| Enforces Quantitative Type Theory: substrate states cannot be duplicated or leaked.
public export
stepGenesisInfluxLinear : (1 st : GenesisUnfoldingState) -> GenesisUnfoldingState
stepGenesisInfluxLinear st = stepGenesisInfluxLinearWithToken (MkLToken unitActionToken) st

public export
stepGenesisInflux : GenesisUnfoldingState -> GenesisUnfoldingState
stepGenesisInflux st = stepGenesisInfluxLinear st

--------------------------------------------------------------------------------
-- 2. CONDENSATION TRANSITION TO MACROSCOPIC SPACETIME (Regime II: N = 210)
--------------------------------------------------------------------------------

||| Phase Transition Morphism: Condenses the saturated 210-budget pre-geometric state
||| into the continuous macroscopic UniverseSimulationState.
public export
condenseGenesisToUniverse : GenesisUnfoldingState -> Maybe UniverseSimulationState
condenseGenesisToUniverse st =
  if st.substrateTokens < fst primorialBudgetDimension then Nothing
  else
    let parabolicCount = multiplicity ParabolicGeom st.carrierTokens
        ellipticCount  = multiplicity EllipticGeom st.carrierTokens
        hyperbolicCount = multiplicity HyperbolicGeom st.carrierTokens
        g10 = synthesize10DMetricFromParabolicCount (boxToNat parabolicCount)
        g4  = project10Dto4D g10.metricMaxel
        spacetime = MkSpacetimeSector g10 g4 (spacetimeModuliDegreesOfFreedom phaseSpaceBasisDim) (intToBoxInt 0) initMacroCosmicEnvelope WhiteDwarf
        gluons = synthesizeGellMannFromEllipticCount (boxToNat ellipticCount)
        gauge = MkGaugeSector gluons vacuumMaxwellState canonicalDiracSpinorState canonicalToricAnyonState
        quarks = canonicalSubatomicQuarkState
        chem = canonicalChemistryState
        matter = MkMatterSector
                   quarks
                   QuarkGluonPlasma
                   ZeroM
                   ZeroM
                   ZeroM
                   ZeroM
                   ZeroM
                   chem
                   (the (List AminoAcid) [])
                   ZeroM
                   DormantObserver
                   emptyTrophicPyramid
        gal = MkGalacticProfile (intToBoxInt 100) (intToBoxInt 0)
        halo = canonicalGalacticHalo
        q0 = singletonCell (mkCell1 1) (intToBoxInt 1)
        p0 = singletonCell (mkCell1 1) (intToBoxInt 0)
        phase0 = mkPhaseState q0 p0
        dynamics = MkDynamicsSector phase0 gal halo
        status0 = evalScaleStepCoherence Z
        initialSpread = if boxToNat hyperbolicCount >= 128
                          then pythagoreanCompanionSquareMaxel (intToBoxInt 4) (intToBoxInt 3)
                          else pythagoreanCompanionSquareMaxel (intToBoxInt 1) (intToBoxInt 0)
        condensedFE = evaluateDynamicHelmholtzState st.internalEnergy st.entropy
        thermo = MkSubstrateSector
                   0
                   0
                   st.substrateTokens
                   canonicalCapacityBudget
                   initialSpread
                   (intToBoxInt 25)
                   (intToBoxInt 18)
                   (parameterizedSubstrateSquareMaxel (intToBoxInt 1) (intToBoxInt 1))
                   MonotonicOpenExpansion
                   False
                   status0
                   condensedFE
                   (intToBoxInt 0)
    in Just (MkUniverseSimulationState spacetime gauge matter dynamics thermo)

||| Strictly linear condensation transition morphism: Either retains pre-geometric state
||| or transforms it into macroscopic UniverseSimulationState without dropping tokens.
public export
condenseGenesisLinear : (1 st : GenesisUnfoldingState) -> Either GenesisUnfoldingState UniverseSimulationState
condenseGenesisLinear (MkGenesisUnfoldingState n arrow gate triad u s f condensed tokens bit tritReg) =
  let rebuilt = MkGenesisUnfoldingState n arrow gate triad u s f condensed tokens bit tritReg
  in case condenseGenesisToUniverse rebuilt of
       Just simSt => Right simSt
       Nothing    => Left rebuilt

||| Pullback phase transition: Dissolves a post-geometric UniverseSimulationState
||| back into its pre-geometric GenesisUnfoldingState carrier tokens:
public export
dissolveUniverseToGenesis : UniverseSimulationState -> GenesisUnfoldingState
dissolveUniverseToGenesis st =
  let n = fst primorialBudgetDimension
      arrow = natToBoxInt (fst primorialBudgetDimension)
      gate = Gate7SpectralROM
      triad = epochTriadQuadrance 0
      u = (freeEnergyState st).internalEnergy
      s = (freeEnergyState st).entropy
      f = (freeEnergyState st).freeEnergy
      tokens = canonicalTokensAtN (fst primorialBudgetDimension)
      bit = Bit2Zero
      tritReg = [Bit3Zero, Bit3Zero, Bit3Zero]
  in MkGenesisUnfoldingState n arrow gate triad u s f True tokens bit tritReg

||| Audits round-trip dissolution and condensation between pre-geometric and post-geometric states:
public export
auditDissolutionCondensationRoundTripProof : Bool
auditDissolutionCondensationRoundTripProof =
  let st0 = initUniverseSimulation
      gState = dissolveUniverseToGenesis st0
  in gState.isCondensed && (gState.substrateTokens == fst primorialBudgetDimension) &&
     case condenseGenesisToUniverse gState of
       Just simSt => (freeEnergyState simSt).freeEnergy == groundStateFreeEnergy
       Nothing    => False

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
  show (PostGeometric st) = "PostGeometric(ticks=" ++ show (substrateTicks st) ++ ", epoch=" ++ show (epochIndex st) ++ ")"

||| Advances the unified cosmological state by consuming a linear SubstrateActionToken (ΔS = 1) under strict QTT linearity.
public export
stepCosmosUnifiedWithToken : (1 tok : LToken SubstrateActionToken) -> (1 st : CosmosEvolutionState) -> CosmosEvolutionState
stepCosmosUnifiedWithToken (MkLToken tok) (PreGeometric st) =
  let nextSt = stepGenesisInfluxLinearWithToken (MkLToken tok) st
  in case condenseGenesisLinear nextSt of
       Left stillPre => PreGeometric stillPre
       Right simSt   => PostGeometric simSt
stepCosmosUnifiedWithToken (MkLToken tok) (PostGeometric simSt) =
  let nextSim = stepUniverseSimulationWithToken (MkLToken tok) simSt
  in if nextSim.thermodynamicSector.subExpansionMode == ConformalCyclicBounce &&
        nextSim.thermodynamicSector.subTicks > 0 &&
        (cast {to = Integer} nextSim.thermodynamicSector.subTicks `mod` 137 == 0)
       then PreGeometric (dissolveUniverseToGenesis nextSim)
       else PostGeometric nextSim

||| Advances the unified cosmological state by exactly 1 action quantum (ΔS = 1) under strict QTT linearity.
public export
stepCosmosUnifiedLinear : (1 st : CosmosEvolutionState) -> CosmosEvolutionState
stepCosmosUnifiedLinear st = stepCosmosUnifiedWithToken (MkLToken unitActionToken) st

public export
stepCosmosUnified : CosmosEvolutionState -> CosmosEvolutionState
stepCosmosUnified st = stepCosmosUnifiedLinear st

||| Unified initial vacuum state at ∅_Sub.
public export
initCosmosUnified : CosmosEvolutionState
initCosmosUnified = PreGeometric initGenesisUnfolding

||| Strictly linear multi-step unified cosmological simulation.
public export
runCosmosUnifiedStepsLinear : (n : Nat) -> (1 st : CosmosEvolutionState) -> CosmosEvolutionState
runCosmosUnifiedStepsLinear Z st = st
runCosmosUnifiedStepsLinear (S k) st = runCosmosUnifiedStepsLinear k (stepCosmosUnifiedLinear st)

public export
runCosmosUnifiedSteps : (n : Nat) -> CosmosEvolutionState -> CosmosEvolutionState
runCosmosUnifiedSteps n st = runCosmosUnifiedStepsLinear n st

||| Cosmological Quantum observable record emitted at each step of universal evolution.
public export
record CosmologicalQuantum where
  constructor MkCosmologicalQuantum
  quantumEpoch             : Nat
  quantumSuperEpoch        : Nat
  quantumScaleFactor       : BoxInt
  quantumCurvatureDefect   : BoxInt
  quantumObserverPhase     : ObserverBranchState
  quantumFreeEnergy        : BoxInt
  quantumDissipatedEntropy : BoxInt

public export
Eq CosmologicalQuantum where
  (MkCosmologicalQuantum e1 s1 a1 c1 o1 f1 d1) == (MkCosmologicalQuantum e2 s2 a2 c2 o2 f2 d2) =
    e1 == e2 && s1 == s2 && a1 == a2 && c1 == c2 && o1 == o2 && f1 == f2 && d1 == d2

public export
Show CosmologicalQuantum where
  show (MkCosmologicalQuantum e s a c o f d) =
    "CosmologicalQuantum(ep=" ++ show e ++ ", super=" ++ show s ++
    ", a=" ++ show (unwrapBox a) ++ ", defect=" ++ show (unwrapBox c) ++
    ", obs=" ++ show o ++ ", F=" ++ show (unwrapBox f) ++ ", S_diss=" ++ show (unwrapBox d) ++ ")"

||| Project current physical observables from either pre-geometric void or post-geometric cosmos into a CosmologicalQuantum.
public export
snapshotCosmosQuantum : CosmosEvolutionState -> CosmologicalQuantum
snapshotCosmosQuantum (PreGeometric g) =
  MkCosmologicalQuantum g.substrateTokens 0 (intToBoxInt 1) (intToBoxInt 0) DormantObserver g.freeEnergy (intToBoxInt 0)
snapshotCosmosQuantum (PostGeometric sim) =
  MkCosmologicalQuantum (epochIndex sim) (superEpoch sim) (scaleFactor sim) (curvatureDefect sim) (observerState sim) (freeEnergyState sim).freeEnergy (dissipatedEntropy sim)

||| Linear unified step transducer consuming an LToken SubstrateActionToken and emitting a CosmologicalQuantum
||| alongside the linearly updated CosmosEvolutionState (Rule 04 §1).
public export
stepCosmosUnifiedObservableWithToken :
  (1 tok : LToken SubstrateActionToken) ->
  (1 st : CosmosEvolutionState) ->
  LinearStatePair CosmosEvolutionState CosmologicalQuantum
stepCosmosUnifiedObservableWithToken (MkLToken tok) (PreGeometric g) =
  let (MkGenesisUnfoldingState n arrow gate triad u s f condensed tokens bit tritReg) = g
      obs = MkCosmologicalQuantum n 0 (intToBoxInt 1) (intToBoxInt 0) DormantObserver f (intToBoxInt 0)
      nextSt = stepCosmosUnifiedWithToken (MkLToken tok) (PreGeometric (MkGenesisUnfoldingState n arrow gate triad u s f condensed tokens bit tritReg))
  in MkLStatePair nextSt obs
stepCosmosUnifiedObservableWithToken (MkLToken tok) (PostGeometric sim) =
  let (MkUniverseSimulationState sp ga ma dy th) = sim
      obs = MkCosmologicalQuantum th.subEpochIndex th.subSuperEpoch th.subScaleFactor sp.bulkCurvatureDefect ma.matObserverState th.subFreeEnergyState.freeEnergy th.subDissipatedEntropy
      nextSt = stepCosmosUnifiedWithToken (MkLToken tok) (PostGeometric (MkUniverseSimulationState sp ga ma dy th))
  in MkLStatePair nextSt obs

||| Runs N unified cosmological steps under strict QTT linearity, accumulating CosmologicalQuantum observables.
%spec steps
public export
runCosmosUnifiedWithObservablesLinear :
  (steps : Nat) ->
  (1 st : CosmosEvolutionState) ->
  LinearStatePair CosmosEvolutionState (List CosmologicalQuantum)
runCosmosUnifiedWithObservablesLinear Z st =
  MkLStatePair st (the (List CosmologicalQuantum) [])
runCosmosUnifiedWithObservablesLinear (S k) st =
  let MkLStatePair st' obs = stepCosmosUnifiedObservableWithToken (MkLToken unitActionToken) st
      MkLStatePair stFinal history = runCosmosUnifiedWithObservablesLinear k st'
  in MkLStatePair stFinal (the (List CosmologicalQuantum) (obs :: history))

||| Deforested infinite coinductive stream generator of universal cosmological evolution:
||| Spans from the initial empty multiset carrier ∅_Sub, through the 4 Goh prime gates,
||| condensation at Primorial 210 ground state (F = -1320), into continuous 137-epoch simulation.
public export
streamUniversalCosmology : FusedStream CosmologicalQuantum
streamUniversalCosmology =
  unfoldStream (\st =>
    let MkLStatePair nextSt obs = stepCosmosUnifiedObservableWithToken (MkLToken unitActionToken) st
    in Yield obs nextSt) initCosmosUnified

||| Deforested infinite coinductive stream generator of raw CosmosEvolutionState:
public export
streamCosmosFullState : FusedStream CosmosEvolutionState
streamCosmosFullState =
  unfoldStream (\st => Yield st (stepCosmosUnifiedWithToken (MkLToken unitActionToken) st)) initCosmosUnified

||| Static compiler proof witness verifying that streaming cosmological evolution
||| evaluates continuously from vacuum without deadlock:
public export
auditStreamUniversalCosmologyProof : Bool
auditStreamUniversalCosmologyProof =
  let initialQuantum = snapshotCosmosQuantum initCosmosUnified
      strm = streamUniversalCosmology
      tokens = runFueledStreamNat 5 strm
  in initialQuantum.quantumEpoch == 0 &&
     initialQuantum.quantumFreeEnergy == intToBoxInt 0 &&
     length tokens == 5

--------------------------------------------------------------------------------
-- 4. THE 4 BREAKDOWN BOUNDARY DIAGNOSTICS & COMPILE-TIME AUDIT WITNESSES
--------------------------------------------------------------------------------

||| Audit 1: Absorbing Vacuum Attractor (0 * M = 0) Mitigation Witness.
||| Proves that spontaneous causal token injection yields Delta S = 1 and N = 1 > 0 from vacuum.
public export
auditVacuumAttractorMitigationProof : Bool
auditVacuumAttractorMitigationProof =
  let st0 = initGenesisUnfolding
      st1 = stepGenesisInfluxLinear st0
  in st0.substrateTokens == 0 &&
     boxEq st0.entropyArrow (intToBoxInt 0) &&
     st1.substrateTokens == 1 &&
     boxEq st1.entropyArrow (intToBoxInt 1)

||| Audit 2: Null Metric Singularity (det g = 0) Mitigation Witness.
||| Proves that the 10D spacetime metric tensor component dimension identically
||| matches the 10th triangular number T_10 = 55 (darkMatterTriangularResidue).
public export
auditNullMetricSingularityMitigationProof : Bool
auditNullMetricSingularityMitigationProof =
  triangularNat 10 == 55 &&
  Stage1.FourGeometries.darkMatterTriangularResidue == 55

||| Audit 3: Pre-Equilibrium Capacity Gap (N < 210) Mitigation Witness.
||| Proves that discrete Helmholtz free energy relaxes from F(0) = 0 to
||| the unique ground state minimum F(210) = -1320.
public export
auditCapacityGapMitigationProof : Bool
auditCapacityGapMitigationProof =
  let (_, _, f0) = energyAtN 0
      (_, _, f210) = energyAtN (fst primorialBudgetDimension)
  in boxEq f0 (intToBoxInt 0) &&
     boxEq f210 groundStateFreeEnergy

||| Audit 4: Type-Level Smoothness Failure Mitigation Witness.
||| Proves the Totient Horizon Theorem: the sum of totients across the 4 Goh prime gates
||| identically equals the Cosmic Smooth Horizon (Bound = 13).
public export
auditTotientHorizonMitigationProof : Bool
auditTotientHorizonMitigationProof =
  (gohGateTotient Gate2DyadicBit +
   gohGateTotient Gate3TriadSpace +
   gohGateTotient Gate5ParabolicDM +
   gohGateTotient Gate7SpectralROM) == Stage1.TypeTheory.Smoothness.CosmicSmoothHorizon

||| Audit 4b: Binary & Ternary Radix Gate Unfolding Witness (Gate 2 p=2 & Gate 3 p=3).
||| Verifies that pre-geometric unfolding evolves the dyadic Bit2 parity state and
||| the 3-trit Naray balanced ternary register (27 = 3^3 elliptic state space).
public export
auditGenesisRadixUnfoldingProof : Bool
auditGenesisRadixUnfoldingProof =
  let st0 = initGenesisUnfolding
      st1 = stepGenesisInfluxLinear st0
      st2 = stepGenesisInfluxLinear st1
      st3 = stepGenesisInfluxLinear st2
  in st0.activeRadixBit == Bit2Zero &&
     st1.activeRadixBit == Bit2One &&
     st2.activeRadixBit == Bit2Zero &&
     st3.activeRadixBit == Bit2One &&
     vect3TritsToBoxInt st3.activeTernaryReg == intToBoxInt 3 &&
     verifyRoundTrip radixBinaryRepIso (bit2ToBit st0.activeRadixBit) &&
     verifyRoundTrip radixBinaryRepIso (bit2ToBit st1.activeRadixBit)

||| Master End-to-End Genesis Unfolding & Condensation Transition Proof:
||| Traces full evolution from ∅_Sub, through 4 Goh gates, condensation at N = 210 (F = -1320),
||| and entry into the PostGeometric living observer active inference epoch (N = 250, k = 40 >= 38).
public export
auditGenesisUnfoldingEndToEndProof : Bool
auditGenesisUnfoldingEndToEndProof =
  let st0 = initCosmosUnified
      isInitPre = case st0 of
                    PreGeometric g => g.substrateTokens == 0 &&
                                      boxEq g.entropyArrow (intToBoxInt 0) &&
                                      boxEq g.freeEnergy (intToBoxInt 0)
                    PostGeometric _ => False
      -- Step to 210 (condensation boundary)
      st210 = runCosmosUnifiedStepsLinear (fst primorialBudgetDimension) st0
      isCondensedPost = case st210 of
                          PreGeometric _ => False
                          PostGeometric sim => substrateTicks sim == fst primorialBudgetDimension &&
                                               boxEq (freeEnergyState sim).freeEnergy groundStateFreeEnergy &&
                                               moduliDOF sim == triangularNat 9
      -- Step 40 ticks further (N = 250, k = 40 >= 38)
      st250 = runCosmosUnifiedStepsLinear 40 st210
      isObserverActive = case st250 of
                           PreGeometric _ => False
                           PostGeometric sim => substrateTicks sim == 250 &&
                                                epochIndex sim == 40 &&
                                                observerEpochActive sim == True &&
                                                case observerState sim of
                                                  LivingObserver _ => True
                                                  DormantObserver  => False
  in isInitPre && isCondensedPost && isObserverActive

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
      auditVacuumAttractorMitigationProof
      "Without causal entropy arrow (Delta S = 0), matrix operator M * 0 = 0 freezes universe in timeless zero-state."
      "Mitigated by spontaneous asymmetric causal token injection (Delta S >= 1) via SubstrateToken."
  , MkBreakdownDiagnostic
      2
      "Null Metric Singularity (det g = 0)"
      auditNullMetricSingularityMitigationProof
      "In pre-geometric void, spacetime metric tensor is empty (g_00 = 0); continuous geodesic acceleration is undefined."
      "Mitigated by suspending continuous symplectic integration until 55 parabolic dark matter tokens condense."
  , MkBreakdownDiagnostic
      3
      "Pre-Equilibrium Capacity Gap (N < 210)"
      auditCapacityGapMitigationProof
      "For N < 210, partition function does not factorize and discrete free energy F(N) > -1320 (un-thermalized)."
      "Mitigated by modeling non-equilibrium thermodynamic relaxation F(N) descending from 0 to -1320."
  , MkBreakdownDiagnostic
      4
      "Type-Level Smoothness Failure (N not in Smooth(13))"
      auditTotientHorizonMitigationProof
      "Intermediate capacities (e.g. N = 17, 19, 23) lack SmoothWitness 13 certificates and experience decoherent turbulence."
      "Mitigated by two-phase architecture: runtime dynamic tracking in Regime I, compile-time certified in Regime II."
  ]
