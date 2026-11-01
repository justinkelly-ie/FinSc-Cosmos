module Compound.VelocityLensing

import Evolution.State
import Evolution.StructuralAccounting
import Stage1.LinAlgebra.MetricTensor
import Stage1.Math.Infinitesimal
import Compound.LinearEpsilonRouting
import Stage0.BoxInt
import Stage1.Basis.Coordinate
import Data.Vect
import Stage1.DihedronModel as DM
import Stage1.TypeTheory.Staging

%default total

------------------------------------------------------------------------
-- 1. LINEAR VELOCITY LENSING ACROSS METRIC SCALES
------------------------------------------------------------------------

||| Linearly lenses a velocity Vexel across a scale change with pure structural accounting.
||| Contracts the metric Maxel against the velocity Vexel and applies inductive Dark Matter drag.
public export
lensVelocityAcrossScale : {vm, de, dm : Nat} ->
                          (state : UniverseState vm de dm) ->
                          (metric : Maxel) ->
                          (velocity : Vexel) ->
                          Vexel
lensVelocityAcrossScale (MkUniverseState vm de dm) metric vel =
  let drag = sumStructural dm
      scaleFactor = intToBoxInt 1 + drag
      unscaled = actMaxelVexel metric vel
  in mapBoxTreeWeight (\w => w `div` scaleFactor) unscaled

------------------------------------------------------------------------
-- 2. RELATIVISTIC DEFLECTION & VELOCITY ABERRATION ON T^3
------------------------------------------------------------------------

||| Computes relativistic discrete gravitational light deflection angle d\theta:
||| d\theta = (4 * G * M * scale) / (b * (1 + drag))
public export
relativisticDeflectionAngle : (gConst : BoxInt) -> (mass : BoxInt) -> (impactB : BoxInt) -> 
                              (drag : BoxInt) -> (scale : BoxInt) -> BoxInt
relativisticDeflectionAngle g m b drag scale =
  let num = intToBoxInt 4 * g * m * scale
      denom = b * (intToBoxInt 1 + drag)
      denVal = if denom == intToBoxInt 0 then intToBoxInt 1 else denom
  in num `div` denVal

------------------------------------------------------------------------
-- 3. CONSTRUCTIVE FORMAL AUDIT PROOFS
--    (Relativistic Velocity Lensing Invariants)
------------------------------------------------------------------------

||| Audits Relativistic Deflection with Dark Matter Drag Attenuation:
||| For G = 10, M = 100, b = 20, drag = 3, scale = 10:
||| d\theta = (4 * 10 * 100 * 10) / (20 * (1 + 3)) = 40000 / (20 * 4) = 40000 / 80 = 500.
public export
auditRelativisticVelocityLensingProof : Bool
auditRelativisticVelocityLensingProof =
  let theta = relativisticDeflectionAngle (intToBoxInt 10) (intToBoxInt 100) (intToBoxInt 20) (intToBoxInt 3) (intToBoxInt 10)
  in theta == intToBoxInt 500

------------------------------------------------------------------------
-- 4. 2LTT STAGED PROJECTIVE VELOCITY LENSING
------------------------------------------------------------------------

||| 2LTT Staged Projective Velocity Lensing:
||| Combines multi-lens deflection in homogeneous projective coordinates (V, D) at Level 1,
||| preserving exact rational denominators without intermediate rounding.
public export
stagedLensVelocityProjective : Lift (Vect 3 BoxInt, BoxInt) ->
                               Lift (Vect 3 BoxInt, BoxInt) ->
                               Code (Vect 3 BoxInt, BoxInt)
stagedLensVelocityProjective qV1 qV2 =
  DM.stagedVelocityAdditionProjective qV1 qV2

||| Staged evaluation of projective velocity lensing:
public export
evalStagedLensVelocityProjective : Lift (Vect 3 BoxInt, BoxInt) ->
                                   Lift (Vect 3 BoxInt, BoxInt) ->
                                   (Vect 3 BoxInt, BoxInt)
evalStagedLensVelocityProjective qV1 qV2 =
  splice (stagedLensVelocityProjective qV1 qV2)

||| QTT 0 Erased Proof Witness: Staged Velocity Lensing Invariant
public export
0 prfStagedLensVelocityProjective : (v1, v2 : (Vect 3 BoxInt, BoxInt)) ->
                                   splice (stagedLensVelocityProjective (quote v1) (quote v2)) =
                                     DM.velocityAdditionProjective v1 v2
prfStagedLensVelocityProjective _ _ = Refl

------------------------------------------------------------------------
-- 5. THE HOMOGENEOUS PROJECTIVE MULTI-LENS DEFLECTION ALGEBRA (LensingChain)
------------------------------------------------------------------------

||| Chain of gravitational lens deflections in projective homogeneous coordinates:
public export
data LensingChain : Type where
  NilLensing  : LensingChain
  ConsLensing : (Vect 3 BoxInt, BoxInt) -> LensingChain -> LensingChain

||| Base projective identity velocity: ( [0, 0, 0], 1 ).
public export
identityProjectiveVelocity : (Vect 3 BoxInt, BoxInt)
identityProjectiveVelocity = ([intToBoxInt 0, intToBoxInt 0, intToBoxInt 0], intToBoxInt 1)

||| Structurally collapses a LensingChain into a single effective projective deflection:
public export
collapseLensingChain : LensingChain -> (Vect 3 BoxInt, BoxInt)
collapseLensingChain NilLensing = identityProjectiveVelocity
collapseLensingChain (ConsLensing lens rest) =
  DM.velocityAdditionProjective lens (collapseLensingChain rest)

||| 2LTT Staged Multi-Lens Deflection Compiler:
||| Combines an arbitrary number of gravitational lenses into a single (V_eff, D_eff) deflection at Level 1,
||| preserving exact rational denominators across the entire telescope baseline.
public export
stagedCompileLensingChain : LensingChain -> Code (Vect 3 BoxInt, BoxInt)
stagedCompileLensingChain chain =
  let eff = collapseLensingChain chain
  in quote eff

||| Staged evaluation of multi-lens deflection compiler:
public export
evalStagedCompileLensingChain : LensingChain -> (Vect 3 BoxInt, BoxInt)
evalStagedCompileLensingChain chain =
  splice (stagedCompileLensingChain chain)

||| QTT 0 Erased Proof Witness: Multi-Lens Deflection Staged Compilation Soundness
public export
0 prfStagedCompileLensingChain : (chain : LensingChain) ->
                                splice (stagedCompileLensingChain chain) =
                                  collapseLensingChain chain
prfStagedCompileLensingChain _ = Refl

||| Audit: Staged LensingChain combines multiple lenses and preserves exact non-zero denominator:
public export
auditLensingChainPreservation : Bool
auditLensingChainPreservation =
  let l1 = ([intToBoxInt 1, intToBoxInt 0, intToBoxInt 0], intToBoxInt 10)
      l2 = ([intToBoxInt 0, intToBoxInt 1, intToBoxInt 0], intToBoxInt 10)
      chain = ConsLensing l1 (ConsLensing l2 NilLensing)
      (vEff, dEff) = evalStagedCompileLensingChain chain
  in dEff /= intToBoxInt 0



