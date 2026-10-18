module Stage1.Epoch.CosmicPartitionAuditor

import public Stage0.BoxInt
import public Stage1.Multiset.PrimordialUnfolding
import public Stage1.Epoch.ScaleTrajectorySieve
import Language.Reflection

%default total

--------------------------------------------------------------------------------
-- 1. MONOMORPHIC FREE ENERGY & PARTITION CALCULATIONS
--------------------------------------------------------------------------------

||| Monomorphic internal energy: U = 10 * VM + 1 * DE.
public export
monomorphicInternalEnergy : Integer -> Integer -> Integer
monomorphicInternalEnergy vm de = (10 * vm) + (1 * de)

||| Monomorphic combinatorial entropy: S = 2 * VM + 5 * DE + 3 * DM.
public export
monomorphicEntropy : Integer -> Integer -> Integer -> Integer
monomorphicEntropy vm de dm = (2 * vm) + (5 * de) + (3 * dm)

||| Monomorphic Helmholtz Free Energy: F = U - 2 * S.
public export
monomorphicHelmholtzFreeEnergy : Integer -> Integer -> Integer -> Integer
monomorphicHelmholtzFreeEnergy vm de dm =
  let u = monomorphicInternalEnergy vm de
      s = monomorphicEntropy vm de dm
  in u - (2 * s)

--------------------------------------------------------------------------------
-- 2. COSMIC PARTITION AUDIT SPECIFICATION
--------------------------------------------------------------------------------

||| Audits that a CosmicPartition satisfies the exact Primorial 210 capacity budget:
||| VM (27) + DE (128) + DM (55) == 210 Master.
public export
auditBudgetConservation : CosmicPartition -> Bool
auditBudgetConservation p =
  let tot = p.ellipticVM + p.hyperbolicDE + p.parabolicDM
  in (tot == intToBoxInt 210) && (p.substrateMaster == intToBoxInt 210)

||| Audits that a CosmicPartition achieves the exact ground-state Helmholtz free energy:
||| F = U - 2S == -1320.
public export
auditHelmholtzMinimum : CosmicPartition -> Bool
auditHelmholtzMinimum p =
  let vm = unwrapBox p.ellipticVM
      de = unwrapBox p.hyperbolicDE
      dm = unwrapBox p.parabolicDM
  in monomorphicHelmholtzFreeEnergy vm de dm == (-1320)

||| Audits that the 137-scale sieve partition preserves exactly 76 gate-pure and 61 decoherent scales:
||| 76 + 61 == 137.
public export
auditScaleSievePartition : Bool
auditScaleSievePartition =
  auditExact76PureScalesProof && auditExact61DecoherentScalesProof

||| Master composite audit predicate verifying the Primorial 210 ground state.
public export
isValidCosmicPartition : CosmicPartition -> Bool
isValidCosmicPartition p =
  auditBudgetConservation p &&
  auditHelmholtzMinimum p

||| Compile-time proof witness export for the canonical ground state partition.
public export
auditCanonicalCosmicPartitionProofExport : Bool
auditCanonicalCosmicPartitionProofExport =
  isValidCosmicPartition canonicalCosmicPartition

--------------------------------------------------------------------------------
-- 3. ELABORATOR REFLECTION MACROS (Rule 01)
--------------------------------------------------------------------------------

||| Universal generic macro witness auditor tactic.
%inline public export
auditWitness : (target : Bool) -> Elab (target = True)
auditWitness True = pure Refl
auditWitness False = fail "Audit witness check failed: proof export returned False"

||| Macro auditing the canonical cosmic partition ground state directly.
public export
%macro
auditCanonicalCosmicPartition : Elab (Stage1.Epoch.CosmicPartitionAuditor.auditCanonicalCosmicPartitionProofExport = True)
auditCanonicalCosmicPartition = auditWitness auditCanonicalCosmicPartitionProofExport

||| Compile-time reflection macro auditing that a CosmicPartition satisfies
||| all constructivist physical conservation laws (210 capacity budget, F = -1320).
public export
%macro
auditCosmicPartition : (prop : Bool) -> Elab (prop = True)
auditCosmicPartition True  = pure Refl
auditCosmicPartition False = fail "Compile-time CosmicPartition audit failed: budget or free energy minimum violated!"
