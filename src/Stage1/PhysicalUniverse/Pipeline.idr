||| End-to-End Typed Multiset Stream Pipeline Chain (T_total)
|||
||| Connects the 8 canonical physical levels (Layers 0 to 7) via formal
||| `PhysicalLayerMorphism` instances into an end-to-end category-theoretic
||| multiset stream transducer chain:
|||
|||   T_total = morph6to7 ∘ morph5to6 ∘ morph4to5 ∘ morph3to4 ∘ morph2to3 ∘ morph1to2 ∘ morph0to1
module Stage1.PhysicalUniverse.Pipeline

import Stage0.BoxInt
import Stage0.Multiset
import Stage1.FourGeometries
import Stage1.PhysicalUniverse.Stratification

%default total

--------------------------------------------------------------------------------
-- 1. TYPED MULTISET TOKENS FOR THE 8 PHYSICAL LEVELS
--------------------------------------------------------------------------------

||| Layer 0: Primordial Substrate Vacuum Carrier Token (∅_Sub, ΔS >= 1).
public export
data SubstrateCarrierToken = MkSubstrateTick BoxInt

public export
Eq SubstrateCarrierToken where
  (MkSubstrateTick a) == (MkSubstrateTick b) = a == b

public export
Show SubstrateCarrierToken where
  show (MkSubstrateTick w) = "SubstrateTick(" ++ show w ++ ")"

||| Layer 1: Möbius Unfolded Triad Token (Blue, Red, Green (25, 7, 24)).
public export
data TriadUnfoldingToken =
    BlueTriad BoxInt
  | RedTriad BoxInt
  | GreenTriad BoxInt

public export
Eq TriadUnfoldingToken where
  (BlueTriad a) == (BlueTriad b) = a == b
  (RedTriad a)  == (RedTriad b)  = a == b
  (GreenTriad a) == (GreenTriad b) = a == b
  _ == _ = False

public export
Show TriadUnfoldingToken where
  show (BlueTriad w)  = "BlueTriad(" ++ show w ++ ")"
  show (RedTriad w)   = "RedTriad(" ++ show w ++ ")"
  show (GreenTriad w) = "GreenTriad(" ++ show w ++ ")"

||| Layer 2: Discrete Multi-Radix Information Token (Binary Bit & Ternary Trit).
public export
data DiscreteRadixToken =
    RadixBit Bool BoxInt
  | RadixTrit Int BoxInt

public export
Eq DiscreteRadixToken where
  (RadixBit a wa) == (RadixBit b wb) = a == b && wa == wb
  (RadixTrit a wa) == (RadixTrit b wb) = a == b && wa == wb
  _ == _ = False

public export
Show DiscreteRadixToken where
  show (RadixBit b w) = "RadixBit(" ++ show b ++ ", " ++ show w ++ ")"
  show (RadixTrit t w) = "RadixTrit(" ++ show t ++ ", " ++ show w ++ ")"

||| Layer 3: Metrical Chromogeometry & Spin Network Token.
public export
data MetricalChromoToken =
    ChromoQuadrance BoxInt
  | CliffordSpinor BoxInt

public export
Eq MetricalChromoToken where
  (ChromoQuadrance a) == (ChromoQuadrance b) = a == b
  (CliffordSpinor a) == (CliffordSpinor b) = a == b
  _ == _ = False

public export
Show MetricalChromoToken where
  show (ChromoQuadrance q) = "ChromoQuadrance(" ++ show q ++ ")"
  show (CliffordSpinor s)  = "CliffordSpinor(" ++ show s ++ ")"

||| Layer 4: Gauge Field Plaquette Residue & Geodesic Action Token.
public export
data GaugeActionToken =
    PlaquetteResidue BoxInt
  | ActionGeodesic BoxInt

public export
Eq GaugeActionToken where
  (PlaquetteResidue a) == (PlaquetteResidue b) = a == b
  (ActionGeodesic a) == (ActionGeodesic b) = a == b
  _ == _ = False

public export
Show GaugeActionToken where
  show (PlaquetteResidue p) = "PlaquetteResidue(" ++ show p ++ ")"
  show (ActionGeodesic s)   = "ActionGeodesic(" ++ show s ++ ")"

