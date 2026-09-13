module Reflect.Auditor.Geometry

import public Core.BoxInt
import public Core.Order.Preorder
import public Derivation.PureGeometricClassifier
import public Geometry.InformationGeometry
import public Geometry.GaloisCurvature
import public Reflect.Auditor.Core
import Language.Reflection
import public Math.LatticeFluidTransport
import public Math.ExclusionPrinciple

%default total

------------------------------------------------------------------------
-- COMPILE-TIME REFLECTION AUDITS: GEOMETRY DOMAIN
------------------------------------------------------------------------

-- Witness 15: Hyperbolic Bit Duality
public export
auditHyperbolicBitDualityProofExport : Bool
auditHyperbolicBitDualityProofExport = Geometry.InformationGeometry.auditHyperbolicBitDualityProof

public export
%macro
auditHyperbolicBitDuality : Elab (Reflect.Auditor.Geometry.auditHyperbolicBitDualityProofExport = True)
auditHyperbolicBitDuality = auditWitness auditHyperbolicBitDualityProofExport

-- Witness 16: Clifford Compactness Duality
public export
auditCliffordCompactnessDualityProofExport : Bool
auditCliffordCompactnessDualityProofExport = Geometry.InformationGeometry.auditCliffordCompactnessDualityProof

public export
%macro
auditCliffordCompactnessDuality : Elab (Reflect.Auditor.Geometry.auditCliffordCompactnessDualityProofExport = True)
auditCliffordCompactnessDuality = auditWitness auditCliffordCompactnessDualityProofExport

-- Witness 18: Holographic Boundary Duality
public export
auditHolographicBoundaryDualityProofExport : Bool
auditHolographicBoundaryDualityProofExport = Geometry.InformationGeometry.auditHolographicBoundaryDualityProof

public export
%macro
auditHolographicBoundaryDuality : Elab (Reflect.Auditor.Geometry.auditHolographicBoundaryDualityProofExport = True)
auditHolographicBoundaryDuality = auditWitness auditHolographicBoundaryDualityProofExport

-- Witness 19: Yang-Mills Plaquette Cross-Entropy
public export
auditYangMillsPlaquetteCrossEntropyProofExport : Bool
auditYangMillsPlaquetteCrossEntropyProofExport = Geometry.InformationGeometry.auditYangMillsPlaquetteCrossEntropyProof

public export
%macro
auditYangMillsPlaquetteCrossEntropy : Elab (Reflect.Auditor.Geometry.auditYangMillsPlaquetteCrossEntropyProofExport = True)
auditYangMillsPlaquetteCrossEntropy = auditWitness auditYangMillsPlaquetteCrossEntropyProofExport

-- Witness 21: Multi-Scale Renormalization Group
public export
auditRenormalizationInvarianceProofExport : Bool
auditRenormalizationInvarianceProofExport = Geometry.InformationGeometry.auditRenormalizationInvarianceProof

public export
%macro
auditRenormalizationInvariance : Elab (Reflect.Auditor.Geometry.auditRenormalizationInvarianceProofExport = True)
auditRenormalizationInvariance = auditWitness auditRenormalizationInvarianceProofExport

-- Witness 22: Master Cosmological Inferences
public export
auditCosmologicalInferencesProofExport : Bool
auditCosmologicalInferencesProofExport = Derivation.PureGeometricClassifier.auditVexelSpreadClassificationProof

public export
%macro
auditCosmologicalInferences : Elab (Reflect.Auditor.Geometry.auditCosmologicalInferencesProofExport = True)
auditCosmologicalInferences = auditWitness auditCosmologicalInferencesProofExport

-- Witness 64: Grassmann Blade Nilpotency (Law 9)
public export
auditGrassmannNilpotencyProofExport : Bool
auditGrassmannNilpotencyProofExport = Math.ExclusionPrinciple.auditGrassmannNilpotencyProof

public export
%macro
auditGrassmannNilpotency : Elab (Reflect.Auditor.Geometry.auditGrassmannNilpotencyProofExport = True)
auditGrassmannNilpotency = auditWitness auditGrassmannNilpotencyProofExport

-- Witness 98: Pure Constructive Geometric Classification
public export
auditPureGeometricClassificationProofExport : Bool
auditPureGeometricClassificationProofExport = Derivation.PureGeometricClassifier.auditPureGeometricClassificationProof

public export
%macro
auditPureGeometricClassification : Elab (Reflect.Auditor.Geometry.auditPureGeometricClassificationProofExport = True)
auditPureGeometricClassification = auditWitness auditPureGeometricClassificationProofExport

-- Witness 125: Constructive Wasserstein Optimal Transport Metric Axioms
public export
auditWassersteinMetricAxiomsProofExport : Bool
auditWassersteinMetricAxiomsProofExport = Geometry.InformationGeometry.auditWassersteinMetricAxiomsProof

public export
%macro
auditWassersteinMetricAxioms : Elab (Reflect.Auditor.Geometry.auditWassersteinMetricAxiomsProofExport = True)
auditWassersteinMetricAxioms = auditWitness auditWassersteinMetricAxiomsProofExport

-- Witness 126: Exact Quantum Relative Entropy & Klein's Inequality
public export
auditRelativeEntropyKleinsInequalityProofExport : Bool
auditRelativeEntropyKleinsInequalityProofExport = Geometry.InformationGeometry.auditRelativeEntropyKleinsInequalityProof

public export
%macro
auditRelativeEntropyKleinsInequality : Elab (Reflect.Auditor.Geometry.auditRelativeEntropyKleinsInequalityProofExport = True)
auditRelativeEntropyKleinsInequality = auditWitness auditRelativeEntropyKleinsInequalityProofExport

-- Witness 127: Discrete Amari Dually Flat Geometry & Pythagorean Theorem
public export
auditAmariPythagoreanTheoremProofExport : Bool
auditAmariPythagoreanTheoremProofExport = Geometry.InformationGeometry.auditAmariPythagoreanTheoremProof

public export
%macro
auditAmariPythagoreanTheorem : Elab (Reflect.Auditor.Geometry.auditAmariPythagoreanTheoremProofExport = True)
auditAmariPythagoreanTheorem = auditWitness auditAmariPythagoreanTheoremProofExport

-- Witness 144: Law 30 (Discrete Lattice Boltzmann & Navier-Stokes Transport)
public export
auditLatticeFluidTransportProofExport : Bool
auditLatticeFluidTransportProofExport = Math.LatticeFluidTransport.auditLatticeFluidTransportProof

public export
%macro
auditLatticeFluidTransport : Elab (Reflect.Auditor.Geometry.auditLatticeFluidTransportProofExport = True)
auditLatticeFluidTransport = auditWitness auditLatticeFluidTransportProofExport

-- Witness 175: Discrete Galois Einstein Curvature Tensor & Metric Shear
public export
auditGaloisEinsteinCurvatureProofExport : Bool
auditGaloisEinsteinCurvatureProofExport = Geometry.GaloisCurvature.auditGaloisEinsteinCurvatureProof

public export
%macro
auditGaloisEinsteinCurvature : Elab (Reflect.Auditor.Geometry.auditGaloisEinsteinCurvatureProofExport = True)
auditGaloisEinsteinCurvature = auditWitness auditGaloisEinsteinCurvatureProofExport

