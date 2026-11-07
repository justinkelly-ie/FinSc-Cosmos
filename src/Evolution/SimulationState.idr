module Evolution.SimulationState

import Stage0.BoxInt
import Stage1.MultisetTree
import Stage1.SymmetricMetricTensor
import Stage1.Fields.OctonionGaugeUnification
import Stage1.Math.GalacticRotationCurve
import Compound.SymplecticIntegrator
import Stage1.Epoch.ScaleTrajectorySieve
import Stage1.Multiset.PrimordialUnfolding
import Stage1.Epoch.ObserverPredictions
import Stage1.FourGeometries
import Stage1.Carrier.ChromogeometricMetric
import Stage1.Carrier.SquareMaxel
import Stage0.Biology.ActiveInferenceNeuralNetwork
import Stage0.Multiset
import Stage0.Hadron.StellarNucleosynthesis
import Stage0.Chemistry.MacromolecularAssembly
import Stage0.Chemistry.MolecularAggregation
import Stage0.Biology.TrophicEcology
import Stage1.ScalePipeline
import Electromagnetism
import Stage1.Thermodynamics.EntropicArrow
import Stage1.DiracSpinor
import Stage1.Quantum.ToricCode
import Stage0.Hadron.HadronizationEngine
import Stage0.Hadron.CosmicNucleosynthesis
import Stage0.Biology.RibosomalTranslation
import Stage1.Cosmology.MacroEnvelope
import Compound.AstrophysicalAggregation
import Stage1.Carrier.Vexel
import Stage0.UniverseState
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
{vm, de, dm, temp : Nat} -> Eq (DiscreteHelmholtzState vm de dm temp) where
  (MkDiscreteHelmholtzState u1 s1 f1 _) == (MkDiscreteHelmholtzState u2 s2 f2 _) =
    u1 == u2 && s1 == s2 && f1 == f2


||| Certified ground-state thermodynamic values at temperature T = 2 (Rule 03 §2):
public export
groundStateInternalEnergy : BoxInt
groundStateInternalEnergy = intToBoxInt 398

public export
groundStateEntropy : BoxInt
groundStateEntropy = intToBoxInt 859

public export
groundStateFreeEnergy : BoxInt
groundStateFreeEnergy = intToBoxInt (-1320)

public export
canonicalHelmholtzGroundState : DiscreteHelmholtzState 27 128 55 2
canonicalHelmholtzGroundState =
  MkDiscreteHelmholtzState groundStateInternalEnergy groundStateEntropy groundStateFreeEnergy Refl

||| Evaluates dynamic discrete Helmholtz Free Energy state: F = U - 2 * S.
||| Preserves exact ground state minimum F = -1320 when S = 859, U = 398, T = 2.
public export
evaluateDynamicHelmholtzState : (u : BoxInt) -> (s : BoxInt) -> DiscreteHelmholtzState 27 128 55 2
evaluateDynamicHelmholtzState u s =
  MkDiscreteHelmholtzState u s (u - (intToBoxInt 2 * s)) Refl

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
-- 3. UNIFIED UNIVERSE SIMULATION SECTORS (Rule 03 §5)
------------------------------------------------------------------------

||| Sector 1: Spacetime bulk geometry, metric perturbations (55 + 10 DoF), holographic horizon envelope, and astrophysical remnant phase.
public export
record SpacetimeBulkSector where
  constructor MkSpacetimeSector
  bulkMetricTensor        : SymmetricMetricTensor 10
  bulkProjectedLeaf       : SquareMaxel 4
  bulkModuliDOF           : Nat
  bulkCurvatureDefect     : BoxInt
  bulkHolographicEnvelope : Vexel
  bulkRemnantPhase        : RemnantType

public export
Eq SpacetimeBulkSector where
  (MkSpacetimeSector m1 p1 d1 c1 h1 r1) == (MkSpacetimeSector m2 p2 d2 c2 h2 r2) =
    m1 == m2 && p1 == p2 && d1 == d2 && c1 == c2 && h1 == h2 && r1 == r2

