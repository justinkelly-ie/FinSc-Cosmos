module Reflect.Auditor.Geometry

import public Stage0.BoxInt
import public Stage1.Order.Preorder
import public Stage1.InformationGeometry
import public Stage1.ExclusionPrinciple
import public Derivation.PureGeometricClassifier
import public Stage1.Math.LatticeFluidTransport
import public Geometry.GaloisCurvature
import public Reflect.Auditor.Core
import Language.Reflection

%default total

------------------------------------------------------------------------
-- COMPILE-TIME REFLECTION AUDITS: GEOMETRY DOMAIN
------------------------------------------------------------------------

-- Witness 15: Hyperbolic Bit Duality
public export
auditHyperbolicBitDualityProofExport : Bool
auditHyperbolicBitDualityProofExport = Stage1.InformationGeometry.auditHyperbolicBitDualityProof

public export
%macro
auditHyperbolicBitDuality : Elab (Reflect.Auditor.Geometry.auditHyperbolicBitDualityProofExport = True)
auditHyperbolicBitDuality = auditWitness auditHyperbolicBitDualityProofExport

-- Witness 16: Clifford Compactness Duality
public export
auditCliffordCompactnessDualityProofExport : Bool
auditCliffordCompactnessDualityProofExport = Stage1.InformationGeometry.auditCliffordCompactnessDualityProof

public export
%macro
auditCliffordCompactnessDuality : Elab (Reflect.Auditor.Geometry.auditCliffordCompactnessDualityProofExport = True)
auditCliffordCompactnessDuality = auditWitness auditCliffordCompactnessDualityProofExport

-- Witness 18: Holographic Boundary Duality
public export
auditHolographicBoundaryDualityProofExport : Bool
auditHolographicBoundaryDualityProofExport = Stage1.InformationGeometry.auditHolographicBoundaryDualityProof

public export
%macro
auditHolographicBoundaryDuality : Elab (Reflect.Auditor.Geometry.auditHolographicBoundaryDualityProofExport = True)
auditHolographicBoundaryDuality = auditWitness auditHolographicBoundaryDualityProofExport

-- Witness 19: Yang-Mills Plaquette Cross-Entropy
public export
auditYangMillsPlaquetteCrossEntropyProofExport : Bool
auditYangMillsPlaquetteCrossEntropyProofExport = Stage1.InformationGeometry.auditYangMillsPlaquetteCrossEntropyProof

public export
%macro
auditYangMillsPlaquetteCrossEntropy : Elab (Reflect.Auditor.Geometry.auditYangMillsPlaquetteCrossEntropyProofExport = True)
auditYangMillsPlaquetteCrossEntropy = auditWitness auditYangMillsPlaquetteCrossEntropyProofExport

-- Witness 21: Multi-Scale Renormalization Group
public export
auditRenormalizationInvarianceProofExport : Bool
auditRenormalizationInvarianceProofExport = Stage1.InformationGeometry.auditRenormalizationInvarianceProof

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
auditGrassmannNilpotencyProofExport = Stage1.ExclusionPrinciple.auditGrassmannNilpotencyProof

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
auditWassersteinMetricAxiomsProofExport = Stage1.InformationGeometry.auditWassersteinMetricAxiomsProof

public export
%macro
auditWassersteinMetricAxioms : Elab (Reflect.Auditor.Geometry.auditWassersteinMetricAxiomsProofExport = True)
auditWassersteinMetricAxioms = auditWitness auditWassersteinMetricAxiomsProofExport

-- Witness 126: Exact Quantum Relative Entropy & Klein's Inequality
public export
auditRelativeEntropyKleinsInequalityProofExport : Bool
auditRelativeEntropyKleinsInequalityProofExport = Stage1.InformationGeometry.auditRelativeEntropyKleinsInequalityProof

public export
%macro
auditRelativeEntropyKleinsInequality : Elab (Reflect.Auditor.Geometry.auditRelativeEntropyKleinsInequalityProofExport = True)
auditRelativeEntropyKleinsInequality = auditWitness auditRelativeEntropyKleinsInequalityProofExport

-- Witness 127: Discrete Amari Dually Flat Geometry & Pythagorean Theorem
public export
auditAmariPythagoreanTheoremProofExport : Bool
auditAmariPythagoreanTheoremProofExport = Stage1.InformationGeometry.auditAmariPythagoreanTheoremProof

public export
%macro
auditAmariPythagoreanTheorem : Elab (Reflect.Auditor.Geometry.auditAmariPythagoreanTheoremProofExport = True)
auditAmariPythagoreanTheorem = auditWitness auditAmariPythagoreanTheoremProofExport

-- Witness 144: Law 30 (Discrete Lattice Boltzmann & Navier-Stokes Transport)
public export
auditLatticeFluidTransportProofExport : Bool
auditLatticeFluidTransportProofExport = Stage1.Math.LatticeFluidTransport.auditLatticeFluidTransportProof

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

------------------------------------------------------------------------
-- BATCH CATALOG WITNESS REFLECTION AUDITOR
------------------------------------------------------------------------

public export
geometryCatalogWitnesses : List Bool
geometryCatalogWitnesses =
  [ auditHyperbolicBitDualityProofExport
  , auditCliffordCompactnessDualityProofExport
  , auditHolographicBoundaryDualityProofExport
  , auditYangMillsPlaquetteCrossEntropyProofExport
  , auditRelativeEntropyKleinsInequalityProofExport
  , auditAmariPythagoreanTheoremProofExport
  , auditLatticeFluidTransportProofExport
  , auditGaloisEinsteinCurvatureProofExport
  ]

public export
%macro
auditGeometryCatalog : Elab (allTrue Reflect.Auditor.Geometry.geometryCatalogWitnesses = True)
auditGeometryCatalog = auditCatalogWitnesses geometryCatalogWitnesses


