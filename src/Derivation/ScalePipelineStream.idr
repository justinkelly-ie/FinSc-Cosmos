module Derivation.ScalePipelineStream

import Data.List
import Data.Fuel
import Math.OnSeq.FusedStream
import Derivation.FunctorialScalePipeline
import Core.ScaleCategory

%default total

------------------------------------------------------------------------
-- 1. DEFORESTED MULTI-TIER SCALE PIPELINE STREAMING
------------------------------------------------------------------------

||| Deforested stream pushforward transformation over color charge boxes across scale jumps.
public export
fusedPipelinePushforward : FusedStream (Box ColorCharge) -> FusedStream (Box BiomoduleToken)
fusedPipelinePushforward = mapStream pipelinePushforward

||| Deforested stream pullback transformation for reverse-causal reconstruction.
public export
fusedPipelinePullback : FusedStream (Box BiomoduleToken) -> FusedStream (Box ColorCharge)
fusedPipelinePullback = mapStream pipelinePullback

||| Converts a List of ColorCharge boxes into a deforested stream.
public export
streamColorCharges : List (Box ColorCharge) -> FusedStream (Box ColorCharge)
streamColorCharges = stream

||| Evaluates a BiomoduleToken stream into a List container.
public export
runBiomoduleStream : Fuel -> FusedStream (Box BiomoduleToken) -> List (Box BiomoduleToken)
runBiomoduleStream = runFueledStream

||| Evaluates an end-to-end multiscale pipeline pushforward/pullback roundtrip stream.
public export covering
fusedScalePipelineHylomorphism : Fuel -> List (Box ColorCharge) -> List (Box ColorCharge)
fusedScalePipelineHylomorphism f charges =
  let pushStrm = fusedPipelinePushforward (stream charges)
      pullStrm = fusedPipelinePullback pushStrm
  in runFueledStream f pullStrm

||| Conjugate Hylomorphism: Forward pushforward streaming conjugated by Galois pullback dual (f_* ⊣ f^*).
public export
fusedConjugateHylomorphism : FusedStream (Box ColorCharge) -> FusedStream (Box ColorCharge)
fusedConjugateHylomorphism strm =
  fusedPipelinePullback (fusedPipelinePushforward strm)

||| Zero-Allocation Default Execution Engine for Scale Pipeline Jumps
public export covering
runScalePipelineDefault : List (Box ColorCharge) -> List (Box ColorCharge)
runScalePipelineDefault = fusedScalePipelineHylomorphism (limit 100)

||| Equivalence witness asserting static pipeline behavior matches fused streaming engine.
public export covering
auditStreamingScalePipelineEquivalence : List (Box ColorCharge) -> Bool
auditStreamingScalePipelineEquivalence inputs =
  let staticRes = map (pipelinePullback . pipelinePushforward) inputs
      streamRes = runScalePipelineDefault inputs
  in staticRes == streamRes