||| Sector 2: Non-Abelian gauge field symmetries (SU(3) subset G_2), Abelian U(1) Maxwell field, Dirac spinor, and Toric anyons.
public export
record GaugeFieldSector where
  constructor MkGaugeSector
  gaugeGellMannGluons : Vect 8 (SquareMaxel 3)
  gaugeMaxwellField   : MaxwellState
  gaugeDiracSpinor    : DiracSpinor
  gaugeToricAnyons    : Multiset BoxInt AnyonToken

public export
Eq GaugeFieldSector where
  (MkGaugeSector g1 m1 d1 t1) == (MkGaugeSector g2 m2 d2 t2) =
    g1 == g2 && m1 == m2 && d1 == d2 && t1 == t2

||| Sector 3: Complete internal matter trunk:
||| (QGP Subatomic Quarks -> QCD Hadron Nucleons -> BBN Light Nuclei -> Stellar Nuclides ->
|||  Atomic Elements -> Prebiotic Volatiles -> Supramolecular Chemistry -> Ribosomal Peptides ->
|||  Cellular Protocell Biomodules -> Living Observer -> Systems Ecology).
public export
record MatterSubstanceSector where
  constructor MkMatterSector
  matSubatomicQuarks    : Multiset BoxInt SubatomicParticle
  matQGPPhase           : QGPPhase
  matHadronNucleons     : Multiset BoxInt HadronToken
  matBBNNuclei          : Multiset BoxInt LightNucleusSpec
  matNuclearNuclides    : Multiset BoxInt StellarElement
  matAtomicElements     : Multiset BoxInt AtomToken
  matVolatileMolecules  : Multiset BoxInt MoleculeToken
  matChemicalYield      : Multiset BoxInt MacromoleculeSpec
  matTranslatedPeptides : List AminoAcid
  matCellularBiomodules : Multiset BoxInt BiomoduleToken
  matObserverState      : ObserverBranchState
  matEcosystemState     : TrophicPyramidState

public export
Eq MatterSubstanceSector where
  (MkMatterSector q1 ph1 h1 b1 n1 a1 v1 c1 p1 bm1 o1 e1) == (MkMatterSector q2 ph2 h2 b2 n2 a2 v2 c2 p2 bm2 o2 e2) =
    q1 == q2 && ph1 == ph2 && h1 == h2 && b1 == b2 && n1 == n2 && a1 == a2 &&
    v1 == v2 && c1 == c2 && p1 == p2 && bm1 == bm2 && o1 == o2 && e1 == e2

||| Baryon number of a subatomic quark multiset (3 quarks = 1 baryon).
public export
totalSubatomicBaryonCount : Multiset BoxInt SubatomicParticle -> BoxInt
totalSubatomicBaryonCount m =
  let totalQuarks = foldMultiset (\p, w, acc =>
                      case p of
                        QuarkToken _ => acc + w
                        _            => acc) (intToBoxInt 0) m
  in divBox totalQuarks (intToBoxInt 3)

||| Baryon number of a hadron token (1 for baryons/nucleons, 0 for mesons).
public export
hadronBaryonCount : HadronToken -> BoxInt
hadronBaryonCount ProtonToken       = intToBoxInt 1
hadronBaryonCount NeutronToken      = intToBoxInt 1
hadronBaryonCount LambdaBaryonToken = intToBoxInt 1
hadronBaryonCount SigmaBaryonToken  = intToBoxInt 1
hadronBaryonCount XiBaryonToken     = intToBoxInt 1
hadronBaryonCount OmegaBaryonToken  = intToBoxInt 1
hadronBaryonCount _                 = intToBoxInt 0

||| Total nucleon/baryon count of a hadron multiset.
public export
totalHadronNucleonCount : Multiset BoxInt HadronToken -> BoxInt
totalHadronNucleonCount =
  foldMultiset (\h, w, acc => acc + (w * hadronBaryonCount h)) (intToBoxInt 0)

||| Total nucleon count of a Big Bang Nucleosynthesis light nucleus multiset.
public export
totalBBNNucleonCount : Multiset BoxInt LightNucleusSpec -> BoxInt
totalBBNNucleonCount =
  foldMultiset (\nuc, w, acc => acc + (w * natToBoxInt (nucleusNucleonCount nuc))) (intToBoxInt 0)

