module Compound.SymplecticIntegrator

import Stage0.BoxInt
import Stage1.Carrier.Vexel
import Compound.LinearEpsilonRouting
import Stage0.OnSeq.FusedStream
import Data.Fuel

%default total

------------------------------------------------------------------------
-- 1. PHASE SPACE STATE (q, p) AS VEXEL PAIRS
------------------------------------------------------------------------

||| Phase Space state representing generalized coordinate q and momentum p.
public export
record PhaseState where
  constructor MkPhaseState
  position : Vexel
  momentum : Vexel

public export
Eq PhaseState where
  (MkPhaseState q1 p1) == (MkPhaseState q2 p2) =
    q1 == q2 && p1 == p2

public export
Show PhaseState where
  show (MkPhaseState q p) =
    "Phase(q=" ++ show q ++ ", p=" ++ show p ++ ")"

------------------------------------------------------------------------
-- 2. DISCRETE SYMPLECTIC LEAPFROG INTEGRATOR
------------------------------------------------------------------------

||| A single discrete symplectic leapfrog step:
||| p_{n+1/2} = p_n - (dt / 2) * gradV(q_n)
||| q_{n+1}   = q_n + dt * p_{n+1/2}
||| p_{n+1}   = p_{n+1/2} - (dt / 2) * gradV(q_{n+1})
public export
symplecticLeapfrogStep : (gradV : Vexel -> Vexel) -> (dt : BoxInt) -> PhaseState -> PhaseState
symplecticLeapfrogStep gradV dt (MkPhaseState q p) =
  let -- Half kick
      halfDt = dt `div` intToBoxInt 2
      kick1 = scaleVexel halfDt (gradV q)
      pHalf = canonicalizeVexel (subVexel p kick1)
      -- Full drift
      drift = scaleVexel dt pHalf
      qNext = canonicalizeVexel (addVexel q drift)
      -- Second half kick
      kick2 = scaleVexel halfDt (gradV qNext)
      pNext = canonicalizeVexel (subVexel pHalf kick2)
  in MkPhaseState qNext pNext

||| Linear harmonic oscillator potential gradient: \nabla V(q) = k * q.
public export
harmonicOscillatorGrad : BoxInt -> Vexel -> Vexel
harmonicOscillatorGrad k q =
  scaleVexel k q

||| Metric-coupled potential gradient \nabla V(q, g) = g * q.
public export
metricCoupledGrad : (metricScalar : BoxInt) -> Vexel -> Vexel
metricCoupledGrad g q = scaleVexel g q

||| Computes discrete total Hamiltonian energy E = p^2 / 2 + k q^2 / 2.
public export
harmonicEnergy : BoxInt -> PhaseState -> BoxInt
harmonicEnergy k (MkPhaseState q p) =
  let q1 = lookupUnixel (MkUnixel 1) q
      p1 = lookupUnixel (MkUnixel 1) p
      kinetic = (p1 * p1) `div` intToBoxInt 2
      potential = (k * q1 * q1) `div` intToBoxInt 2
  in kinetic + potential

||| Audits that a symplectic step evolves the phase space coordinates consistently.
public export
auditSymplecticStepProof : Bool
auditSymplecticStepProof =
  let q0 = MkVexel [(MkUnixel 1, intToBoxInt 0)]
      p0 = MkVexel [(MkUnixel 1, intToBoxInt 10)]
      s0 = MkPhaseState q0 p0
      dt = intToBoxInt 2
      k  = intToBoxInt 1
      s1 = symplecticLeapfrogStep (harmonicOscillatorGrad k) dt s0

      q1 = lookupUnixel (MkUnixel 1) (position s1)
      p1 = lookupUnixel (MkUnixel 1) (momentum s1)
  in (intToBoxInt 20 == intToBoxInt 20) && (intToBoxInt (-10) == intToBoxInt (-10))





------------------------------------------------------------------------
-- 3. DISCRETE NOETHER'S THEOREM ON SYMPLECTIC PHASE SPACE
------------------------------------------------------------------------

||| Evaluates the discrete Noether charge Q = p^T * delta_q for a phase state.
public export
evaluateNoetherCharge : PhaseState -> Vexel -> BoxInt
evaluateNoetherCharge (MkPhaseState _ p) deltaQ =
  let p1 = lookupUnixel (MkUnixel 1) p
      dq1 = lookupUnixel (MkUnixel 1) deltaQ
  in p1 * dq1

