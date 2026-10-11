||| 137-Scale Gate Coherence Sieve (76 Gate-Pure / 61 Decoherent Exact Partition)
|||
||| Evaluates the smooth-13 prime factorization across the coinductive scale trajectory
||| stream using single-pass deforested FusedStream folds in O(1) auxiliary registers.
module Stage1.Epoch.ScaleTrajectorySieve

import Stage1.TypeTheory.Smooth13
import Stage0.BoxInt
import Stage0.OnSeq.FusedStream
import Stage1.Multiset.PrimordialUnfolding
import Data.Nat

%default total

--------------------------------------------------------------------------------
-- 1. SCALE COHERENCE CLASSIFICATION & SCALE STEP RECORD
--------------------------------------------------------------------------------

||| Physical coherence status of a scale trajectory step:
||| - GatePure:   n = k + 1 is 13-smooth (max prime factor <= 13), preserving coherence.
||| - Decoherent: n has prime factors > 13, draining into thermal dispersion.
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

||| Evaluates the coherence classification of scale step k in [0, 136] (generation number n = k + 1).
public export
evalScaleStepCoherence : Nat -> ScaleCoherenceStatus
evalScaleStepCoherence k =
  if is13SmoothNat (S k) then GatePure else Decoherent

||| A discrete cosmological scale step holding its scale index k, generation number n = S k,
||| its chromogeometric TriadQuadrance payload, and coherence status.
public export
record ScaleStep where
  constructor MkScaleStep
  scaleIndex : Nat
  generation : Nat
  triad      : TriadQuadrance
  status     : ScaleCoherenceStatus

public export
Eq ScaleStep where
  (MkScaleStep k1 g1 t1 s1) == (MkScaleStep k2 g2 t2 s2) =
    k1 == k2 && g1 == g2 && t1 == t2 && s1 == s2

public export
Show ScaleStep where
  show (MkScaleStep k g t s) =
    "ScaleStep(" ++ show k ++ " | n=" ++ show g ++ " | " ++ show s ++ ")"

--------------------------------------------------------------------------------
-- 2. DEFORESTED SCALE TRAJECTORY STREAM TRANSDUCERS (O(1) AUXILIARY MEMORY)
--------------------------------------------------------------------------------

||| Single-step generator unfolding scale trajectory steps into a coinductive stream.
public export
stepScaleTrajectory : Nat -> Step Nat ScaleStep
stepScaleTrajectory k =
  let tr = epochTriadQuadrance k
      st = evalScaleStepCoherence k
  in Yield (MkScaleStep k (S k) tr st) (S k)

||| Infinite coinductive stream of cosmological scale trajectory steps.
||| Executes in O(1) auxiliary registers without allocating intermediate lists (Rule 04).
public export
streamScaleTrajectory : FusedStream ScaleStep
streamScaleTrajectory = unfoldStream stepScaleTrajectory 0

||| Single-step generator unfolding bounded scale trajectory steps up to maxScale (exclusive).
public export
stepScaleTrajectoryBounded : (maxScale : Nat) -> Nat -> Step Nat ScaleStep
stepScaleTrajectoryBounded maxScale k =
  if k >= maxScale
     then Done
     else let tr = epochTriadQuadrance k
              st = evalScaleStepCoherence k
          in Yield (MkScaleStep k (S k) tr st) (S k)

||| Bounded coinductive stream of scale trajectory steps in [0, maxScale).
public export
streamScaleTrajectoryBounded : (maxScale : Nat) -> FusedStream ScaleStep
streamScaleTrajectoryBounded maxScale =
  unfoldStream (stepScaleTrajectoryBounded maxScale) 0

||| Single-pass deforested stream fold counting gate-pure scales up to limit (inclusive).
||| Executes in O(1) auxiliary registers without heap allocation.
public export
countPureScalesStream : (limit : Nat) -> Nat
countPureScalesStream limit =
  foldStreamNat (S limit)
                (\acc, step => case step.status of
                                 GatePure   => S acc
                                 Decoherent => acc)
                0
                (streamScaleTrajectoryBounded (S limit))

||| Single-pass deforested stream fold counting decoherent scales up to limit (inclusive).
public export
countDecoherentScalesStream : (limit : Nat) -> Nat
countDecoherentScalesStream limit =
  foldStreamNat (S limit)
                (\acc, step => case step.status of
                                 GatePure   => acc
                                 Decoherent => S acc)
                0
                (streamScaleTrajectoryBounded (S limit))

||| Backward-compatible delegate: Counts gate-pure scales using the deforested stream fold.
public export
countPureScalesUpTo : Nat -> Nat
countPureScalesUpTo limit = countPureScalesStream limit

--------------------------------------------------------------------------------
-- 3. EXACT 76 / 61 PARTITION AUDIT PROOFS
--------------------------------------------------------------------------------

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
auditScaleTrajectorySpreadStream : (limit : Nat) -> Bool
auditScaleTrajectorySpreadStream limit =
  foldStreamNat (S limit)
                (\acc, step => acc && auditEpochDecelerationSpreadIdentity step.scaleIndex)
                True
                (streamScaleTrajectoryBounded (S limit))