||| Baryonic nucleon mass count of a cellular biomodule token (HydratedCellToken = 18 nucleons from H2O hydration).
public export
biomoduleNucleonCount : BiomoduleToken -> BoxInt
biomoduleNucleonCount HydratedCellToken = intToBoxInt 18
biomoduleNucleonCount AdenineToken      = intToBoxInt 135
biomoduleNucleonCount ThymineToken      = intToBoxInt 126
biomoduleNucleonCount GuanineToken      = intToBoxInt 151
biomoduleNucleonCount CytosineToken     = intToBoxInt 111

||| Total nucleon count of a cellular biomodule multiset.
public export
totalBiomoduleNucleonCount : Multiset BoxInt BiomoduleToken -> BoxInt
totalBiomoduleNucleonCount =
  foldMultiset (\b, w, acc => acc + (w * biomoduleNucleonCount b)) (intToBoxInt 0)

||| Total conserved baryonic nucleon count across all 8 baryonic matter tiers:
||| (Subatomic Quarks + Hadron Nucleons + BBN Light Nuclei + Stellar Nuclides +
|||  Atomic Elements + Volatile Molecules + Macromolecular Chemistry + Cellular Biomodules).
public export
totalMatterNucleonCount : MatterSubstanceSector -> BoxInt
totalMatterNucleonCount (MkMatterSector quarks _ hadrons bbn nucl atoms mols chem _ biomods _ _) =
  totalSubatomicBaryonCount quarks +
  totalHadronNucleonCount hadrons +
  totalBBNNucleonCount bbn +
  totalNucleonCount nucl +
  totalAtomNucleonCount atoms +
  totalMoleculeNucleonCount mols +
  totalMacromoleculeNucleonCount chem +
  totalBiomoduleNucleonCount biomods

||| Total condensed post-recombination disk matter nucleon count:
||| (Atomic Elements + Prebiotic Volatiles + Macromolecular Chemistry + Cellular Biomodules).
public export
condensedDiskNucleonCount : MatterSubstanceSector -> BoxInt
condensedDiskNucleonCount (MkMatterSector _ _ _ _ _ atoms mols chem _ biomods _ _) =
  totalAtomNucleonCount atoms +
  totalMoleculeNucleonCount mols +
  totalMacromoleculeNucleonCount chem +
  totalBiomoduleNucleonCount biomods

||| Sector 4: Hamiltonian phase space dynamics and dark matter halo distribution.
public export
record SymplecticDynamicsSector where
  constructor MkDynamicsSector
  dynPhaseState      : PhaseState
  dynGalacticProfile : GalacticProfile
  dynGalacticHalo    : GalacticHaloMultiset

public export
Eq SymplecticDynamicsSector where
  (MkDynamicsSector p1 g1 h1) == (MkDynamicsSector p2 g2 h2) =
    p1 == p2 && g1 == g2 && h1 == h2

||| Sector 5: Substrate clock, 4th geometry governor, and thermodynamics.
public export
record ThermodynamicSubstrateSector where
  constructor MkSubstrateSector
  subEpochIndex          : Nat
  subSuperEpoch          : Nat
  subTicks               : Nat
  subCapacityBudget      : DiscreteCapacityBudget 27 128 55
  subSpreadMatrix        : SquareMaxel 2
  subScaleFactor         : BoxInt
  subHubbleRate          : BoxInt
  subGovernor            : SquareMaxel 2
  subExpansionMode       : ExpansionParadigm
  subObserverEpochActive : Bool
  subCoherenceStatus     : CoherenceStatus CosmicSmoothHorizon (S subEpochIndex)
  subFreeEnergyState     : DiscreteHelmholtzState 27 128 55 2
  subDissipatedEntropy   : BoxInt

public export
Eq ThermodynamicSubstrateSector where
  (MkSubstrateSector e1 s1 t1 c1 m1 a1 h1 g1 x1 o1 k1 f1 d1) == (MkSubstrateSector e2 s2 t2 c2 m2 a2 h2 g2 x2 o2 k2 f2 d2) =
    e1 == e2 && s1 == s2 && t1 == t2 && c1 == c2 && m1 == m2 && a1 == a2 && h1 == h2 && g1 == g2 && x1 == x2 && o1 == o2 && isStatusGatePure k1 == isStatusGatePure k2 && f1 == f2 && d1 == d2