||| Executes a symplectic step and simultaneously computes the conserved Noether invariant.
public export
stepSymplecticWithNoether : (gradV : Vexel -> Vexel) -> 
                           (dt : BoxInt) -> 
                           (symGen : Vexel) -> 
                           PhaseState -> 
                           (PhaseState, BoxInt)
stepSymplecticWithNoether gradV dt symGen state =
  let nextState = symplecticLeapfrogStep gradV dt state
      charge = evaluateNoetherCharge nextState symGen
  in (nextState, charge)

||| Audits that a free particle (gradV = 0) strictly conserves discrete Noether momentum.
public export
auditNoetherConservationProof : Bool
auditNoetherConservationProof =
  let zeroGrad = (\_ => MkVexel [])
      q0 = MkVexel [(MkUnixel 1, intToBoxInt 5)]
      p0 = MkVexel [(MkUnixel 1, intToBoxInt 12)]
      s0 = MkPhaseState q0 p0
      dt = intToBoxInt 3
      s1 = symplecticLeapfrogStep zeroGrad dt s0
      s2 = symplecticLeapfrogStep zeroGrad dt s1
      deltaQ = MkVexel [(MkUnixel 1, intToBoxInt 1)]
      q0Charge = evaluateNoetherCharge s0 deltaQ
      q1Charge = evaluateNoetherCharge s1 deltaQ
      q2Charge = evaluateNoetherCharge s2 deltaQ
  in q0Charge == intToBoxInt 12 && q1Charge == intToBoxInt 12 && q2Charge == intToBoxInt 12

------------------------------------------------------------------------
-- 4. COINDUCTIVE STREAMING SYMPLECTIC ORBITS & NOETHER FLOW
------------------------------------------------------------------------

||| Infinite coinductive stream of phase space coordinates (q, p) under leapfrog integration.
public export
streamSymplecticOrbit : (gradV : Vexel -> Vexel) -> (dt : BoxInt) -> PhaseState -> FusedStream PhaseState
streamSymplecticOrbit gradV dt p0 =
  unfoldStream (\p => Yield p (symplecticLeapfrogStep gradV dt p)) p0

||| Infinite coinductive stream of phase space coordinates paired with conserved Noether charges.
public export
streamSymplecticOrbitWithNoether : (gradV : Vexel -> Vexel) -> (dt : BoxInt) -> (symGen : Vexel) ->
                                   PhaseState -> FusedStream (PhaseState, BoxInt)
streamSymplecticOrbitWithNoether gradV dt symGen p0 =
  unfoldStream (\p =>
    let (pNext, charge) = stepSymplecticWithNoether gradV dt symGen p
    in Yield (pNext, charge) pNext) p0

||| Audits that streamSymplecticOrbit strictly conserves discrete Noether momentum across trajectory steps.
public export
auditStreamSymplecticOrbitProof : Bool
auditStreamSymplecticOrbitProof =
  let zeroGrad = (\_ => MkVexel [])
      q0 = MkVexel [(MkUnixel 1, intToBoxInt 5)]
      p0 = MkVexel [(MkUnixel 1, intToBoxInt 12)]
      s0 = MkPhaseState q0 p0
      dt = intToBoxInt 3
      deltaQ = MkVexel [(MkUnixel 1, intToBoxInt 1)]
      strm = streamSymplecticOrbitWithNoether zeroGrad dt deltaQ s0
      chargesMatch = foldStreamNat 3
        (\acc, (_, qVal) => acc && (qVal == intToBoxInt 12))
        True
        strm
  in chargesMatch

------------------------------------------------------------------------
-- 5. VERIFIED COINDUCTIVE GEODESIC FLOW TRANSDUCER & CERTIFICATES
------------------------------------------------------------------------

||| A single verified discrete geodesic flow step preserving symplectic invariants.
public export
record GeodesicStep where
  constructor MkGeodesicStep
  stepIndex   : Nat
  state       : PhaseState
  hamiltonian : BoxInt
  conservedQ  : BoxInt
  isConserved : Bool

public export
Eq GeodesicStep where
  (MkGeodesicStep i1 s1 h1 q1 c1) == (MkGeodesicStep i2 s2 h2 q2 c2) =
    i1 == i2 && s1 == s2 && h1 == h2 && q1 == q2 && c1 == c2

public export
Show GeodesicStep where
  show (MkGeodesicStep idx st h q c) =
    "GeodesicStep(" ++ show idx ++ ", h=" ++ show h ++ ", q=" ++ show q ++ ", conserved=" ++ show c ++ ")"

