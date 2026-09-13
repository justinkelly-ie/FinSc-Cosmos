module Reflect.Auditor.Compound

import public Compound.AstrophysicalAggregation
import public Compound.LinearEpsilonRouting
import public Compound.SymplecticIntegrator
import public Compound.VelocityLensing
import public Core.BoxInt
import public Reflect.Auditor.Core
import Language.Reflection

%default total

------------------------------------------------------------------------
-- COMPILE-TIME REFLECTION AUDITS: UNIVERSE COMPOUND DOMAIN
------------------------------------------------------------------------

-- Witness 1: Symplectic Phase Invariance
public export
auditSymplecticPhaseInvarianceProofExport : Bool
auditSymplecticPhaseInvarianceProofExport = Compound.SymplecticIntegrator.auditSymplecticStepProof

-- Witness 2: Relativistic Velocity Lensing Drag Attenuation
public export
auditRelativisticVelocityLensingProofExport : Bool
auditRelativisticVelocityLensingProofExport = Compound.VelocityLensing.auditRelativisticVelocityLensingProof

-- Witness 3: Astrophysical Aggregation Pushforward
public export
auditAstrophysicalAggregationProofExport : Bool
auditAstrophysicalAggregationProofExport = Compound.AstrophysicalAggregation.auditAstrophysicalAggregationProof

------------------------------------------------------------------------
-- BATCH CATALOG WITNESS REFLECTION AUDITOR
------------------------------------------------------------------------

public export
compoundCatalogWitnesses : List Bool
compoundCatalogWitnesses =
  [ auditSymplecticPhaseInvarianceProofExport
  , auditRelativisticVelocityLensingProofExport
  , auditAstrophysicalAggregationProofExport
  ]

public export
%macro
auditCompoundCatalog : Elab (allTrue Reflect.Auditor.Compound.compoundCatalogWitnesses = True)
auditCompoundCatalog = auditCatalogWitnesses compoundCatalogWitnesses