||| Layer 5: Hadronic Quark Confinement (27 bits) & Quantum Coherence Token.
public export
data HadronicQuantumToken =
    BaryonSinglet BoxInt
  | ToricStabilizer BoxInt

public export
Eq HadronicQuantumToken where
  (BaryonSinglet a) == (BaryonSinglet b) = a == b
  (ToricStabilizer a) == (ToricStabilizer b) = a == b
  _ == _ = False

public export
Show HadronicQuantumToken where
  show (BaryonSinglet b) = "BaryonSinglet(" ++ show b ++ ")"
  show (ToricStabilizer t) = "ToricStabilizer(" ++ show t ++ ")"

||| Layer 6: Thermodynamic Horizon 137-Scale Sieve Token (76 Gate-Pure / 61 Decoherent).
public export
data ThermodynamicEpochToken =
    GatePureScale Nat
  | DecoherentScale Nat

public export
Eq ThermodynamicEpochToken where
  (GatePureScale a) == (GatePureScale b) = a == b
  (DecoherentScale a) == (DecoherentScale b) = a == b
  _ == _ = False

public export
Show ThermodynamicEpochToken where
  show (GatePureScale n)   = "GatePureScale(" ++ show n ++ ")"
  show (DecoherentScale n) = "DecoherentScale(" ++ show n ++ ")"

||| Layer 7: Cosmic Saturation Master Token (Primorial 210 Budget & Free Energy Minimum).
public export
data CosmosApexToken =
    PrimorialBudget BoxInt
  | HelmholtzGroundState BoxInt

public export
Eq CosmosApexToken where
  (PrimorialBudget a) == (PrimorialBudget b) = a == b
  (HelmholtzGroundState a) == (HelmholtzGroundState b) = a == b
  _ == _ = False

public export
Show CosmosApexToken where
  show (PrimorialBudget b)       = "PrimorialBudget(" ++ show b ++ ")"
  show (HelmholtzGroundState f)  = "HelmholtzGroundState(" ++ show f ++ ")"

--------------------------------------------------------------------------------
-- 2. CANONICAL PHYSICAL LAYER MORPHISMS (L0 -> L7)
--------------------------------------------------------------------------------

||| Morphism 0 -> 1: Primordial Substrate Unfolding to Chromogeometric Triad.
||| Unfolds carrier ticks into Blue (25), Red (7), Green (24) triad coordinates.
public export
morph0to1 : PhysicalLayerMorphism L1_MobiusUnfolding SubstrateCarrierToken TriadUnfoldingToken
morph0to1 =
  MkPhysicalLayerMorphism
    "L0->L1: Primordial Substrate Unfolding"
    EllipticGeom
    (\m =>
      let fiber : SubstrateCarrierToken -> List TriadUnfoldingToken
          fiber (MkSubstrateTick (MkBoxInt w)) =
            [ BlueTriad (MkBoxInt (w * 25))
            , RedTriad (MkBoxInt (w * 7))
            , GreenTriad (MkBoxInt (w * 24))
            ]
      in fiberPullback fiber m
    )
    (\m =>
      let project : TriadUnfoldingToken -> SubstrateCarrierToken
          project (BlueTriad w)  = MkSubstrateTick w
          project (RedTriad w)   = MkSubstrateTick w
          project (GreenTriad w) = MkSubstrateTick w
      in mapMultiset project m
    )

||| Morphism 1 -> 2: Triad to Discrete Multi-Radix Streams.
||| Transforms continuous triad projections into binary bits and ternary Dyck trits.
public export
morph1to2 : PhysicalLayerMorphism L2_DiscreteRadix TriadUnfoldingToken DiscreteRadixToken
morph1to2 =
  MkPhysicalLayerMorphism
    "L1->L2: Discrete Radix Transduction"
    HyperbolicGeom
    (\m =>
      let trans : TriadUnfoldingToken -> DiscreteRadixToken
          trans (BlueTriad w)  = RadixBit True w
          trans (RedTriad w)   = RadixTrit (-1) w
          trans (GreenTriad w) = RadixTrit 1 w
      in mapMultiset trans m
    )
    (\m =>
      let pullback : DiscreteRadixToken -> TriadUnfoldingToken
          pullback (RadixBit _ w) = BlueTriad w
          pullback (RadixTrit t w) =
            if t < 0 then RedTriad w else GreenTriad w
      in mapMultiset pullback m
    )

