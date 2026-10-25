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
monomorphicInternalEnergy : BoxInt -> BoxInt -> BoxInt
monomorphicInternalEnergy vm de = addBox (mulBox (intToBoxInt 10) vm) de

||| Monomorphic combinatorial entropy: S = 2 * VM + 5 * DE + 3 * DM.
public export
monomorphicEntropy : BoxInt -> BoxInt -> BoxInt -> BoxInt
monomorphicEntropy vm de dm =
  addBox (mulBox (intToBoxInt 2) vm) (addBox (mulBox (intToBoxInt 5) de) (mulBox (intToBoxInt 3) dm))

||| Monomorphic Helmholtz Free Energy: F = U - 2 * S.
public export
monomorphicHelmholtzFreeEnergy : BoxInt -> BoxInt -> BoxInt -> BoxInt
monomorphicHelmholtzFreeEnergy vm de dm =
  let u = monomorphicInternalEnergy vm de
      s = monomorphicEntropy vm de dm
  in subBox u (mulBox (intToBoxInt 2) s)

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
  boxEq (monomorphicHelmholtzFreeEnergy p.ellipticVM p.hyperbolicDE p.parabolicDM) (intToBoxInt (-1320))

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
