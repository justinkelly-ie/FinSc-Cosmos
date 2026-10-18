module Stage1.Epoch.ObserverPredictions

import public Stage0.BoxInt
import public Stage0.Multiset
import public Stage1.UnixelFraction
import public Stage2.ThreeLevel
import public Stage1.Epoch.ChromogeometryLaw
import public Stage1.Epoch.ExpansionCollapse
import public Stage1.Epoch.Trajectory

%default total

--------------------------------------------------------------------------------
-- 1. OBSERVATIONAL COSMOLOGICAL PREDICTIONS PARAMETERIZED BY EPOCH (Rule 03 §7)
--------------------------------------------------------------------------------

||| Physical observational predictions derived from cosmological state budget closure.
public export
record ObservationalPredictions where
  constructor MkPredictions
  cmbSpectralTilt         : UnixelFraction   -- n_s = 1 - 2/DM = (DM - 2)/DM
  darkEnergyToBaryonRatio : UnixelFraction   -- DE / VM
  darkMatterToBaryonRatio : UnixelFraction   -- DM / VM

public export
Show ObservationalPredictions where
  show (MkPredictions ns deRatio dmRatio) =
    "Observational Predictions [n_s = " ++ show ns ++ 
    ", DE/VM = " ++ show deRatio ++ ", DM/VM = " ++ show dmRatio ++ "]"

||| Dynamically computes CMB spectral tilt n_s = 1 - 2/DM = (DM - 2)/DM from the DM law ledger.
public export
computeCMBSpectralTiltFromLedger : ChromogeometryLawLedger -> UnixelFraction
computeCMBSpectralTiltFromLedger ledger =
  let dmCount = countTotalDarkLaws ledger
      num = intToBoxInt (cast (minus dmCount 2))
  in mkUnixelFraction num dmCount

||| Computes testable observational predictions at any given epoch state.
public export
computeObserverPredictions : EpochState -> ObservationalPredictions
computeObserverPredictions st =
  let vm = st.visibleBaryons
      de = st.darkEnergy
      dm = countTotalDarkLaws st.darkMatterLedger
      nsFrac = computeCMBSpectralTiltFromLedger st.darkMatterLedger
      deFrac = mkUnixelFraction (intToBoxInt (cast de)) (cast vm)
      dmFrac = mkUnixelFraction (intToBoxInt (cast dm)) (cast vm)
  in MkPredictions nsFrac deFrac dmFrac

--------------------------------------------------------------------------------
-- 2. PARAMETERIZED CYCLE STATE FOR ARBITRARY EPOCH e
--------------------------------------------------------------------------------

||| Constructs a ParameterizedCycleState for arbitrary universe cycle u and epoch e.
public export
loadObserverCycleState : (u : Nat) -> (e : Nat) -> EpochState -> ParameterizedCycleState u e EpochState
loadObserverCycleState u e st = mkCycleState u e st

||| Canonical ParameterizedCycleState for pre-saturation cycle 37, epoch 37:
public export
loadObserver37CycleState : ParameterizedCycleState 37 37 EpochState
loadObserver37CycleState = mkCycleState 37 37 getEpoch37State

||| Computes observational predictions from a 3LTT ParameterizedCycleState.
public export
computeParameterizedObserverPredictions : ParameterizedCycleState u e EpochState -> ObservationalPredictions
computeParameterizedObserverPredictions (MkCycleState _ _ st) = computeObserverPredictions st

--------------------------------------------------------------------------------
-- 3. OBSERVER EPOCH PROOF WITNESSES
--------------------------------------------------------------------------------

||| Proof witness verifying CMB spectral tilt n_s = 53/55 = 0.963636... at Epoch 37.
public export
0 verifyCMBSpectralTiltExact : (computeObserverPredictions Stage1.Epoch.Trajectory.getEpoch37State).cmbSpectralTilt = mkUnixelFraction (intToBoxInt 53) 55
verifyCMBSpectralTiltExact = Refl

||| Proof witness verifying ParameterizedCycleState 37 37 yields exact CMB spectral tilt 53 / 55.
public export
0 verifyObserver37CycleStateMatch : (computeParameterizedObserverPredictions Stage1.Epoch.ObserverPredictions.loadObserver37CycleState).cmbSpectralTilt = mkUnixelFraction (intToBoxInt 53) 55
verifyObserver37CycleStateMatch = Refl

||| Audits that Epoch 37 is the exact Observer Epoch where DM law count equals 55 = T_10.
public export
auditEpoch37TriangularResidue : Bool
auditEpoch37TriangularResidue = countTotalDarkLaws getEpoch37State.darkMatterLedger == 55

public export
0 verifyEpoch37TriangularResidue : Stage1.Epoch.ObserverPredictions.auditEpoch37TriangularResidue = True
verifyEpoch37TriangularResidue = Refl

--------------------------------------------------------------------------------
-- 4. 137-SCALE FINE STRUCTURE HORIZON WITNESSES
--------------------------------------------------------------------------------

public export
observerEpochIteration : Nat
observerEpochIteration = 37

||| Audit verifying Observer Epoch is strictly bounded within the 137 cosmic scale hierarchy.
public export
auditObserverEpochWithin137Hierarchy : Bool
auditObserverEpochWithin137Hierarchy = observerEpochIteration <= totalCosmicScaleHierarchy

public export
0 verifyObserverEpochWithin137Hierarchy : Stage1.Epoch.ObserverPredictions.auditObserverEpochWithin137Hierarchy = True
verifyObserverEpochWithin137Hierarchy = Refl

||| Audit verifying remaining unexhausted cosmic scale capacity (137 - 37 = 100 scales).
public export
auditRemainingCosmicScaleCapacity : Bool
auditRemainingCosmicScaleCapacity = (minus totalCosmicScaleHierarchy observerEpochIteration) == 100

public export
0 verifyRemainingCosmicScaleCapacity : Stage1.Epoch.ObserverPredictions.auditRemainingCosmicScaleCapacity = True
verifyRemainingCosmicScaleCapacity = Refl
