||| 137-Scale Gate Coherence Sieve (76 Gate-Pure / 61 Decoherent Exact Partition)
|||
||| Evaluates the smooth-bound prime factorization across the coinductive scale trajectory
||| stream using single-pass deforested FusedStream folds in O(1) auxiliary registers.
module Stage1.Epoch.ScaleTrajectorySieve

import public Stage1.TypeTheory.Smoothness
import Stage0.BoxInt
import Stage0.OnSeq.FusedStream
import Stage1.Multiset.PrimordialUnfolding
import Data.Nat

%default total

--------------------------------------------------------------------------------
-- 1. SCALE COHERENCE CLASSIFICATION & TERM-INDEXED SCALE STEP RECORD
--------------------------------------------------------------------------------

||| Evaluates coherence classification of scale step k under generic prime bound.
public export
evalScaleStepCoherenceBounded : (bound : Nat) -> (k : Nat) -> CoherenceStatus bound (S k)
evalScaleStepCoherenceBounded bound k = decideCoherence bound (S k)

||| Coherence evaluator using CosmicSmoothHorizon (13).
public export
evalScaleStepCoherence : (k : Nat) -> CoherenceStatus CosmicSmoothHorizon (S k)
evalScaleStepCoherence = evalScaleStepCoherenceBounded CosmicSmoothHorizon

||| A certified smooth scale degree bundling a natural number with its smoothness proof witness (Rule 03 §7):
public export
SmoothScale : (bound : Nat) -> Type
SmoothScale bound = (n : Nat ** SmoothWitness bound n)

||| A dependent scale step bundling a scale index k with its constructive coherence status at S k (Rule 03 §7):
public export
DependentScaleStep : (bound : Nat) -> Type
DependentScaleStep bound = (k : Nat ** CoherenceStatus bound (S k))

||| Canonical smart constructor for a DependentScaleStep under any prime bound:
public export
mkDependentScaleStep : (bound : Nat) -> (k : Nat) -> DependentScaleStep bound
mkDependentScaleStep bound k = (k ** evalScaleStepCoherenceBounded bound k)


||| Term-indexed discrete cosmological scale step parameterized by smoothness bound.
||| Bundles its scale index k, generation number n = S k, its chromogeometric
||| TriadQuadrance payload, and dependent coherence status witness (Rule 03).
public export
record ScaleStep (bound : Nat) where
  constructor MkScaleStep
  scaleIndex : Nat
  triad      : TriadQuadrance
  status     : CoherenceStatus bound (S scaleIndex)

||| Projects the generation index n = S k from a ScaleStep.
public export
generation : ScaleStep bound -> Nat
generation (MkScaleStep k _ _) = S k

||| Extracts the certified Dimension from a ScaleStep if gate-pure.
public export
scaleDimension : ScaleStep bound -> Maybe (Dimension bound)
scaleDimension (MkScaleStep _ _ (GatePure prf)) = Just (_ ** prf)
scaleDimension (MkScaleStep _ _ (Decoherent _)) = Nothing

public export
{bound : Nat} -> Eq (ScaleStep bound) where
  (MkScaleStep k1 t1 s1) == (MkScaleStep k2 t2 s2) =
    k1 == k2 && t1 == t2 && isStatusGatePure s1 == isStatusGatePure s2

public export
{bound : Nat} -> Show (ScaleStep bound) where
  show (MkScaleStep k t s) =
    "ScaleStep(" ++ show k ++ " | n=" ++ show (S k) ++ " | " ++ show s ++ ")"

||| Canonical cosmological scale step carrier (13-smooth).
public export
CosmicScaleStep : Type
CosmicScaleStep = ScaleStep CosmicSmoothHorizon

||| Canonical compile-time verified Observer scale step (k = 38, n = 39).
public export
observerScaleStep : CosmicScaleStep
observerScaleStep =
  MkScaleStep 38 (epochTriadQuadrance 38) (GatePure Refl)

||| Canonical compile-time verified Grid Wall scale step (k = 136, n = 137).
public export
gridWallScaleStep : CosmicScaleStep
gridWallScaleStep =
  MkScaleStep 136 (epochTriadQuadrance 136) (Decoherent contraSmooth137)

--------------------------------------------------------------------------------
-- 1B. COSMOLOGICAL PHASES OF MATTER & EPOCH SCHEDULE (Rule 03 §4 & §5)
--------------------------------------------------------------------------------

