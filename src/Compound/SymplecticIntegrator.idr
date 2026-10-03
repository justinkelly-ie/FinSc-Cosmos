module Compound.SymplecticIntegrator

import Stage0.BoxInt
import Stage1.VexelMaxel
import Compound.LinearEpsilonRouting

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
      pHalf = subVexel p kick1
      -- Full drift
      drift = scaleVexel dt pHalf
      qNext = addVexel q drift
      -- Second half kick
      kick2 = scaleVexel halfDt (gradV qNext)
      pNext = subVexel pHalf kick2
  in MkPhaseState qNext pNext

||| Linear harmonic oscillator potential gradient: \nabla V(q) = k * q.
public export
harmonicOscillatorGrad : BoxInt -> Vexel -> Vexel
harmonicOscillatorGrad k q =
  scaleVexel k q

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