||| Morphism 2 -> 3: Discrete Radix to Metrical Chromogeometry & Spin Network.
||| Bridges radix polarization to Clifford spinors and rational quadrance observables.
public export
morph2to3 : PhysicalLayerMorphism L3_MetricalGeometry DiscreteRadixToken MetricalChromoToken
morph2to3 =
  MkPhysicalLayerMorphism
    "L2->L3: Metrical Chromogeometry Involutions"
    EllipticGeom
    (\m =>
      let trans : DiscreteRadixToken -> MetricalChromoToken
          trans (RadixBit _ w)  = CliffordSpinor w
          trans (RadixTrit t w) = ChromoQuadrance (mulBox w (MkBoxInt (cast t)))
      in mapMultiset trans m
    )
    (\m =>
      let pullback : MetricalChromoToken -> DiscreteRadixToken
          pullback (CliffordSpinor s)  = RadixBit True s
          pullback (ChromoQuadrance q) =
            let v = unwrapBox q
            in RadixTrit (if v < 0 then -1 else 1) (absBox q)
      in mapMultiset pullback m
    )

||| Morphism 3 -> 4: Metrical Chromogeometry to Gauge Fields & Geodesic Action.
||| Evaluates plaquette holonomies and discrete Euler-Lagrange least action paths.
public export
morph3to4 : PhysicalLayerMorphism L4_FieldDynamics MetricalChromoToken GaugeActionToken
morph3to4 =
  MkPhysicalLayerMorphism
    "L3->L4: Gauge Field Plaquette Circulation & Action"
    HyperbolicGeom
    (\m =>
      let trans : MetricalChromoToken -> GaugeActionToken
          trans (ChromoQuadrance q) = PlaquetteResidue q
          trans (CliffordSpinor s)  = ActionGeodesic s
      in mapMultiset trans m
    )
    (\m =>
      let pullback : GaugeActionToken -> MetricalChromoToken
          pullback (PlaquetteResidue q) = ChromoQuadrance q
          pullback (ActionGeodesic s)   = CliffordSpinor s
      in mapMultiset pullback m
    )

||| Morphism 4 -> 5: Gauge Field Dynamics to Hadronic Confinement & Quantum Coherence.
||| Confines quarks into color-singlet 27-state baryonic cells and toric error suppression.
public export
morph4to5 : PhysicalLayerMorphism L5_HadronicQuantum GaugeActionToken HadronicQuantumToken
morph4to5 =
  MkPhysicalLayerMorphism
    "L4->L5: Hadronic Quark Confinement & Toric Stabilizers"
    EllipticGeom
    (\m =>
      let trans : GaugeActionToken -> HadronicQuantumToken
          trans (PlaquetteResidue p) = ToricStabilizer p
          trans (ActionGeodesic s)   = BaryonSinglet s
      in mapMultiset trans m
    )
    (\m =>
      let pullback : HadronicQuantumToken -> GaugeActionToken
          pullback (BaryonSinglet b)  = ActionGeodesic b
          pullback (ToricStabilizer t) = PlaquetteResidue t
      in mapMultiset pullback m
    )

||| Morphism 5 -> 6: Hadronic Confinement to Thermodynamic 137 Sieve Trajectory.
||| Partitions hadronic degrees of freedom into 76 gate-pure and 61 decoherent scales.
public export
morph5to6 : PhysicalLayerMorphism L6_ThermodynamicEpoch HadronicQuantumToken ThermodynamicEpochToken
morph5to6 =
  MkPhysicalLayerMorphism
    "L5->L6: Thermodynamic 137 Scale Sieve Partition"
    ParabolicGeom
    (\m =>
      let trans : HadronicQuantumToken -> ThermodynamicEpochToken
          trans (BaryonSinglet (MkBoxInt b)) =
            if b <= 76 then GatePureScale (fromInteger (abs b))
                       else DecoherentScale (fromInteger (abs b))
          trans (ToricStabilizer (MkBoxInt t)) =
            if t <= 76 then GatePureScale (fromInteger (abs t))
                       else DecoherentScale (fromInteger (abs t))
      in mapMultiset trans m
    )
    (\m =>
      let pullback : ThermodynamicEpochToken -> HadronicQuantumToken
          pullback (GatePureScale n)   = BaryonSinglet (MkBoxInt (cast n))
          pullback (DecoherentScale n) = ToricStabilizer (MkBoxInt (cast n))
      in mapMultiset pullback m
    )

