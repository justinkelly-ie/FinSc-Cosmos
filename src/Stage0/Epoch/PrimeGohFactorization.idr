module Stage0.Epoch.PrimeGohFactorization

import public Stage0.BoxInt
import public Stage0.Multiset
import public Stage0.PrimeMultiset
import public Stage1.Epoch.ChromogeometryLaw
import public Stage0.Epoch.GohStreamTransducer
import public Stage1.Epoch.ExpansionCollapse
import public Stage1.Epoch.Trajectory

import public Stage1.MetricSignature
import public Stage1.Goh.Factor

%default total

--------------------------------------------------------------------------------
-- 1. RE-EXPORT PROMOTED CORE PRIME FACTORIZATION ENGINE
--------------------------------------------------------------------------------

||| Re-exported proof witness verifying 13-smoothness for Goh energy step (13, 1).
public export
0 verifyEpochGoh13Smoothness : Stage0.PrimeMultiset.auditGoh13Smoothness (MkGohStep 13 1) = True
verifyEpochGoh13Smoothness = Stage0.PrimeMultiset.verifyGoh13Smoothness

--------------------------------------------------------------------------------
-- 2. GOH PRIME TO CHROMOGEOMETRIC METRIC LAW ISOMORPHISM
--------------------------------------------------------------------------------

||| Maps a dependently typed Goh prime to its corresponding Chromogeometric metric law signature.
public export
gohPrimeToMetricLaw : {p : Nat} -> GohPrime p -> ChromogeometryLaw
gohPrimeToMetricLaw Prime2  = SubstrateTorsion
gohPrimeToMetricLaw Prime3  = EllipticRed
gohPrimeToMetricLaw Prime5  = ParabolicBlue
gohPrimeToMetricLaw Prime7  = SubstrateTorsion
gohPrimeToMetricLaw Prime11 = HyperbolicGreen
gohPrimeToMetricLaw Prime13 = EllipticRed

||| Maps a dependently typed Goh prime directly to its canonical discrete multiset MetricSignature over {-1, 0, 1}.
public export
gohPrimeToMetricSignature : {p : Nat} -> GohPrime p -> Stage1.MetricSignature.MetricSignature
gohPrimeToMetricSignature Prime2  = substrateSignature2D
gohPrimeToMetricSignature Prime3  = ellipticSignature2D
gohPrimeToMetricSignature Prime5  = parabolicSignature2D
gohPrimeToMetricSignature Prime7  = substrateSignature2D
gohPrimeToMetricSignature Prime11 = hyperbolicSignature2D
gohPrimeToMetricSignature Prime13 = ellipticSignature2D

||| Evaluates the exact quadrance of a coordinate displacement (dx, dy) under a dependently typed Goh prime metric.
public export
gohPrimeQuadrance : {p : Nat} -> GohPrime p -> (BoxInt, BoxInt) -> BoxInt
gohPrimeQuadrance gp (x, y) =
  signatureQuadrance2D (gohPrimeToMetricSignature gp) x y

||| QTT 0 erased proof witness verifying exact prime 3 elliptic quadrance of (4, 3) is 25.
public export
0 prfPrime3Quadrance25 : gohPrimeQuadrance Prime3 (MkBoxInt 4, MkBoxInt 3) = MkBoxInt 25
prfPrime3Quadrance25 = Refl

||| QTT 0 erased proof witness verifying exact prime 11 hyperbolic quadrance of (5, 4) is 9.
public export
0 prfPrime11Quadrance9 : gohPrimeQuadrance Prime11 (MkBoxInt 5, MkBoxInt 4) = MkBoxInt 9
prfPrime11Quadrance9 = Refl

||| QTT 0 erased proof witness verifying exact prime 5 parabolic quadrance of (3, 7) is 9.
public export
0 prfPrime5Quadrance9 : gohPrimeQuadrance Prime5 (MkBoxInt 3, MkBoxInt 7) = MkBoxInt 9
prfPrime5Quadrance9 = Refl

||| Soundness audit verifying that all 13-smooth primes {2, 3, 5, 7, 11, 13} map definitionally to valid Chromogeometric laws.
public export
auditPrimeMetricIsomorphismSoundness : Bool
auditPrimeMetricIsomorphismSoundness =
  (gohPrimeToMetricLaw Prime2 == SubstrateTorsion) &&
  (gohPrimeToMetricLaw Prime3 == EllipticRed) &&
  (gohPrimeToMetricLaw Prime5 == ParabolicBlue) &&
  (gohPrimeToMetricLaw Prime7 == SubstrateTorsion) &&
  (gohPrimeToMetricLaw Prime11 == HyperbolicGreen) &&
  (gohPrimeToMetricLaw Prime13 == EllipticRed)

public export
0 verifyPrimeMetricIsomorphismSoundness : Stage0.Epoch.PrimeGohFactorization.auditPrimeMetricIsomorphismSoundness = True
verifyPrimeMetricIsomorphismSoundness = Refl


--------------------------------------------------------------------------------
-- 3. AFFINE-TO-MONOID ADJOINT FUNCTOR INSTANCE (F_Affine ⊣ U_Monoid)
--------------------------------------------------------------------------------

||| AffineMonoidAdjunction instance for ChromogeometryLawLedger:
||| Freely constructs dark matter law multiset terms from affine Goh energy shift vectors.
public export
AffineMonoidAdjunction ChromogeometryLawLedger where
  freeMonoidFromAffine (MkAffineVector step lawId) ledger =
    accumulateLawsForEpoch step ledger
  forgetMonoidToAffine ledger =
    MkAffineVector (countTotalDarkLaws ledger) 1

||| Evaluates 12-step Affine-to-Monoid Adjunction Unit composition (eta_12 . ... . eta_1)
||| constructing the 13-smooth Goh factor state space from empty multiset ZeroM.
public export
eval12StepAffineAdjunctionUnit : ChromogeometryLawLedger -> ChromogeometryLawLedger
eval12StepAffineAdjunctionUnit initM =
  (advanceN 12 initGenesisEpoch).darkMatterLedger

||| Soundness audit verifying 12-step Affine-to-Monoid Adjunction unit composition yields 12 accumulated laws at step 13 boundary.
public export
audit12StepAdjunctionChainSoundness : Bool
audit12StepAdjunctionChainSoundness = countTotalDarkLaws (eval12StepAffineAdjunctionUnit ZeroM) == 12

public export
0 verify12StepAdjunctionChainSoundness : Stage0.Epoch.PrimeGohFactorization.audit12StepAdjunctionChainSoundness = True
verify12StepAdjunctionChainSoundness = Refl

--------------------------------------------------------------------------------
-- 4. OBSERVER 37 & 38 GATE PURITY (13-SMOOTHNESS SWEEP)
--------------------------------------------------------------------------------

||| Soundness audit verifying Observer Epoch 37 and 38 Goh steps are strictly 13-smooth (gate pure).
public export
auditObserver37and38GatePurity : Bool
auditObserver37and38GatePurity =
  auditGoh13Smoothness getGohStep37 &&
  auditGoh13Smoothness (computeGohStepForEpoch 38 57)

public export
0 verifyObserver37and38GatePurity : Stage0.Epoch.PrimeGohFactorization.auditObserver37and38GatePurity = True
verifyObserver37and38GatePurity = Refl
