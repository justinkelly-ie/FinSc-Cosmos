module TestCompoundWitness

import Compound.SymplecticIntegrator
import Compound.VelocityLensing
import Compound.AstrophysicalAggregation
import Core.BoxInt
import Language.Reflection

%default total

public export
auditSymplecticStepProofExport : Bool
auditSymplecticStepProofExport = Compound.SymplecticIntegrator.auditSymplecticStepProof

export
%macro
auditSymplecticStep : Elab (TestCompoundWitness.auditSymplecticStepProofExport = True)
auditSymplecticStep = pure Refl