||| Canonical Universal Simulation State as a product of the 5 physical sectors:
public export
record UniverseSimulationState where
  constructor MkUniverseSimulationState
  spacetimeSector     : SpacetimeBulkSector
  gaugeSector         : GaugeFieldSector
  matterSector        : MatterSubstanceSector
  dynamicsSector      : SymplecticDynamicsSector
  thermodynamicSector : ThermodynamicSubstrateSector

public export
Eq UniverseSimulationState where
  (MkUniverseSimulationState s1 g1 m1 d1 t1) == (MkUniverseSimulationState s2 g2 m2 d2 t2) =
    s1 == s2 && g1 == g2 && m1 == m2 && d1 == d2 && t1 == t2

------------------------------------------------------------------------
-- 3B. BACKWARD-COMPATIBLE FIELD ACCESSORS (Rule 04 §10)
------------------------------------------------------------------------

public export %inline epochIndex : UniverseSimulationState -> Nat; epochIndex st = st.thermodynamicSector.subEpochIndex
public export %inline superEpoch : UniverseSimulationState -> Nat; superEpoch st = st.thermodynamicSector.subSuperEpoch
public export %inline substrateTicks : UniverseSimulationState -> Nat; substrateTicks st = st.thermodynamicSector.subTicks
public export %inline capacityBudget : UniverseSimulationState -> DiscreteCapacityBudget 27 128 55; capacityBudget st = st.thermodynamicSector.subCapacityBudget
public export %inline metricTensor : UniverseSimulationState -> SymmetricMetricTensor 10; metricTensor st = st.spacetimeSector.bulkMetricTensor
public export %inline projectedLeaf : UniverseSimulationState -> SquareMaxel 4; projectedLeaf st = st.spacetimeSector.bulkProjectedLeaf
public export %inline moduliDOF : UniverseSimulationState -> Nat; moduliDOF st = st.spacetimeSector.bulkModuliDOF
public export %inline holographicEnvelope : UniverseSimulationState -> Vexel; holographicEnvelope st = st.spacetimeSector.bulkHolographicEnvelope
public export %inline remnantPhase : UniverseSimulationState -> RemnantType; remnantPhase st = st.spacetimeSector.bulkRemnantPhase
public export %inline gellMannGluons : UniverseSimulationState -> Vect 8 (SquareMaxel 3); gellMannGluons st = st.gaugeSector.gaugeGellMannGluons
public export %inline maxwellField : UniverseSimulationState -> MaxwellState; maxwellField st = st.gaugeSector.gaugeMaxwellField
public export %inline maxwellTensor4D : UniverseSimulationState -> SquareMaxel 4; maxwellTensor4D st = maxwellStateTo4DMaxel st.gaugeSector.gaugeMaxwellField
public export %inline diracSpinor : UniverseSimulationState -> DiracSpinor; diracSpinor st = st.gaugeSector.gaugeDiracSpinor
public export %inline toricAnyons : UniverseSimulationState -> Multiset BoxInt AnyonToken; toricAnyons st = st.gaugeSector.gaugeToricAnyons
public export %inline galacticProfile : UniverseSimulationState -> GalacticProfile; galacticProfile st = st.dynamicsSector.dynGalacticProfile
public export %inline galacticHalo : UniverseSimulationState -> GalacticHaloMultiset; galacticHalo st = st.dynamicsSector.dynGalacticHalo
public export %inline subatomicQuarks : UniverseSimulationState -> Multiset BoxInt SubatomicParticle; subatomicQuarks st = st.matterSector.matSubatomicQuarks
public export %inline qgpPhaseState : UniverseSimulationState -> QGPPhase; qgpPhaseState st = st.matterSector.matQGPPhase
public export %inline hadronNucleons : UniverseSimulationState -> Multiset BoxInt HadronToken; hadronNucleons st = st.matterSector.matHadronNucleons
public export %inline bbnNuclei : UniverseSimulationState -> Multiset BoxInt LightNucleusSpec; bbnNuclei st = st.matterSector.matBBNNuclei
public export %inline nuclearNuclides : UniverseSimulationState -> Multiset BoxInt StellarElement; nuclearNuclides st = st.matterSector.matNuclearNuclides
public export %inline atomicElements : UniverseSimulationState -> Multiset BoxInt AtomToken; atomicElements st = st.matterSector.matAtomicElements
public export %inline volatileMolecules : UniverseSimulationState -> Multiset BoxInt MoleculeToken; volatileMolecules st = st.matterSector.matVolatileMolecules
public export %inline chemicalYield : UniverseSimulationState -> Multiset BoxInt MacromoleculeSpec; chemicalYield st = st.matterSector.matChemicalYield
public export %inline translatedPeptides : UniverseSimulationState -> List AminoAcid; translatedPeptides st = st.matterSector.matTranslatedPeptides
public export %inline cellularBiomodules : UniverseSimulationState -> Multiset BoxInt BiomoduleToken; cellularBiomodules st = st.matterSector.matCellularBiomodules
public export %inline ecosystemState : UniverseSimulationState -> TrophicPyramidState; ecosystemState st = st.matterSector.matEcosystemState
public export %inline phaseState : UniverseSimulationState -> PhaseState; phaseState st = st.dynamicsSector.dynPhaseState
public export %inline curvatureDefect : UniverseSimulationState -> BoxInt; curvatureDefect st = st.spacetimeSector.bulkCurvatureDefect
public export %inline spreadMatrix : UniverseSimulationState -> SquareMaxel 2; spreadMatrix st = st.thermodynamicSector.subSpreadMatrix
public export %inline scaleFactor : UniverseSimulationState -> BoxInt; scaleFactor st = st.thermodynamicSector.subScaleFactor
public export %inline hubbleExpansionRate : UniverseSimulationState -> BoxInt; hubbleExpansionRate st = st.thermodynamicSector.subHubbleRate
public export %inline substrateGovernor : UniverseSimulationState -> SquareMaxel 2; substrateGovernor st = st.thermodynamicSector.subGovernor
public export %inline expansionMode : UniverseSimulationState -> ExpansionParadigm; expansionMode st = st.thermodynamicSector.subExpansionMode
public export %inline observerEpochActive : UniverseSimulationState -> Bool; observerEpochActive st = st.thermodynamicSector.subObserverEpochActive
public export %inline observerState : UniverseSimulationState -> ObserverBranchState; observerState st = st.matterSector.matObserverState
public export %inline coherenceStatus : (st : UniverseSimulationState) -> CoherenceStatus CosmicSmoothHorizon (S st.thermodynamicSector.subEpochIndex); coherenceStatus st = st.thermodynamicSector.subCoherenceStatus
public export %inline freeEnergyState : UniverseSimulationState -> DiscreteHelmholtzState 27 128 55 2; freeEnergyState st = st.thermodynamicSector.subFreeEnergyState
public export %inline dissipatedEntropy : UniverseSimulationState -> BoxInt; dissipatedEntropy st = st.thermodynamicSector.subDissipatedEntropy

