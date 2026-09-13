module Reflect.InvariantAuditor

import public Reflect.Auditor.Core
import public Reflect.Auditor.Math
import public Reflect.Auditor.Geometry
import public Reflect.Auditor.Compound
import public Reflect.Auditor.Evolution
import public Reflect.Auditor.Observation

import Math.FineStructure
import public Language.Reflection

%default total

------------------------------------------------------------------------
-- HIGHER-ORDER ELABORATOR REFLECTION MACRO GENERATOR
------------------------------------------------------------------------

||| Universal compile-time invariant auditing macro tactic.
public export
%macro
auditInvariant : (prop : Bool) -> Elab (prop = True)
auditInvariant True = pure Refl
auditInvariant False = fail "Invariant Audit Failed at Compile-Time!"

------------------------------------------------------------------------
-- COMPATIBILITY ALIASES FOR WIKI EVIDENCE CHAPTERS
------------------------------------------------------------------------

public export
audit27ClosureProof : Bool
audit27ClosureProof = auditTernaryClosureProofExport

public export
auditUnitDenomProof : Bool
auditUnitDenomProof = auditUnixelFractionPositivityProofExport

public export
auditCanonicalRationalEquivProof : Bool
auditCanonicalRationalEquivProof = auditRationalEquivalenceProofExport

public export
auditStandardClipLengthProof : Bool
auditStandardClipLengthProof = auditOnSeqClipExtractionProofExport

public export
auditCliffordGeometricProductMacroProof : Bool
auditCliffordGeometricProductMacroProof = auditCliffordGeometricProductProofExport

public export
auditDiracCurrentConservationMacroProof : Bool
auditDiracCurrentConservationMacroProof = auditDiracCurrentConservationLaw8ProofExport

public export
auditHehnerScaleConversionMacroProof : Bool
auditHehnerScaleConversionMacroProof = auditHehnerScaleConversionProofExport

public export
auditMultisetInformationDistanceMacroProof : Bool
auditMultisetInformationDistanceMacroProof = auditMultisetInformationDistanceProofExport

public export
auditMultisetHehnerTriadMacroProof : Bool
auditMultisetHehnerTriadMacroProof = auditMultisetHehnerTriadProofExport

public export
auditMultisetCrossEntropyMacroProof : Bool
auditMultisetCrossEntropyMacroProof = auditMultisetCrossEntropyProofExport

public export
auditMultisetCompactnessMacroProof : Bool
auditMultisetCompactnessMacroProof = auditMultisetCompactnessProofExport

public export
auditHyperbolicBitDualityMacroProof : Bool
auditHyperbolicBitDualityMacroProof = auditHyperbolicBitDualityProofExport

public export
auditCliffordCompactnessDualityMacroProof : Bool
auditCliffordCompactnessDualityMacroProof = auditCliffordCompactnessDualityProofExport

public export
auditChromogeometricBudgetMacroProof : Bool
auditChromogeometricBudgetMacroProof = auditChromogeometricBudgetProofExport

public export
auditHolographicBoundaryDualityMacroProof : Bool
auditHolographicBoundaryDualityMacroProof = auditHolographicBoundaryDualityProofExport

public export
auditYangMillsPlaquetteCrossEntropyMacroProof : Bool
auditYangMillsPlaquetteCrossEntropyMacroProof = auditYangMillsPlaquetteCrossEntropyProofExport

public export
auditLandauerTokenConservationMacroProof : Bool
auditLandauerTokenConservationMacroProof = auditLandauerTokenConservationProofExport

public export
auditRenormalizationInvarianceMacroProof : Bool
auditRenormalizationInvarianceMacroProof = auditRenormalizationInvarianceProofExport

public export
auditCosmologicalInferencesMacroProof : Bool
auditCosmologicalInferencesMacroProof = auditCosmologicalInferencesProofExport

public export
auditSymplecticStepMacroProof : Bool
auditSymplecticStepMacroProof = auditSymplecticPhaseInvarianceProofExport

public export
auditDiscreteNoetherConservationProof : Bool
auditDiscreteNoetherConservationProof = auditDiscreteNoetherConservationProofExport

public export
auditSubstrateVelocityNoFeedback : Bool
auditSubstrateVelocityNoFeedback = auditRelativisticVelocityLensingProofExport

public export
auditFineStructure137Proof : Bool
auditFineStructure137Proof =
  Math.FineStructure.verify137Derivation &&
  Math.FineStructure.verifyCosmicPartition210