||| Cosmological phase classification across the 137-scale trajectory.
public export
data CosmologicalPhase =
    PhaseConformalBounce         -- k = 0
  | PhaseQGPCooling              -- k in [1, 3]
  | PhaseQCDHadronization        -- k in [4, 6]
  | PhaseBBNDeuteronBottleneck   -- k in [7, 8]
  | PhaseBBNHeliumFreezeout      -- k in [9, 10]
  | PhaseStellarNucleosynthesis  -- k in [11, 20]
  | PhaseAtomicRecombination     -- k in [15, 25]
  | PhasePrebioticVolatiles      -- k in [21, 30]
  | PhaseMacromolecularAssembly  -- k in [26, 30]
  | PhaseRibosomalTranslation    -- k in [31, 34]
  | PhaseProtocellHydration      -- k in [35, 37]
  | PhaseObserverActiveInference -- k >= 38

public export
Eq CosmologicalPhase where
  PhaseConformalBounce         == PhaseConformalBounce         = True
  PhaseQGPCooling              == PhaseQGPCooling              = True
  PhaseQCDHadronization        == PhaseQCDHadronization        = True
  PhaseBBNDeuteronBottleneck   == PhaseBBNDeuteronBottleneck   = True
  PhaseBBNHeliumFreezeout      == PhaseBBNHeliumFreezeout      = True
  PhaseStellarNucleosynthesis  == PhaseStellarNucleosynthesis  = True
  PhaseAtomicRecombination     == PhaseAtomicRecombination     = True
  PhasePrebioticVolatiles      == PhasePrebioticVolatiles      = True
  PhaseMacromolecularAssembly  == PhaseMacromolecularAssembly  = True
  PhaseRibosomalTranslation    == PhaseRibosomalTranslation    = True
  PhaseProtocellHydration      == PhaseProtocellHydration      = True
  PhaseObserverActiveInference == PhaseObserverActiveInference = True
  _                            == _                            = False

public export
Show CosmologicalPhase where
  show PhaseConformalBounce         = "Phase: Conformal Bounce (k=0)"
  show PhaseQGPCooling              = "Phase: QGP Cooling (k in [1, 3])"
  show PhaseQCDHadronization        = "Phase: QCD Hadronization (k in [4, 6])"
  show PhaseBBNDeuteronBottleneck   = "Phase: BBN Deuteron Bottleneck (k in [7, 8])"
  show PhaseBBNHeliumFreezeout      = "Phase: BBN Helium-4 Freeze-out (k in [9, 10])"
  show PhaseStellarNucleosynthesis  = "Phase: Stellar Nucleosynthesis (k in [11, 20])"
  show PhaseAtomicRecombination     = "Phase: Atomic Recombination (k in [15, 25])"
  show PhasePrebioticVolatiles      = "Phase: Prebiotic Volatiles (k in [21, 30])"
  show PhaseMacromolecularAssembly  = "Phase: Macromolecular Assembly (k in [26, 30])"
  show PhaseRibosomalTranslation    = "Phase: Ribosomal Translation (k in [31, 34])"
  show PhaseProtocellHydration      = "Phase: Protocell Hydration (k in [35, 37])"
  show PhaseObserverActiveInference = "Phase: Observer Active Inference (k >= 38)"

public export
isQGPCooling : Nat -> Bool
isQGPCooling k = k >= 1 && k <= 3

public export
isQCDHadronization : Nat -> Bool
isQCDHadronization k = k >= 4 && k <= 6

public export
isBBNDeuteronBottleneck : Nat -> Bool
isBBNDeuteronBottleneck k = k >= 7 && k <= 8

public export
isBBNHeliumFreezeout : Nat -> Bool
isBBNHeliumFreezeout k = k >= 9 && k <= 10

public export
isStellarNucleosynthesis : Nat -> Bool
isStellarNucleosynthesis k = k >= 11 && k <= 20

public export
isAtomicRecombination : Nat -> Bool
isAtomicRecombination k = k >= 15 && k <= 25

public export
isPrebioticVolatiles : Nat -> Bool
isPrebioticVolatiles k = k >= 21 && k <= 30

public export
isMacromolecularAssembly : Nat -> Bool
isMacromolecularAssembly k = k >= 26 && k < 38

public export
isRibosomalTranslation : Nat -> Bool
isRibosomalTranslation k = k >= 31 && k <= 34

public export
isProtocellHydration : Nat -> Bool
isProtocellHydration k = k >= 35 && k <= 37

public export
isObserverActive : Nat -> Bool
isObserverActive k = k >= observerScaleStep.scaleIndex

