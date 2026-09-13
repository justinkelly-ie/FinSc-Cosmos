module Derivation.FunctorialScalePipeline

import public Core.TransformMultiset
import public Core.VexelMaxel
import public Core.ScaleCategory
import public Core.ScalePipeline

%default total

public export
auditFunctorialPipelineProof : Bool
auditFunctorialPipelineProof = Core.ScalePipeline.auditFunctorialPipelineProof

||| Type-level ScaleFunctor pipeline derivation witness
public export
auditScaleFunctorPipelineDerivationProof : Bool
auditScaleFunctorPipelineDerivationProof =
  let transformPipeline = sfTotalFunctorialPipeline.transform
  in transformPipeline.sector == EllipticSector

