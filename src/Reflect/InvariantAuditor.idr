module Reflect.InvariantAuditor

import public Reflect.Auditor.Core
import public Reflect.Auditor.Math
import public Reflect.Auditor.Geometry
import public Reflect.Auditor.Compound
import public Reflect.Auditor.Evolution
import public Reflect.Auditor.Observation

import Math.FineStructure
import Stage1.PhysicalUniverse.Pipeline
import Compound.SymplecticIntegrator
import Stage0.FluctuationStream
import Stage1.MaxelTransform
import Derivation.MultisetTheoremExporter
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

------------------------------------------------------------------------
-- SYSTEMIC COINDUCTIVE STREAM INVARIANT WITNESS EXPORTS & %MACRO AUDITS
------------------------------------------------------------------------

public export
auditCosmicGenesisStreamProofExport : Bool
auditCosmicGenesisStreamProofExport = Stage1.PhysicalUniverse.Pipeline.auditCosmicGenesisStreamProof

public export
%macro
auditCosmicGenesisStream : Elab (Reflect.InvariantAuditor.auditCosmicGenesisStreamProofExport = True)
auditCosmicGenesisStream = auditWitness Reflect.InvariantAuditor.auditCosmicGenesisStreamProofExport

public export
auditGeodesicOrbitMacroProof : Bool
auditGeodesicOrbitMacroProof = Reflect.Auditor.Compound.auditGeodesicOrbitProofExport

public export
%macro
auditGeodesicOrbit : Elab (Reflect.Auditor.Compound.auditGeodesicOrbitProofExport = True)
auditGeodesicOrbit = auditWitness Reflect.Auditor.Compound.auditGeodesicOrbitProofExport

public export
auditDirectThermalFreeEnergyProofExport : Bool
auditDirectThermalFreeEnergyProofExport = Stage0.FluctuationStream.auditDirectThermalFreeEnergyProof

public export
%macro
auditDirectThermalFreeEnergy : Elab (Reflect.InvariantAuditor.auditDirectThermalFreeEnergyProofExport = True)
auditDirectThermalFreeEnergy = auditWitness Reflect.InvariantAuditor.auditDirectThermalFreeEnergyProofExport

public export
auditScaleAdjunctionProofExport : Bool
auditScaleAdjunctionProofExport = Stage1.MaxelTransform.auditScaleAdjunctionProof

public export
%macro
auditScaleAdjunction : Elab (Reflect.InvariantAuditor.auditScaleAdjunctionProofExport = True)
auditScaleAdjunction = auditWitness Reflect.InvariantAuditor.auditScaleAdjunctionProofExport


public export
auditMultisetTheoremExporterMacroProof : Bool
auditMultisetTheoremExporterMacroProof = Reflect.Auditor.Evolution.auditMultisetTheoremExporterProofExport

public export
auditDissipativeLangevinHorizonProofExport : Bool
auditDissipativeLangevinHorizonProofExport = Reflect.Auditor.Compound.auditDissipativeLangevinHorizonProofExport

public export
%macro
auditDissipativeLangevinHorizon : Elab (Reflect.InvariantAuditor.auditDissipativeLangevinHorizonProofExport = True)
auditDissipativeLangevinHorizon = auditWitness Reflect.InvariantAuditor.auditDissipativeLangevinHorizonProofExport

public export
auditLinearCarrierNoLeakageProofExport : Bool
auditLinearCarrierNoLeakageProofExport = Stage1.PhysicalUniverse.Pipeline.auditLinearCarrierNoLeakageProof

public export
%macro
auditLinearCarrierNoLeakage : Elab (Reflect.InvariantAuditor.auditLinearCarrierNoLeakageProofExport = True)
auditLinearCarrierNoLeakage = auditWitness Reflect.InvariantAuditor.auditLinearCarrierNoLeakageProofExport

public export
auditFusedCosmicPipelineEquivalenceProofExport : Bool
auditFusedCosmicPipelineEquivalenceProofExport = Stage1.PhysicalUniverse.Pipeline.auditFusedCosmicPipelineEquivalenceProof

public export
%macro
auditFusedCosmicPipelineEquivalence : Elab (Reflect.InvariantAuditor.auditFusedCosmicPipelineEquivalenceProofExport = True)
auditFusedCosmicPipelineEquivalence = auditWitness Reflect.InvariantAuditor.auditFusedCosmicPipelineEquivalenceProofExport

public export
auditUnrolledCosmicPipelineProofExport : Bool
auditUnrolledCosmicPipelineProofExport = Stage1.PhysicalUniverse.Pipeline.auditUnrolledCosmicPipelineProof

public export
%macro
auditUnrolledCosmicPipeline : Elab (Reflect.InvariantAuditor.auditUnrolledCosmicPipelineProofExport = True)
auditUnrolledCosmicPipeline = auditWitness Reflect.InvariantAuditor.auditUnrolledCosmicPipelineProofExport