||| Classifies the primary cosmological phase of matter at epoch k (Rule 03 §4).
public export
classifyCosmicPhase : Nat -> CosmologicalPhase
classifyCosmicPhase k =
  if k == 0 then PhaseConformalBounce
  else if isQGPCooling k then PhaseQGPCooling
  else if isQCDHadronization k then PhaseQCDHadronization
  else if isBBNDeuteronBottleneck k then PhaseBBNDeuteronBottleneck
  else if isBBNHeliumFreezeout k then PhaseBBNHeliumFreezeout
  else if isStellarNucleosynthesis k then PhaseStellarNucleosynthesis
  else if isAtomicRecombination k then PhaseAtomicRecombination
  else if isPrebioticVolatiles k then PhasePrebioticVolatiles
  else if isRibosomalTranslation k then PhaseRibosomalTranslation
  else if isProtocellHydration k then PhaseProtocellHydration
  else if isObserverActive k then PhaseObserverActiveInference
  else PhaseMacromolecularAssembly

--------------------------------------------------------------------------------
-- 2. DEFORESTED SCALE TRAJECTORY STREAM TRANSDUCERS (O(1) AUXILIARY MEMORY)
--------------------------------------------------------------------------------

||| Single-step generator unfolding scale trajectory steps into a coinductive stream.
public export
stepScaleTrajectory : (bound : Nat) -> Nat -> Step Nat (ScaleStep bound)
stepScaleTrajectory bound k =
  let tr = epochTriadQuadrance k
      st = evalScaleStepCoherenceBounded bound k
  in Yield (MkScaleStep k tr st) (S k)

||| Infinite coinductive stream of cosmological scale trajectory steps.
||| Executes in O(1) auxiliary registers without allocating intermediate lists (Rule 04).
public export
streamScaleTrajectory : (bound : Nat) -> FusedStream (ScaleStep bound)
streamScaleTrajectory bound = unfoldStream (stepScaleTrajectory bound) 0

||| Single-step generator unfolding bounded scale trajectory steps up to maxScale (exclusive).
public export
stepScaleTrajectoryBounded : (bound : Nat) -> (maxScale : Nat) -> Nat -> Step Nat (ScaleStep bound)
stepScaleTrajectoryBounded bound maxScale k =
  if k >= maxScale
     then Done
     else let tr = epochTriadQuadrance k
              st = evalScaleStepCoherenceBounded bound k
          in Yield (MkScaleStep k tr st) (S k)

||| Bounded coinductive stream of scale trajectory steps in [0, maxScale).
public export
streamScaleTrajectoryBounded : (bound : Nat) -> (maxScale : Nat) -> FusedStream (ScaleStep bound)
streamScaleTrajectoryBounded bound maxScale =
  unfoldStream (stepScaleTrajectoryBounded bound maxScale) 0

||| Single-pass deforested stream fold counting gate-pure scales up to limit (inclusive).
||| Executes in O(1) auxiliary registers without heap allocation.
public export
countPureScalesStreamBounded : (bound : Nat) -> (limit : Nat) -> Nat
countPureScalesStreamBounded bound limit =
  foldStreamNat (S limit)
                (\acc, step => case step.status of
                                 GatePure _   => S acc
                                 Decoherent _ => acc)
                0
                (streamScaleTrajectoryBounded bound (S limit))

||| Single-pass deforested stream fold counting decoherent scales up to limit (inclusive).
public export
countDecoherentScalesStreamBounded : (bound : Nat) -> (limit : Nat) -> Nat
countDecoherentScalesStreamBounded bound limit =
  foldStreamNat (S limit)
                (\acc, step => case step.status of
                                 GatePure _   => acc
                                 Decoherent _ => S acc)
                0
                (streamScaleTrajectoryBounded bound (S limit))

||| Backward-compatible: Counts gate-pure scales using CosmicSmoothHorizon (13).
public export
countPureScalesStream : (limit : Nat) -> Nat
countPureScalesStream = countPureScalesStreamBounded CosmicSmoothHorizon

||| Backward-compatible: Counts decoherent scales using CosmicSmoothHorizon (13).
public export
countDecoherentScalesStream : (limit : Nat) -> Nat
countDecoherentScalesStream = countDecoherentScalesStreamBounded CosmicSmoothHorizon

||| Backward-compatible delegate: Counts gate-pure scales using the deforested stream fold.
public export
countPureScalesUpTo : Nat -> Nat
countPureScalesUpTo = countPureScalesStream

--------------------------------------------------------------------------------
-- 3. EXACT DEPENDENT TRAJECTORY SIEVE (Rule 03 §7: Primacy of Dependent Types)
--------------------------------------------------------------------------------

||| Dependently typed cosmological trajectory sieve:
||| Bundles total trajectory step count, prime smoothness bound, pure and decoherent counts,
||| with an exact compile-time proof witness that pure + decoherent = steps.
public export
record TrajectorySieve (steps : Nat) (bound : Nat) where
  constructor MkTrajectorySieve
  pureCount       : Nat
  decoherentCount : Nat
  0 partitionPrf  : pureCount + decoherentCount = steps