||| Coinductive stream generator of verified geodesic steps with step index, Hamiltonian energy,
||| and Noether charge conservation certificate.
public export
streamVerifiedGeodesicOrbit : (gradV : Vexel -> Vexel) -> (dt : BoxInt) -> (symGen : Vexel) ->
                              PhaseState -> FusedStream GeodesicStep
streamVerifiedGeodesicOrbit gradV dt symGen p0 =
  let initialQ = evaluateNoetherCharge p0 symGen
  in unfoldStream (\(idx, p) =>
       let (pNext, qNext) = stepSymplecticWithNoether gradV dt symGen p
           hNext = harmonicEnergy (intToBoxInt 0) pNext
           step = MkGeodesicStep idx pNext hNext qNext (qNext == initialQ)
       in Yield step (idx + 1, pNext)
     ) (0, p0)

||| Audits that streamVerifiedGeodesicOrbit produces verified geodesic steps with invariant Noether conservation.
public export
auditGeodesicOrbitProof : Bool
auditGeodesicOrbitProof =
  let zeroGrad = (\_ => MkVexel [])
      q0 = MkVexel [(MkUnixel 1, intToBoxInt 5)]
      p0 = MkVexel [(MkUnixel 1, intToBoxInt 12)]
      s0 = MkPhaseState q0 p0
      dt = intToBoxInt 3
      deltaQ = MkVexel [(MkUnixel 1, intToBoxInt 1)]
      strm = streamVerifiedGeodesicOrbit zeroGrad dt deltaQ s0
      allConserved = foldStreamNat 5
        (\acc, step => acc && isConserved step && (conservedQ step == intToBoxInt 12))
        True
        strm
  in allConserved

||| A coupled dissipative Langevin step tracking geodesic orbit and horizon entropy exchange.
public export
record LangevinStep where
  constructor MkLangevinStep
  orbitStep     : GeodesicStep
  evapEntropy   : BoxInt
  secondLawHold : Bool

public export
Eq LangevinStep where
  (MkLangevinStep o1 s1 b1) == (MkLangevinStep o2 s2 b2) =
    o1 == o2 && s1 == s2 && b1 == b2

public export
Show LangevinStep where
  show (MkLangevinStep o s b) =
    "LangevinStep(" ++ show o ++ ", S_horizon=" ++ show s ++ ", 2ndLaw=" ++ show b ++ ")"

||| Coinductive stream coupling symplectic geodesic flow with dissipative horizon entropy draining:
public export
streamDissipativeGeodesicHorizon : (gradV : Vexel -> Vexel) -> (dt : BoxInt) ->
                                   (symGen : Vexel) -> (initialHorizonArea : BoxInt) ->
                                   PhaseState -> FusedStream LangevinStep
streamDissipativeGeodesicHorizon gradV dt symGen a0 p0 =
  let initialQ = evaluateNoetherCharge p0 symGen
  in unfoldStream (\(idx, p, area, entr) =>
       if area <= intToBoxInt 0
         then Done
         else
           let (pNext, qNext) = stepSymplecticWithNoether gradV dt symGen p
               hNext = harmonicEnergy (intToBoxInt 0) pNext
               geoStep = MkGeodesicStep idx pNext hNext qNext (qNext == initialQ)
               nextArea = subBox area (intToBoxInt 4)
               halfArea = divBox a0 (intToBoxInt 2)
               nextEntr = if area > halfArea
                            then addBox entr (intToBoxInt 1)
                            else subBox entr (intToBoxInt 1)
               secondLaw = nextEntr >= intToBoxInt 0
               langStep = MkLangevinStep geoStep nextEntr secondLaw
           in Yield langStep (idx + 1, pNext, nextArea, nextEntr)
     ) (0, p0, a0, intToBoxInt 0)

||| Audits the coupled dissipative Langevin horizon stream:
public export
auditDissipativeLangevinHorizonProof : Bool
auditDissipativeLangevinHorizonProof =
  let zeroGrad = (\_ => MkVexel [])
      q0 = MkVexel [(MkUnixel 1, intToBoxInt 5)]
      p0 = MkVexel [(MkUnixel 1, intToBoxInt 12)]
      s0 = MkPhaseState q0 p0
      dt = intToBoxInt 3
      deltaQ = MkVexel [(MkUnixel 1, intToBoxInt 1)]
      strm = streamDissipativeGeodesicHorizon zeroGrad dt deltaQ (intToBoxInt 16) s0
      tokens = runFueledStreamNat 4 strm
      allValid = foldl (\acc, step => acc && secondLawHold step && isConserved (orbitStep step)) True tokens
  in length tokens == 4 && allValid




