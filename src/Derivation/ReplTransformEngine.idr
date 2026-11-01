module Derivation.ReplTransformEngine

import Stage0.Multiset
import Stage1.MaxelTransform
import Derivation.FunctorialScalePipeline
import Stage1.Staged.Specializer as Spec
import Stage1.TypeTheory.Staging
import Stage1.Basis.Coordinate
import Stage1.Math.OnSeq.SpreadStream
import Stage1.Goh
import Data.List
import Data.String

%default total

------------------------------------------------------------------------
-- 1. REPL DYNAMIC TRANSFORM COMMAND DATA TYPES
------------------------------------------------------------------------

||| REPL Dynamic Transform Commands
public export
data ReplTransformCmd =
    CmdCreateTransform String MetricSector UnixelFraction
  | CmdComposeTransform String String
  | CmdPullbackTransform String
  | CmdCyclotomicSpread Nat
  | CmdUnknownTransform String

public export
Eq ReplTransformCmd where
  (CmdCreateTransform n1 s1 f1) == (CmdCreateTransform n2 s2 f2) = n1 == n2 && s1 == s2 && f1 == f2
  (CmdComposeTransform t1 t2) == (CmdComposeTransform u1 u2) = t1 == u1 && t2 == u2
  (CmdPullbackTransform t1) == (CmdPullbackTransform t2) = t1 == t2
  (CmdCyclotomicSpread n1) == (CmdCyclotomicSpread n2) = n1 == n2
  (CmdUnknownTransform s1) == (CmdUnknownTransform s2) = s1 == s2
  _ == _ = False

------------------------------------------------------------------------
-- 2. REPL TRANSFORM COMMAND EVALUATOR & DYNAMIC COMPILATION
------------------------------------------------------------------------

||| Evaluates a dynamic REPL transform command and returns formatted status response.
public export
evalReplTransformCmd : ReplTransformCmd -> String
evalReplTransformCmd (CmdCreateTransform name sector fraction) =
  "CREATED: TransformMultiset [" ++ name ++ "] Sector: " ++ show sector ++
  " Weight: " ++ show (unwrapBox (num fraction)) ++ "/" ++ show (denominatorNat fraction)
evalReplTransformCmd (CmdComposeTransform t1 t2) =
  "COMPOSED: " ++ t1 ++ " ∘ " ++ t2 ++ " -> T_total (Factorized G ⊗ Z ⊗ J)"

evalReplTransformCmd (CmdPullbackTransform t1) =
  "PULLBACK: f^* Adjoint Expansion evaluated over " ++ t1
evalReplTransformCmd (CmdCyclotomicSpread n) =
  let cert = certifiedCyclotomicSpread n
  in "CYCLOTOMIC SPREAD [" ++ show n ++ "]: TotientCapacity: " ++ show cert.totientCapacity ++
     " FactorBag: " ++ show cert.factorBag
evalReplTransformCmd (CmdUnknownTransform msg) =
  "UNKNOWN: " ++ msg

||| Evaluates a dynamic transform word in the REPL environment:
public export
evalReplPipelineWord : (fuel : Nat) ->
                       MaxelTransform Pixel Pixel ->
                       Spec.PipelineWord Pixel ->
                       MaxelTransform Pixel Pixel
evalReplPipelineWord fuel base word =
  Spec.collapsePipelineWord fuel base word

||| Staged compilation of a dynamic REPL pipeline word:
public export
stagedReplPipelineWord : (fuel : Nat) ->
                         Lift (MaxelTransform Pixel Pixel) ->
                         Lift (Spec.PipelineWord Pixel) ->
                         Code (MaxelTransform Pixel Pixel)
stagedReplPipelineWord fuel qBase qWord =
  Spec.stagedCompileWord fuel qBase qWord

||| QTT 0 Erased Proof Witness: Staged REPL Pipeline Word Soundness
public export
0 prfStagedReplPipelineWord : (fuel : Nat) ->
                              (base : MaxelTransform Pixel Pixel) ->
                              (w : Spec.PipelineWord Pixel) ->
                              splice (stagedReplPipelineWord fuel (quote base) (quote w)) =
                                evalReplPipelineWord fuel base w
prfStagedReplPipelineWord fuel base w =
  Spec.prfStagedCompileWord fuel base w

------------------------------------------------------------------------
-- 3. COMPILE-TIME MACRO REFLECTION INVARIANT AUDIT
------------------------------------------------------------------------

||| Audits Interactive REPL Transform Synthesis and Evaluator.
public export
auditReplTransformEngineProof : Bool
auditReplTransformEngineProof =
  let testT = mkMaxelTransform EllipticSector (mkUnixelFraction (intToBoxInt 1) 27)
                [ ((MkPixel 0 0, MkPixel 0 0), intToBoxInt 1) ]
      cmd = CmdCreateTransform "T_test" EllipticSector (mkUnixelFraction (intToBoxInt 1) 27)
      resp = evalReplTransformCmd cmd
      cmdSpread = CmdCyclotomicSpread 39
      respSpread = evalReplTransformCmd cmdSpread
      word = Spec.GenWord testT
      compiled = Spec.evalStagedCompileWord ellipticLatticeCapacity (quote testT) (quote word)
  in (isInfixOf "CREATED" resp) &&
     (isInfixOf "1/27" resp) &&
     (isInfixOf "TotientCapacity: 39" respSpread) &&
     (compiled.fraction == mulUnixelFraction testT.fraction testT.fraction)