||| Canonical 137-Scale Cosmological Sieve (steps = 137, bound = 13):
||| Exactly 76 gate-pure scales (hosting coherent nuclear/atomic matter) and
||| 61 decoherent scales (hosting thermal dissipation), with proof 76 + 61 = 137.
public export
cosmic137Sieve : TrajectorySieve 137 13
cosmic137Sieve = MkTrajectorySieve 76 61 Refl

||| Fundamental cosmological grid wall (137th epoch step).
public export
CosmicGridWall : Nat
CosmicGridWall = 137

||| Penultimate scale index before the cosmological grid wall (k = 136).
public export
scaleWallIndex : Nat
scaleWallIndex = minus CosmicGridWall 1

||| Fundamental period of the 137-scale trajectory sieve (137).
public export
scaleSievePeriod : BoxInt
scaleSievePeriod = intToBoxInt (cast CosmicGridWall)

||| Total count of gate-pure scales across the entire 137-step cosmic trajectory (k = 0 to 136).
||| Evaluated by single-pass coinductive stream fold.
public export
totalPureScales137 : Nat
totalPureScales137 = countPureScalesStream 136

||| Total count of decoherent scales across the 137-step cosmic trajectory.
||| Evaluated by single-pass coinductive stream fold.
public export
totalDecoherentScales137 : Nat
totalDecoherentScales137 = countDecoherentScalesStream 136

||| Audit proof verifying that exactly 76 of 137 scales are gate-pure.
public export
auditExact76PureScalesProof : Bool
auditExact76PureScalesProof = totalPureScales137 == cosmic137Sieve.pureCount

||| Audit proof verifying that exactly 61 of 137 scales are decoherent.
public export
auditExact61DecoherentScalesProof : Bool
auditExact61DecoherentScalesProof = totalDecoherentScales137 == cosmic137Sieve.decoherentCount

||| Audit proof verifying that the observer epoch k = 38 (n = 39 = 3 * 13) is gate-pure.
public export
auditObserverEpochCoherenceProof : Bool
auditObserverEpochCoherenceProof =
  case evalScaleStepCoherence 38 of
    GatePure _   => True
    Decoherent _ => False

||| Audit proof verifying that the cosmological grid wall k = 136 (n = 137 prime) is decoherent.
public export
auditGridWallDecoherenceProof : Bool
auditGridWallDecoherenceProof =
  case evalScaleStepCoherence 136 of
    Decoherent _ => True
    GatePure _   => False

--------------------------------------------------------------------------------
-- 4. DYNAMIC FLRW SCALE FACTOR & COSMOLOGICAL DECELERATION
--------------------------------------------------------------------------------

||| Evaluates the dynamic FLRW scale factor squared a(k)^2 = Q_Blue(x_k, y_k) at epoch k.
public export
epochScaleFactorSquared : Nat -> BoxInt
epochScaleFactorSquared k =
  let (x, y) = epochPythagoreanCoordinate k
  in (x * x) + (y * y)

||| Evaluates the cosmological deceleration numerator q_num(k) = Q_Red(x_k, y_k) = x^2 - y^2 at epoch k.
||| The exact rational deceleration is q(k) = Q_Red / Q_Blue = 1 - 2 * s(k).
public export
epochDecelerationNumerator : Nat -> BoxInt
epochDecelerationNumerator k =
  let (x, y) = epochPythagoreanCoordinate k
  in (x * x) - (y * y)

||| Invariant audit verifying the FLRW Deceleration & Spread Diagonal Identity across epochs:
||| (2 * a(k)^2 - 4 * y^2) == 2 * q_num(k).
public export
auditEpochDecelerationSpreadIdentity : Nat -> Bool
auditEpochDecelerationSpreadIdentity k =
  let (x, y) = epochPythagoreanCoordinate k
      qBlue = (x * x) + (y * y)
      qRed  = (x * x) - (y * y)
      lhs = (intToBoxInt 2 * qBlue) - (intToBoxInt 4 * (y * y))
      rhs = intToBoxInt 2 * qRed
  in boxEq lhs rhs

||| Invariant audit verifying the Spread Diagonal Identity across the deforested trajectory stream.
public export
auditScaleTrajectorySpreadStreamBounded : (bound : Nat) -> (limit : Nat) -> Bool
auditScaleTrajectorySpreadStreamBounded bound limit =
  foldStreamNat (S limit)
                (\acc, step => acc && auditEpochDecelerationSpreadIdentity step.scaleIndex)
                True
                (streamScaleTrajectoryBounded bound (S limit))

||| Backward-compatible audit of Spread Diagonal Identity across the 13-smooth cosmic stream.
public export
auditScaleTrajectorySpreadStream : (limit : Nat) -> Bool
auditScaleTrajectorySpreadStream = auditScaleTrajectorySpreadStreamBounded CosmicSmoothHorizon
