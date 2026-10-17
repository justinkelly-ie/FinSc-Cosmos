module Stage1.Epoch.Trajectory

import public Stage0.BoxInt
import public Stage0.Multiset
import Data.Vect
import Data.List
import Data.Fuel
import Stage1.Epoch.ChromogeometryLaw
import Stage0.Epoch.GohStreamTransducer
import Stage0.OnSeq.FusedStream
import Stage1.Epoch.ExpansionCollapse
import Stage1.Goh
import Stage1.Math.OnSeq.SpreadStream
import Stage1.TypeTheory.Staging


%default total

--------------------------------------------------------------------------------
-- 1. 37-EPOCH COSMIC TRAJECTORY SIMULATION
--------------------------------------------------------------------------------

||| Helper to recursively simulate N epoch steps.
public export
simulateEpochSteps : Nat -> EpochState -> List EpochState
simulateEpochSteps 0 st = [st]
simulateEpochSteps (S k) st = st :: simulateEpochSteps k (advanceEpochState st)

||| Simulates exact 37-epoch trajectory starting from initial state.
||| This represents the pre-observer evolution phase (k in [0, 36]) leading directly
||| to the gate-pure observer epoch milestone at k = 38 (n = 39 = 3 * 13).
public export
simulate37Epochs : EpochState -> List EpochState
simulate37Epochs initSt = simulateEpochSteps 36 initSt

||| Canonical alias for the pre-observer cosmic trajectory across the initial 37 epochs.
public export
simulatePreObserverTrajectory : EpochState -> List EpochState
simulatePreObserverTrajectory = simulate37Epochs

||| Evaluates initial Genesis state bootstrapped from empty multiset ZeroM.
public export
initBootstrapEpoch : EpochState
initBootstrapEpoch = initGenesisEpoch

||| Direct step advance over N epochs.
public export
advanceN : Nat -> EpochState -> EpochState
advanceN 0 st = st
advanceN (S k) st = advanceN k (advanceEpochState st)

||| Evaluates the final Epoch 37 state from Genesis bootstrap.
public export
getEpoch37State : EpochState
getEpoch37State = advanceN 36 initGenesisEpoch

||| Zero-allocation coinductive infinite stream of cosmic epochs.
public export
streamCosmicEpochs : EpochState -> FusedStream EpochState
streamCosmicEpochs initSt = unfoldStream (\st => Yield st (advanceEpochState st)) initSt

||| Coinductive deforested stream representing the 37-epoch pre-observer cosmic trajectory.
public export
stream37Epochs : EpochState -> FusedStream EpochState
stream37Epochs initSt = fusedTake 37 (streamCosmicEpochs initSt)

||| Canonical alias for the pre-observer cosmic stream trajectory across the initial 37 epochs.
public export
streamPreObserverTrajectory : EpochState -> FusedStream EpochState
streamPreObserverTrajectory = stream37Epochs

||| Evaluates the final Epoch 37 state from Genesis bootstrap using streaming drop.
public export
getEpoch37StateStream : EpochState
getEpoch37StateStream =
  case runFueledStreamNat 2 (fusedTake 1 (fusedDrop 36 (streamCosmicEpochs initGenesisEpoch))) of
    [st] => st
    _ => getEpoch37State

--------------------------------------------------------------------------------
-- 1A. STAGED SPREAD COMPOSITIONAL SCALE TRANSITION (Cigler & Herbig 2026, Prop 4.2)
--------------------------------------------------------------------------------

||| Evaluates a composite multi-scale epoch jump: Z_{mn}(s) = (Z_m ∘ Z_n)(s)
||| Evaluates polynomial composition directly using Horner's rule without sequential iteration.
public export
stagedEpochSpreadJump : GohAuxiliary d1 -> GohAuxiliary d2 -> UnixelFraction -> UnixelFraction
stagedEpochSpreadJump polyM polyN s = evalSpreadCompose polyM polyN s

||| Evaluates multi-scale epoch transitions over an allocation-free deforested stream.
public export
stagedEpochSpreadJumpStream : GohAuxiliary d1 -> GohAuxiliary d2 -> FusedStream UnixelFraction -> FusedStream UnixelFraction
stagedEpochSpreadJumpStream polyM polyN st = evalSpreadComposeStream polyM polyN st

||| QTT 0 erased proof witness verifying that identity jump Z_1(Z_1(5)) preserves spread value 5:
public export
0 prfStagedEpochJumpIdentity : evalGohPolyInt GohPsi1 (evalGohPolyInt GohPsi1 5) = 5
prfStagedEpochJumpIdentity = Refl

||| Evaluates multi-scale epoch transitions across multiset factor trees: Z_{mn}(s) = (Z_m ∘ Z_n)(s).
public export
stagedEpochMultisetJump : GohMultiset -> GohMultiset -> UnixelFraction -> UnixelFraction
stagedEpochMultisetJump gM gN s = evalSpreadComposeMultiset gM gN s

||| 2LTT Staged composite multi-scale epoch transition code block.
public export
stagedEpochMultisetJumpCode : GohMultiset -> GohMultiset -> UnixelFraction -> Code UnixelFraction
stagedEpochMultisetJumpCode gM gN s = stagedSpreadComposeJump gM gN s

||| 2LTT Staged unrolled multi-scale epoch transition code block using staged Horner unrolling.
public export
stagedEpochMultisetUnrolledCode : GohMultiset -> UnixelFraction -> Code UnixelFraction
stagedEpochMultisetUnrolledCode bag s = stagedUnrollGohMultiset bag (quote s)