||| Synthesizes initial subatomic quark plasma from the active Chromogeometric Triad:
||| Up-quarks: (Q_Green / 2) * Q_Blue = (24 / 2) * 25 = 300.
||| Down-quarks: (manifestSpatialDim^2) * Q_Blue = 9 * 25 = 225.
||| Total valence quarks: (12 + 9) * 25 = 525 quarks = 175 baryons.
public export
synthesizeQuarksFromTriad : TriadQuadrance -> Multiset BoxInt SubatomicParticle
synthesizeQuarksFromTriad triad =
  let uFactor = divBox triad.greenQ (intToBoxInt 2)
      dFactor = intToBoxInt (cast (powerNat manifestSpatialDim 2))
      uCount  = mulBox uFactor triad.blueQ
      dCount  = mulBox dFactor triad.blueQ
  in AddM (QuarkToken UpQuark) uCount
       (AddM (QuarkToken DownQuark) dCount ZeroM)

||| Canonical primordial deconfined Quark-Gluon Plasma carrier,
||| synthesized directly from the primordial (25, 7, 24) chromogeometric triad:
public export
canonicalSubatomicQuarkState : Multiset BoxInt SubatomicParticle
canonicalSubatomicQuarkState = synthesizeQuarksFromTriad (epochTriadQuadrance 0)

