||| 137-Scale Gate Coherence Sieve (76 Gate-Pure / 61 Decoherent Exact Partition)
|||
||| Evaluates the smooth-bound prime factorization across the coinductive scale trajectory
||| stream using single-pass deforested FusedStream folds in O(1) auxiliary registers.
module Stage1.Epoch.ScaleTrajectorySieve

import Stage1.TypeTheory.Smoothness
import Stage0.BoxInt
import Stage0.OnSeq.FusedStream
import Stage1.Multiset.PrimordialUnfolding
import Data.Nat

%default total

--------------------------------------------------------------------------------
-- 1. SCALE COHERENCE CLASSIFICATION & TERM-INDEXED SCALE STEP RECORD
--------------------------------------------------------------------------------

||| Physical coherence status of a scale trajectory step:
||| - GatePure:   n = k + 1 is smooth under prime bound, preserving coherence.
||| - Decoherent: n has prime factors > bound, draining into thermal dispersion.
public export
data ScaleCoherenceStatus = GatePure | Decoherent

public export
Eq ScaleCoherenceStatus where
  GatePure   == GatePure   = True
  Decoherent == Decoherent = True
  _          == _          = False

public export
Show ScaleCoherenceStatus where
  show GatePure   = "GatePure"
  show Decoherent = "Decoherent"

||| Evaluates coherence classification of scale step k under generic prime bound.
public export
evalScaleStepCoherenceBounded : (bound : Nat) -> Nat -> ScaleCoherenceStatus
evalScaleStepCoherenceBounded bound k =
  if isSmoothNat bound (S k) then GatePure else Decoherent

||| Backward-compatible coherence evaluator using CosmicSmoothHorizon (13).
public export
evalScaleStepCoherence : Nat -> ScaleCoherenceStatus
evalScaleStepCoherence = evalScaleStepCoherenceBounded CosmicSmoothHorizon

||| Term-indexed discrete cosmological scale step parameterized by smoothness bound.
||| Holds its scale index k, generation number n = S k, its chromogeometric
||| TriadQuadrance payload, and coherence status.
public export
record ScaleStep (bound : Nat) where
  constructor MkScaleStep
  scaleIndex : Nat
  generation : Nat
  triad      : TriadQuadrance
  status     : ScaleCoherenceStatus

public export
{bound : Nat} -> Eq (ScaleStep bound) where
  (MkScaleStep k1 g1 t1 s1) == (MkScaleStep k2 g2 t2 s2) =
    k1 == k2 && g1 == g2 && t1 == t2 && s1 == s2

public export
{bound : Nat} -> Show (ScaleStep bound) where
  show (MkScaleStep k g t s) =
    "ScaleStep(" ++ show k ++ " | n=" ++ show g ++ " | " ++ show s ++ ")"

||| Canonical cosmological scale step carrier (13-smooth).
public export
CosmicScaleStep : Type
CosmicScaleStep = ScaleStep CosmicSmoothHorizon

--------------------------------------------------------------------------------
-- 2. DEFORESTED SCALE TRAJECTORY STREAM TRANSDUCERS (O(1) AUXILIARY MEMORY)
--------------------------------------------------------------------------------

||| Single-step generator unfolding scale trajectory steps into a coinductive stream.
public export
stepScaleTrajectory : (bound : Nat) -> Nat -> Step Nat (ScaleStep bound)
stepScaleTrajectory bound k =
  let tr = epochTriadQuadrance k
      st = evalScaleStepCoherenceBounded bound k
  in Yield (MkScaleStep k (S k) tr st) (S k)

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
          in Yield (MkScaleStep k (S k) tr st) (S k)

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
                                 GatePure   => S acc
                                 Decoherent => acc)
                0
                (streamScaleTrajectoryBounded bound (S limit))

||| Single-pass deforested stream fold counting decoherent scales up to limit (inclusive).
public export
countDecoherentScalesStreamBounded : (bound : Nat) -> (limit : Nat) -> Nat
countDecoherentScalesStreamBounded bound limit =
  foldStreamNat (S limit)
                (\acc, step => case step.status of
                                 GatePure   => acc
                                 Decoherent => S acc)
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
-- 3. EXACT 76 / 61 PARTITION AUDIT PROOFS
--------------------------------------------------------------------------------

||| Fundamental cosmological grid wall (137th epoch step).
public export
CosmicGridWall : Nat
CosmicGridWall = 137

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
auditExact76PureScalesProof = totalPureScales137 == 76

||| Audit proof verifying that exactly 61 of 137 scales are decoherent.
public export
auditExact61DecoherentScalesProof : Bool
auditExact61DecoherentScalesProof = totalDecoherentScales137 == 61

||| Audit proof verifying that the observer epoch k = 38 (n = 39 = 3 * 13) is gate-pure.
public export
auditObserverEpochCoherenceProof : Bool
auditObserverEpochCoherenceProof =
  case evalScaleStepCoherence 38 of
    GatePure   => True
    Decoherent => False

||| Audit proof verifying that the cosmological grid wall k = 136 (n = 137 prime) is decoherent.
public export
auditGridWallDecoherenceProof : Bool
auditGridWallDecoherenceProof =
  case evalScaleStepCoherence 136 of
    Decoherent => True
    GatePure   => False

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