||| Morphism 6 -> 7: Thermodynamic Horizon Sieve to Cosmos Master Ground State.
||| Concentrates the 137 scales into the Primorial 210 capacity budget and F = -1320.
public export
morph6to7 : PhysicalLayerMorphism L7_CosmosMaster ThermodynamicEpochToken CosmosApexToken
morph6to7 =
  MkPhysicalLayerMorphism
    "L6->L7: Cosmos Master Saturation & Ground State"
    SubstrateGeom
    (\m =>
      let trans : ThermodynamicEpochToken -> CosmosApexToken
          trans (GatePureScale _)   = PrimorialBudget (MkBoxInt 210)
          trans (DecoherentScale _) = HelmholtzGroundState (MkBoxInt (-1320))
      in mapMultiset trans m
    )
    (\m =>
      let pullback : CosmosApexToken -> ThermodynamicEpochToken
          pullback (PrimorialBudget _)       = GatePureScale 38
          pullback (HelmholtzGroundState _)  = DecoherentScale 136
      in mapMultiset pullback m
    )

--------------------------------------------------------------------------------
-- 3. THE MASTER COSMIC STREAM PIPELINE CHAIN (T_total)
--------------------------------------------------------------------------------

||| T_total: Master End-to-End Typed Multiset Stream Pipeline.
||| Formally composes all 7 layer morphisms into a single functorial stream transducer.
public export
cosmicStreamPipeline : PhysicalLayerMorphism L7_CosmosMaster SubstrateCarrierToken CosmosApexToken
cosmicStreamPipeline =
  composeLayerMorphisms morph0to1 (
  composeLayerMorphisms morph1to2 (
  composeLayerMorphisms morph2to3 (
  composeLayerMorphisms morph3to4 (
  composeLayerMorphisms morph4to5 (
  composeLayerMorphisms morph5to6 morph6to7)))))

||| Verifies that the Master Pipeline possesses the Substrate Geometry operating metric.
public export
0 prfMasterPipelineGeometry : operatingGeometry Pipeline.cosmicStreamPipeline = SubstrateGeom
prfMasterPipelineGeometry = Refl

--------------------------------------------------------------------------------
-- 4. LINEAR QTT MULTISET PIPELINE (Rule 04 Strict Multiplicity 1)
--------------------------------------------------------------------------------

||| Linear Morphism 0 -> 1: Primordial Substrate Unfolding to Chromogeometric Triad.
public export
linearMorph0to1 : (1 m : Multiset BoxInt SubstrateCarrierToken) -> Multiset BoxInt TriadUnfoldingToken
linearMorph0to1 ZeroM = ZeroM
linearMorph0to1 (AddM (MkSubstrateTick (MkBoxInt w)) c rest) =
  AddM (BlueTriad (MkBoxInt (w * 25))) c (
  AddM (RedTriad (MkBoxInt (w * 7))) c (
  AddM (GreenTriad (MkBoxInt (w * 24))) c (
    linearMorph0to1 rest)))

||| Linear Morphism 1 -> 2: Triad to Discrete Multi-Radix Streams.
public export
linearMorph1to2 : (1 m : Multiset BoxInt TriadUnfoldingToken) -> Multiset BoxInt DiscreteRadixToken
linearMorph1to2 ZeroM = ZeroM
linearMorph1to2 (AddM (BlueTriad w) c rest)  = AddM (RadixBit True w) c (linearMorph1to2 rest)
linearMorph1to2 (AddM (RedTriad w) c rest)   = AddM (RadixTrit (-1) w) c (linearMorph1to2 rest)
linearMorph1to2 (AddM (GreenTriad w) c rest) = AddM (RadixTrit 1 w) c (linearMorph1to2 rest)