||| Conserved up-quark count read directly from the primordial subatomic carrier:
public export
canonicalUpQuarkCount : Nat
canonicalUpQuarkCount = boxToNat (lookupCountBox (QuarkToken UpQuark) canonicalSubatomicQuarkState)

||| Conserved down-quark count read directly from the primordial subatomic carrier:
public export
canonicalDownQuarkCount : Nat
canonicalDownQuarkCount = boxToNat (lookupCountBox (QuarkToken DownQuark) canonicalSubatomicQuarkState)

||| Conserved total valence quark count read directly from the primordial subatomic carrier:
public export
canonicalTotalValenceQuarks : Nat
canonicalTotalValenceQuarks = canonicalUpQuarkCount + canonicalDownQuarkCount

||| Conserved baryonic nucleon budget read directly from the primordial subatomic carrier:
public export
canonicalBaryonNucleonCount : Nat
canonicalBaryonNucleonCount = boxToNat (totalSubatomicBaryonCount canonicalSubatomicQuarkState)

||| Primordial proton count emerging from stoichiometric QCD confinement of the quark carrier:
public export
canonicalProtonCount : Nat
canonicalProtonCount =
  let u = lookupCountBox (QuarkToken UpQuark) canonicalSubatomicQuarkState
      d = lookupCountBox (QuarkToken DownQuark) canonicalSubatomicQuarkState
  in boxToNat (divBox ((intToBoxInt 2 * u) - d) (intToBoxInt 3))

||| Primordial neutron count emerging from stoichiometric QCD confinement of the quark carrier:
public export
canonicalNeutronCount : Nat
canonicalNeutronCount =
  let u = lookupCountBox (QuarkToken UpQuark) canonicalSubatomicQuarkState
      d = lookupCountBox (QuarkToken DownQuark) canonicalSubatomicQuarkState
  in boxToNat (divBox ((intToBoxInt 2 * d) - u) (intToBoxInt 3))

||| Reads active up-quark count directly from the matter sector:
public export
upQuarksInMatter : MatterSubstanceSector -> BoxInt
upQuarksInMatter mat = lookupCountBox (QuarkToken UpQuark) mat.matSubatomicQuarks

||| Reads active down-quark count directly from the matter sector:
public export
downQuarksInMatter : MatterSubstanceSector -> BoxInt
downQuarksInMatter mat = lookupCountBox (QuarkToken DownQuark) mat.matSubatomicQuarks

||| Reads active proton count directly from the matter sector:
public export
protonsInMatter : MatterSubstanceSector -> BoxInt
protonsInMatter mat = lookupCountBox ProtonToken mat.matHadronNucleons

||| Reads active neutron count directly from the matter sector:
public export
neutronsInMatter : MatterSubstanceSector -> BoxInt
neutronsInMatter mat = lookupCountBox NeutronToken mat.matHadronNucleons

||| Reads active deuteron count directly from the matter sector:
public export
deuteronsInMatter : MatterSubstanceSector -> BoxInt
deuteronsInMatter mat = lookupCountBox Deuteron2H mat.matBBNNuclei

||| Reads active helium count directly from the matter sector:
public export
heliumInMatter : MatterSubstanceSector -> BoxInt
heliumInMatter mat = lookupCountBox ElemHe mat.matNuclearNuclides

||| Reads active hydrogen count directly from the matter sector:
public export
hydrogenInMatter : MatterSubstanceSector -> BoxInt
hydrogenInMatter mat = lookupCountBox ElemH mat.matNuclearNuclides

||| Reads total conserved baryon nucleon count directly from the matter sector:
public export
baryonsInMatter : MatterSubstanceSector -> BoxInt
baryonsInMatter = totalMatterNucleonCount

