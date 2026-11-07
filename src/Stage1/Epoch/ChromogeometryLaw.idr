module Stage1.Epoch.ChromogeometryLaw

import public Stage0.BoxInt
import public Stage0.Multiset
import public Stage1.MetricSignature
import public Stage0.Cosmology.MetricLawLedger
import public CosmicHorizon

%default total

--------------------------------------------------------------------------------
-- 1. COSMIC EPOCH METRIC LAW ACCUMULATION POLICY
--------------------------------------------------------------------------------

||| Monomorphic Peano >= comparison avoiding Ord dictionary dispatch in compile-time Refl proofs (Rule 01 §3).
public export
natGTE : Nat -> Nat -> Bool
natGTE _ Z = True
natGTE Z (S _) = False
natGTE (S a) (S b) = natGTE a b

||| Evaluates whether the dark matter ledger has reached the dual-mode phase transition (>= 17 laws accumulated or step >= 18).
public export
isDualModePhase : Nat -> ChromogeometryLawLedger -> Bool
isDualModePhase ep ledger = natGTE ep 18 || natGTE (countTotalDarkLaws ledger) 17

||| Accumulates Chromogeometric law fingerprints at epoch contraction step ep.
||| Dynamically evaluates phase transition: single-mode (EllipticRed) when < 17 laws,
||| dual-mode (EllipticRed + HyperbolicGreen) when >= 17 laws accumulated.
||| Consolidates keys via insertItemBox to keep the ledger bounded to <= 2 RLE nodes.
public export
accumulateLawsForEpoch : Nat -> ChromogeometryLawLedger -> ChromogeometryLawLedger
accumulateLawsForEpoch ep ledger =
  if isDualModePhase ep ledger then
    insertItemBox EllipticRed (intToBoxInt 1) (insertItemBox HyperbolicGreen (intToBoxInt 1) ledger)
  else
    insertItemBox EllipticRed (intToBoxInt 1) ledger

--------------------------------------------------------------------------------
-- 2. CANONICAL MULTISET METRIC SIGNATURE ACCUMULATION POLICY
--------------------------------------------------------------------------------

||| Evaluates whether the cosmic metric ledger has reached the dual-mode phase transition.
public export
isDualModeMetricPhase : Nat -> CosmicMetricLedger -> Bool
isDualModeMetricPhase ep ledger = natGTE ep 18 || natGTE (countMetricLedgerLaws ledger) 17

||| Accumulates canonical MetricSignature records directly into a CosmicMetricLedger.
public export
accumulateMetricSignaturesForEpoch : Nat -> CosmicMetricLedger -> CosmicMetricLedger
accumulateMetricSignaturesForEpoch ep ledger =
  if isDualModeMetricPhase ep ledger then
    insertItemBox ellipticSignature2D (intToBoxInt 1) (insertItemBox hyperbolicSignature2D (intToBoxInt 1) ledger)
  else
    insertItemBox ellipticSignature2D (intToBoxInt 1) ledger