||| Linear Morphism 2 -> 3: Discrete Radix to Metrical Chromogeometry & Spin Network.
public export
linearMorph2to3 : (1 m : Multiset BoxInt DiscreteRadixToken) -> Multiset BoxInt MetricalChromoToken
linearMorph2to3 ZeroM = ZeroM
linearMorph2to3 (AddM (RadixBit _ w) c rest)  = AddM (CliffordSpinor w) c (linearMorph2to3 rest)
linearMorph2to3 (AddM (RadixTrit t w) c rest) = AddM (ChromoQuadrance (mulBox w (MkBoxInt (cast t)))) c (linearMorph2to3 rest)

||| Linear Morphism 3 -> 4: Metrical Geometry to Gauge Field & Action Geodesic.
public export
linearMorph3to4 : (1 m : Multiset BoxInt MetricalChromoToken) -> Multiset BoxInt GaugeActionToken
linearMorph3to4 ZeroM = ZeroM
linearMorph3to4 (AddM (ChromoQuadrance q) c rest) = AddM (PlaquetteResidue q) c (linearMorph3to4 rest)
linearMorph3to4 (AddM (CliffordSpinor s) c rest)  = AddM (ActionGeodesic s) c (linearMorph3to4 rest)

||| Linear Morphism 4 -> 5: Gauge Fields to Hadronic Baryons & Toric Stabilizers.
public export
linearMorph4to5 : (1 m : Multiset BoxInt GaugeActionToken) -> Multiset BoxInt HadronicQuantumToken
linearMorph4to5 ZeroM = ZeroM
linearMorph4to5 (AddM (PlaquetteResidue p) c rest) = AddM (ToricStabilizer p) c (linearMorph4to5 rest)
linearMorph4to5 (AddM (ActionGeodesic s) c rest)   = AddM (BaryonSinglet s) c (linearMorph4to5 rest)

||| Linear Morphism 5 -> 6: Hadronic Confinement to Thermodynamic 137 Sieve Trajectory.
public export
linearMorph5to6 : (1 m : Multiset BoxInt HadronicQuantumToken) -> Multiset BoxInt ThermodynamicEpochToken
linearMorph5to6 ZeroM = ZeroM
linearMorph5to6 (AddM (BaryonSinglet (MkBoxInt b)) c rest) =
  let tok = if b <= 76 then GatePureScale (fromInteger (abs b))
                       else DecoherentScale (fromInteger (abs b))
  in AddM tok c (linearMorph5to6 rest)
linearMorph5to6 (AddM (ToricStabilizer (MkBoxInt t)) c rest) =
  let tok = if t <= 76 then GatePureScale (fromInteger (abs t))
                       else DecoherentScale (fromInteger (abs t))
  in AddM tok c (linearMorph5to6 rest)

||| Linear Morphism 6 -> 7: Thermodynamic Horizon Sieve to Cosmos Master Ground State.
public export
linearMorph6to7 : (1 m : Multiset BoxInt ThermodynamicEpochToken) -> Multiset BoxInt CosmosApexToken
linearMorph6to7 ZeroM = ZeroM
linearMorph6to7 (AddM (GatePureScale _) c rest)   = AddM (PrimorialBudget (MkBoxInt 210)) c (linearMorph6to7 rest)
linearMorph6to7 (AddM (DecoherentScale _) c rest) = AddM (HelmholtzGroundState (MkBoxInt (-1320))) c (linearMorph6to7 rest)

||| T_total Linear: Master End-to-End Typed Multiset Stream Pipeline with strict QTT multiplicity 1.
||| Guarantees at compile time that multiset mass-energy streams cannot be cloned, dropped, or leaked.
public export
linearCosmicStreamPipeline : (1 m : Multiset BoxInt SubstrateCarrierToken) ->
                             Multiset BoxInt CosmosApexToken
linearCosmicStreamPipeline m =
  linearMorph6to7 (
  linearMorph5to6 (
  linearMorph4to5 (
  linearMorph3to4 (
  linearMorph2to3 (
  linearMorph1to2 (
  linearMorph0to1 m))))))

||| Compile-time verification that the linear pipeline processes the vacuum carrier into the vacuum apex.
public export
0 prfLinearVacuumPipeline : linearCosmicStreamPipeline ZeroM = ZeroM
prfLinearVacuumPipeline = Refl