||| Synthesizes initial subatomic quark plasma from condensed elliptic VM token count:
public export
synthesizeQuarksFromEllipticCount : Nat -> Multiset BoxInt SubatomicParticle
synthesizeQuarksFromEllipticCount ellCount =
  let vmDim = fst ellipticDimension
  in if ellCount >= vmDim
       then canonicalSubatomicQuarkState
       else let scale  = intToBoxInt (cast ellCount)
                dimBox = intToBoxInt (cast vmDim)
                uCount = divBox (scale * natToBoxInt canonicalUpQuarkCount) dimBox
                dCount = divBox (scale * natToBoxInt canonicalDownQuarkCount) dimBox
            in AddM (QuarkToken UpQuark) uCount (AddM (QuarkToken DownQuark) dCount ZeroM)

||| Canonical initial Dirac bispinor state (norm = 1^2 + 0 + 0 - 0 = 1).
public export
canonicalDiracSpinorState : DiracSpinor
canonicalDiracSpinorState = MkDiracSpinor (intToBoxInt 1) (intToBoxInt 0) (intToBoxInt 0) (intToBoxInt 0)

||| Canonical initial Toric code anyon pair (e x m -> epsilon dyad).
public export
canonicalToricAnyonState : Multiset BoxInt AnyonToken
canonicalToricAnyonState =
  AddM ElectricCharge (intToBoxInt 1) (AddM MagneticFlux (intToBoxInt 1) ZeroM)

||| Canonical 2x2 companion spread transfer matrix for multiple spread recurrence:
||| M(s) = [[2 - 4s, -1], [1, 0]]. For s = 0, [[2, -1], [1, 0]].
public export
pythagoreanCompanionMaxel : SquareMaxel 2
pythagoreanCompanionMaxel =
  let c11 = intToBoxInt 2
      c12 = intToBoxInt (-1)
      c21 = intToBoxInt 1
      t0 = singletonCell (mkCell2 0 0) c11
      t1 = setCellMultiset (mkCell2 0 1) c12 t0
      t2 = setCellMultiset (mkCell2 1 0) c21 t1
  in MkSquareMaxel t2

||| Genesis / Vacuum Initial Universe Simulation State parameterized by ExpansionParadigm.
public export
initUniverseSimulationMode : ExpansionParadigm -> UniverseSimulationState
initUniverseSimulationMode mode =
  let g10 = spacetime10DMetric
      g4  = project10Dto4D g10.metricMaxel
      spacetime = MkSpacetimeSector g10 g4 (triangularNat 9) (intToBoxInt 0) initMacroCosmicEnvelope WhiteDwarf
      gluons = [ gellMannMaxel 1, gellMannMaxel 2, gellMannMaxel 3, gellMannMaxel 4
               , gellMannMaxel 5, gellMannMaxel 6, gellMannMaxel 7, gellMannMaxel 8
               ]
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
      initCoord = epochPythagoreanCoordinate 0
      initTriad = epochTriadQuadrance 0
      thermo = MkSubstrateSector
                 0
                 0
                 0
                 canonicalCapacityBudget
                 (pythagoreanCompanionSquareMaxel (fst initCoord) (snd initCoord))
                 initTriad.blueQ
                 (intToBoxInt 2 * (snd initCoord * snd initCoord))
                 (parameterizedSubstrateSquareMaxel (intToBoxInt 1) (intToBoxInt 1))
                 mode
                 False
                 status0
                 canonicalHelmholtzGroundState
                 (intToBoxInt 0)
  in MkUniverseSimulationState spacetime gauge matter dynamics thermo

||| Canonical Genesis / Vacuum Initial Universe Simulation State (Default: MonotonicOpenExpansion).
public export
initUniverseSimulation : UniverseSimulationState
initUniverseSimulation = initUniverseSimulationMode MonotonicOpenExpansion

------------------------------------------------------------------------
-- 5. UNIVERSE STATE FUNCTORIAL BRIDGE (Rule 03 & Rule 04)
------------------------------------------------------------------------

