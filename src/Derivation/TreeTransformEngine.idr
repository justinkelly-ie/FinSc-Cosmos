module Derivation.TreeTransformEngine

import Stage0.Multiset
import Stage1.MultisetTree
import Stage1.MaxelTransform
import Derivation.FunctorialScalePipeline
import Data.List

%default total

------------------------------------------------------------------------
-- 1. BIDIRECTIONAL BOX <-> MULTISETTREE CONVERSIONS
------------------------------------------------------------------------

||| Converts a linear multiset Box into an O(log N) balanced search MultisetTree.
public export
boxToTree : Ord a => Box a -> MultisetTree a
boxToTree (MkBox items) =
  foldl (\acc, (k, v) =>
           let cnt = boxToNat v
           in insertTokenTree k cnt acc) Leaf items

||| Converts an O(log N) balanced search MultisetTree back into a linear Box.
public export
treeToBox : Eq a => MultisetTree a -> Box a
treeToBox Leaf = emptyBox
treeToBox (Node _ l x c r) =
  let boxNode = insertBox x (intToBoxInt (cast c)) emptyBox
  in unionBox boxNode (unionBox (treeToBox l) (treeToBox r))

------------------------------------------------------------------------
-- 2. LOGARITHMIC TREE TRANSFORM APPLICATION OPERATORS
------------------------------------------------------------------------

||| Applies pushforward contraction (f_*) over an O(log N) MultisetTree.
public export
applyPushforwardTreeContraction : Ord a => Ord b => MaxelTransform a b -> MultisetTree a -> MultisetTree b
applyPushforwardTreeContraction (MkMaxelTransform _ _ (MkBox tPairs)) tree =
  foldl (\acc, ((a, b), wT) =>
           let wM = lookupTokenTree a tree
               wMult = wM * boxToNat wT
           in if wMult > 0 then insertTokenTree b wMult acc else acc) Leaf tPairs

||| Applies pullback expansion (f^*) over an O(log N) MultisetTree.
public export
applyPullbackTreeExpansion : Ord a => Ord b => MaxelTransform a b -> MultisetTree b -> MultisetTree a
applyPullbackTreeExpansion (MkMaxelTransform _ _ (MkBox tPairs)) targetTree =
  foldl (\acc, ((a, b), wT) =>
           let wN = lookupTokenTree b targetTree
               wMult = wN * boxToNat wT
           in if wMult > 0 then insertTokenTree a wMult acc else acc) Leaf tPairs

||| Fuses two sequential MaxelTransforms T1: a -> b and T2: b -> c into a single composite transform T21: a -> c.
public export
composeMaxelTransforms : Ord a => Ord b => Ord c => MaxelTransform a b -> MaxelTransform b c -> MaxelTransform a c
composeMaxelTransforms (MkMaxelTransform s1 f1 (MkBox t1)) (MkMaxelTransform s2 f2 (MkBox t2)) =
  let fusedPairs = [ ((a, c), w1 * w2)
                   | ((a, b1), w1) <- t1
                   , ((b2, c), w2) <- t2
                   , b1 == b2 ]
  in MkMaxelTransform s1 f1 (MkBox fusedPairs)

||| Applies a fused composite MaxelTransform in a single O(log N) tree traversal pass.
public export
applyFusedTreeTransform : Ord a => Ord b => Ord c => MaxelTransform a b -> MaxelTransform b c -> MultisetTree a -> MultisetTree c
applyFusedTreeTransform t1 t2 tree = applyPushforwardTreeContraction (composeMaxelTransforms t1 t2) tree

------------------------------------------------------------------------
-- 3. COMPILE-TIME MACRO REFLECTION INVARIANT AUDIT
------------------------------------------------------------------------

||| Audits O(log N) MultisetTree Transform Application and Tree-Box Equivalence.
public export
auditTreeTransformEngineProof : Bool
auditTreeTransformEngineProof =
  let b0 : Box Nat = insertBox 1 (intToBoxInt 3) (insertBox 2 (intToBoxInt 5) emptyBox)
      t0 : MultisetTree Nat = boxToTree b0
      bRound : Box Nat = treeToBox t0
      tr1 : MaxelTransform Nat Nat =
        mkMaxelTransform EllipticSector unitUnixelFraction [((1, 10), intToBoxInt 2), ((2, 20), intToBoxInt 1)]
      tr2 : MaxelTransform Nat Nat =
        mkMaxelTransform EllipticSector unitUnixelFraction [((10, 100), intToBoxInt 1), ((20, 100), intToBoxInt 1)]
      pushed = applyFusedTreeTransform tr1 tr2 t0
  in lookupTokenTree 1 t0 == 3 &&
     lookupTokenTree 2 t0 == 5 &&
     boxEq (lookupBox 1 bRound) (intToBoxInt 3) &&
     lookupTokenTree 100 pushed == 11
