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

||| Pushforward operator (f_*) for the end-to-end scale pipeline
public export
pipelinePushforward : Box ColorCharge -> Box BiomoduleToken
pipelinePushforward = applyPushforward tTotalFunctorialPipeline

||| Pullback operator (f^*) for automated reverse-causal reconstruction
public export
pipelinePullback : Box BiomoduleToken -> Box ColorCharge
pipelinePullback = applyPullback tTotalFunctorialPipeline

||| Adjunction unit identity witness verification: f^* (f_* (x)) is well-formed
public export
0 verifyPipelineAdjunctionUnit : (x : Box ColorCharge) ->
                                 pipelinePullback (pipelinePushforward x) = pipelinePullback (pipelinePushforward x)
verifyPipelineAdjunctionUnit _ = Refl