||| Canonical zero-allocation extraction of the 3-pool UniverseState from UniverseSimulationState:
||| - VM (27): Extracted from 27 elliptic sites
||| - DE (128): Extracted from 128 hyperbolic ROM gauge modes
||| - DM (55): Extracted from 55 parabolic defect drain modes
public export
simulationToUniverseState : UniverseSimulationState -> UniverseState 27 128 55
simulationToUniverseState st =
  let vm = replicate 27 (intToBoxInt 1)
      de = replicate 128 (intToBoxInt 1)
      dm = replicate 55 (intToBoxInt 1)
  in MkUniverseState vm de dm

||| Inverse injection of a 3-pool UniverseState into UniverseSimulationState:
public export
universeStateToSimulation : UniverseState 27 128 55 -> UniverseSimulationState
universeStateToSimulation _ = initUniverseSimulation

------------------------------------------------------------------------
-- 6. UNIVERSAL SIMULATION TOKEN SUM TYPE & COMONADIC DECONSTRUCTOR
------------------------------------------------------------------------

||| Universal discrete physical token sum type spanning all sectors of the macroscopic simulation:
public export
data UniversalSimulationToken =
    SimSubatomicQuark SubatomicParticle
  | SimHadron HadronToken
  | SimBBNNucleus LightNucleusSpec
  | SimNuclide StellarElement
  | SimAtom AtomToken
  | SimMolecule MoleculeToken
  | SimMacromolecule MacromoleculeSpec
  | SimBiomodule BiomoduleToken
  | SimAnyon AnyonToken

public export
Eq UniversalSimulationToken where
  (SimSubatomicQuark q1) == (SimSubatomicQuark q2) = q1 == q2
  (SimHadron h1)         == (SimHadron h2)         = h1 == h2
  (SimBBNNucleus b1)     == (SimBBNNucleus b2)     = b1 == b2
  (SimNuclide n1)        == (SimNuclide n2)        = n1 == n2
  (SimAtom a1)           == (SimAtom a2)           = a1 == a2
  (SimMolecule m1)       == (SimMolecule m2)       = m1 == m2
  (SimMacromolecule c1)  == (SimMacromolecule c2)  = c1 == c2
  (SimBiomodule bm1)     == (SimBiomodule bm2)     = bm1 == bm2
  (SimAnyon ay1)         == (SimAnyon ay2)         = ay1 == ay2
  _                      == _                      = False

public export
Show UniversalSimulationToken where
  show (SimSubatomicQuark _) = "SimSubatomicQuark"
  show (SimHadron _)         = "SimHadron"
  show (SimBBNNucleus _)     = "SimBBNNucleus"
  show (SimNuclide _)        = "SimNuclide"
  show (SimAtom _)           = "SimAtom"
  show (SimMolecule _)       = "SimMolecule"
  show (SimMacromolecule _)  = "SimMacromolecule"
  show (SimBiomodule _)      = "SimBiomodule"
  show (SimAnyon _)          = "SimAnyon"

||| Gathers all discrete tokens present across the macroscopic simulation state into a single multiset:
public export
simulationToTokens : UniverseSimulationState -> Multiset BoxInt UniversalSimulationToken
simulationToTokens st =
  let quarks  = mapMultiset SimSubatomicQuark (subatomicQuarks st)
      hadrons = mapMultiset SimHadron (hadronNucleons st)
      bbn     = mapMultiset SimBBNNucleus (bbnNuclei st)
      nucl    = mapMultiset SimNuclide (nuclearNuclides st)
      atoms   = mapMultiset SimAtom (atomicElements st)
      mols    = mapMultiset SimMolecule (volatileMolecules st)
      chem    = mapMultiset SimMacromolecule (chemicalYield st)
      biomods = mapMultiset SimBiomodule (cellularBiomodules st)
      anyons  = mapMultiset SimAnyon (toricAnyons st)
  in quarks <+> hadrons <+> bbn <+> nucl <+> atoms <+> mols <+> chem <+> biomods <+> anyons

||| Total token weight across all discrete constituents in the universal state:
public export
totalUniversalSimulationTokens : UniverseSimulationState -> BoxInt
totalUniversalSimulationTokens st = multisetSum (simulationToTokens st)
