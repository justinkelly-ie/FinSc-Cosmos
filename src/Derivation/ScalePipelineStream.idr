module Derivation.ScalePipelineStream

import Data.List
import Data.Fuel
import Stage0.BoxInt
import Stage0.OnSeq.FusedStream
import Stage1.MaxelTransform
import Stage1.ScalePipeline
import Derivation.FunctorialScalePipeline
import Stage1.MultisetDuality

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
public export
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

||| Zero-Allocation Default Execution Engine for Scale Pipeline Jumps bounded by structural input size.
public export
runScalePipelineDefault : List (Box ColorCharge) -> List (Box ColorCharge)
runScalePipelineDefault charges = fusedScalePipelineHylomorphism substrateFuel charges

||| Equivalence witness asserting static pipeline behavior matches fused streaming engine.
public export
auditStreamingScalePipelineEquivalence : List (Box ColorCharge) -> Bool
auditStreamingScalePipelineEquivalence inputs =
  let staticRes = map (pipelinePullback . pipelinePushforward) inputs
      streamRes = runScalePipelineDefault inputs
  in staticRes == streamRes

------------------------------------------------------------------------
-- 2. TOKEN-LEVEL ZERO-ALLOCATION SCALE PIPELINE STREAMING
------------------------------------------------------------------------

||| Zero-allocation token-level deforested scale pipeline pushforward:
||| Streams individual (ColorCharge, BoxInt) pairs through the 4-tier scale jumps
||| directly without constructing intermediate Box multiset wrappers.
public export
streamPipelinePushforwardTokens : FusedStream (ColorCharge, BoxInt) -> FusedStream (BiomoduleToken, BoxInt)
streamPipelinePushforwardTokens = streamMaxelAction tTotalFunctorialPipeline

||| Zero-allocation token-level deforested scale pipeline pullback:
public export
streamPipelinePullbackTokens : FusedStream (BiomoduleToken, BoxInt) -> FusedStream (ColorCharge, BoxInt)
streamPipelinePullbackTokens = streamMaxelAction (transposeMaxel tTotalFunctorialPipeline)

||| Deforested token roundtrip conjugate stream:
public export
streamTokenConjugateRoundtrip : FusedStream (ColorCharge, BoxInt) -> FusedStream (ColorCharge, BoxInt)
streamTokenConjugateRoundtrip strm =
  streamPipelinePullbackTokens (streamPipelinePushforwardTokens strm)

------------------------------------------------------------------------
-- 3. COSMOLOGICAL SPACETIME TRUNK STREAMING
------------------------------------------------------------------------

||| Deforested stream pushforward for the Cosmological Hadronization Stage (Quarks -> Hadrons).
public export
fusedCosmicHadronPushforward : FusedStream (Box ColorCharge) -> FusedStream (Box HadronToken)
fusedCosmicHadronPushforward = mapStream cosmicHadronPushforward

||| Deforested stream pullback for the Cosmological Hadronization Stage (Hadrons -> Quarks).
public export
fusedCosmicHadronPullback : FusedStream (Box HadronToken) -> FusedStream (Box ColorCharge)
fusedCosmicHadronPullback = mapStream cosmicHadronPullback

||| Token-level deforested stream pushforward for the Cosmological Hadronization Stage:
public export
streamCosmicHadronPushforwardTokens : FusedStream (ColorCharge, BoxInt) -> FusedStream (HadronToken, BoxInt)
streamCosmicHadronPushforwardTokens = streamMaxelAction tCosmicHadronizationPipeline

||| Token-level deforested stream pullback for the Cosmological Hadronization Stage:
public export
streamCosmicHadronPullbackTokens : FusedStream (HadronToken, BoxInt) -> FusedStream (ColorCharge, BoxInt)
streamCosmicHadronPullbackTokens = streamMaxelAction (transposeMaxel tCosmicHadronizationPipeline)

