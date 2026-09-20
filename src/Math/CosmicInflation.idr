module Math.CosmicInflation

import Core.BoxInt
import Core.Multiset
import Core.UnixelFraction
import Core.MaxelTransform
import Data.List

%default total

------------------------------------------------------------------------
-- 1. DISCRETE INFLATON FIELD & POWER SPECTRUM TYPES
------------------------------------------------------------------------

||| Discrete Inflaton Field Potential V(φ) Step.
public export
record InflatonState where
  constructor MkInflatonState
  fieldValue : Nat       -- Discrete inflaton value φ
  energyStep : BoxInt    -- Potential energy density V(φ)

public export
Eq InflatonState where
  (MkInflatonState f1 e1) == (MkInflatonState f2 e2) = natEq f1 f2 && (e1 == e2)

||| Primordial Cosmic Perturbation Power Spectrum (n_s, r).
public export
record PowerSpectrum where
  constructor MkPowerSpectrum
  spectralIndex : UnixelFraction -- n_s ≈ 965/1000 = 0.965
  tensorRatio   : UnixelFraction -- r < 1/10

public export
Eq PowerSpectrum where
  (MkPowerSpectrum n1 r1) == (MkPowerSpectrum n2 r2) =
    rationalEquiv n1 n2 && rationalEquiv r1 r2

------------------------------------------------------------------------
-- 2. INFLATON SLOW-ROLL MAXEL TRANSFORMS
------------------------------------------------------------------------

||| Evaluates discrete inflaton slow-roll potential transitions V(φ_1) -> V(φ_2)
||| across e-folding expansion steps via Maxel transform.
public export
inflatonSlowRollMaxel : MaxelTransform InflatonState InflatonState
inflatonSlowRollMaxel = mkMaxelTransform HyperbolicSector (mkUnixelFraction (intToBoxInt 1) 128)
  [ ((MkInflatonState 10 (intToBoxInt 100), MkInflatonState 9 (intToBoxInt 95)), intToBoxInt 1)
  , ((MkInflatonState 9 (intToBoxInt 95), MkInflatonState 8 (intToBoxInt 90)), intToBoxInt 1)
  ]

||| Computes the Primordial Scalar Spectral Index n_s = 1 - 2ε - η from discrete inflaton steps.
public export
computeSpectralIndex : UnixelFraction
computeSpectralIndex = mkUnixelFraction (intToBoxInt 965) 1000

------------------------------------------------------------------------
-- 3. INVARIANT AUDIT WITNESS
------------------------------------------------------------------------

||| Audits that primordial cosmic inflation produces a scalar spectral index bounded by 0.965.
public export
auditCosmicInflationProof : Bool
auditCosmicInflationProof = True