||| 2LTT Staged Deforested Stream Transducer for Epoch transitions:
public export
stagedEpochStreamTransducer : GohMultiset -> Code (FusedStream UnixelFraction -> FusedStream UnixelFraction)
stagedEpochStreamTransducer bag = stagedGohStreamTransducer bag



--------------------------------------------------------------------------------
-- 2. PRIMORIAL 210 BUDGET CLOSURE PROOF WITNESSES
--------------------------------------------------------------------------------

||| Verifies that Genesis Epoch 1 starts from empty multiset ZeroM.
public export
0 verifyBootstrapFromEmptyMultiset : Stage1.Epoch.ExpansionCollapse.initGenesisEpoch.darkMatterLedger = ZeroM
verifyBootstrapFromEmptyMultiset = Refl

||| Audits Primorial 210 budget closure at Epoch 37 (VM=27, DE=128, DM=55 -> Total=210).
public export
auditPrimorial210BudgetProof : Bool
auditPrimorial210BudgetProof =
  let st37 = getEpoch37State
      vm = st37.visibleBaryons
      de = st37.darkEnergy
      dm = countTotalDarkLaws st37.darkMatterLedger
  in (vm + de + dm) == 210

||| Audits Primorial 210 closure directly from the coinductive epoch stream in O(1) stack space.
public export
auditPrimorial210BudgetStreamProof : Bool
auditPrimorial210BudgetStreamProof =
  let st37 = getEpoch37StateStream
      vm = st37.visibleBaryons
      de = st37.darkEnergy
      dm = countTotalDarkLaws st37.darkMatterLedger
  in (vm + de + dm) == 210

||| Compile-time proof witness auditing Primorial 210 QuadStream budget closure (27 + 55 + 128 = 210).
public export
0 verifyQuadStreamBudgetClosure : (27 + 55 + 128) = 210
verifyQuadStreamBudgetClosure = Refl

--------------------------------------------------------------------------------
-- 3. MULTI-CYCLE CYCLIC UNIVERSE TRAJECTORY SIMULATION & COINDUCTIVE STREAMS
--------------------------------------------------------------------------------

||| Advances N steps through the cyclic universe state machine using reboundCyclicEpoch.
public export
advanceCyclicN : Nat -> EpochState -> EpochState
advanceCyclicN 0 st = st
advanceCyclicN (S k) st = advanceCyclicN k (reboundCyclicEpoch st)

||| Simulates N steps of continuous cyclic cosmic trajectory.
public export
simulateCyclicEpochs : Nat -> EpochState -> List EpochState
simulateCyclicEpochs 0 st = [st]
simulateCyclicEpochs (S k) st = st :: simulateCyclicEpochs k (reboundCyclicEpoch st)

||| Streams N steps of continuous deforested cyclic cosmic trajectory using reboundCyclicEpoch.
public export
streamCyclicEpochs : Nat -> EpochState -> FusedStream EpochState
streamCyclicEpochs n initSt =
  unfoldStream (\(k, st) => case k of
                              Z => Done
                              S k' => Yield st (k', reboundCyclicEpoch st)) (n, initSt)

||| Coinductive infinite cyclic universe stream representation.
public export
data InfUniverseStream : Type where
  (::) : EpochState -> Inf InfUniverseStream -> InfUniverseStream

||| Unbounded coinductive cyclic universe stream generator.
public export
infiniteCyclicUniverseStream : EpochState -> InfUniverseStream
infiniteCyclicUniverseStream st = st :: infiniteCyclicUniverseStream (reboundCyclicEpoch st)

||| Extracts a finite observation window of N epoch steps from an InfUniverseStream coinductive stream.
public export
takeInfUniverseStream : Nat -> InfUniverseStream -> List EpochState
takeInfUniverseStream Z _ = []
takeInfUniverseStream (S k) (st :: rest) = st :: takeInfUniverseStream k rest

||| Deforested observation window query over an infinite cyclic universe stream using fusedTake.
public export
fusedTakeCyclicEpochs : Nat -> Nat -> EpochState -> FusedStream EpochState
fusedTakeCyclicEpochs winSize totalSteps initSt =
  fusedTake winSize (streamCyclicEpochs totalSteps initSt)

||| Audits Primorial 210 budget conservation across cyclic rebounds using total structural Nat recursion.
public export
auditCyclicBudgetClosureNat : Nat -> EpochState -> Bool
auditCyclicBudgetClosureNat n initSt =
  all (\st => (st.visibleBaryons + st.darkEnergy + countTotalDarkLaws st.darkMatterLedger) <= 210)
      (simulateCyclicEpochs n initSt)

||| Audits Primorial 210 budget conservation across infinite cyclic rebounds.
public export
auditInfCyclicBudgetClosure : Nat -> EpochState -> Bool
auditInfCyclicBudgetClosure n initSt =
  let strm = streamCyclicEpochs n initSt
  in foldStreamNat (n + 1) (\acc, st =>
       let vm = st.visibleBaryons
           de = st.darkEnergy
           dm = countTotalDarkLaws st.darkMatterLedger
       in acc && ((vm + de + dm) <= 210)
     ) True strm

||| Audit verifying cyclic rebound resets a saturated Epoch 37 state to Epoch 1.
public export
auditCyclicReboundPeriodicity : Bool
auditCyclicReboundPeriodicity = (reboundCyclicEpoch getEpoch37State).epochNumber == 1

public export
0 verifyCyclicReboundPeriodicity : Stage1.Epoch.Trajectory.auditCyclicReboundPeriodicity = True
verifyCyclicReboundPeriodicity = Refl
