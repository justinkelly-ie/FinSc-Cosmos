module Evolution.Bootstrap

import Stage0.BoxInt
import Evolution.State
import Evolution.Init
import Evolution.Expansion
import Evolution.Contraction
import Data.Vect
import Data.Nat

%default total

||| Recursive cosmological stepper: advances any universe state by k epochs
||| without magic constants or casts.
public export
bootstrapEpochs : {vm, de, dm : Nat} -> 
                  (k : Nat) -> 
                  (1 startState : UniverseState vm de dm) -> 
                  UniverseState vm de (k + dm)
bootstrapEpochs Z state = state
bootstrapEpochs (S j) state = 
  let stepState = contractAndFoldGeneric state (natToBoxInt (S j))
  in rewrite plusSuccRightSucc j dm in bootstrapEpochs j stepState

||| @deprecated Single-step stepEpoch is superseded by the full linear QTT pipeline 
||| Evolution.LinearPipeline.runEpochPipeline or contractAndFoldGeneric.
||| Steps a single epoch by folding active fields and appending an exact remainder token.
public export
stepEpoch : {vm, de, dm : Nat} -> 
            (1 currentCosmos : UniverseState vm de dm) -> 
            (remainder : BoxInt) -> 
            UniverseState vm de (S dm)
stepEpoch cosmos remainder =
  contractAndFoldGeneric cosmos remainder

||| Dynamically synthesizes the cosmological ground state for any target epoch
||| derived strictly from spatial grid dimensions and binary ROM depth.
public export
bootstrapToEpoch : (targetEpoch : Nat) -> 
                   (gridDim : Nat) -> 
                   (deDepth : Nat) -> 
                   UniverseState (computeVMSize gridDim) 
                                 (computeDESize deDepth) 
                                 (computeDMSize targetEpoch)
bootstrapToEpoch targetEpoch gridDim deDepth =
  seedCosmicVacuum gridDim deDepth targetEpoch

||| @deprecated Hardcoded standardEpoch37 is superseded by relational bootstrapToEpoch 37 3 7.
||| Generates the standard cosmological state for Epoch 37 (dim=3 -> 27, depth=7 -> 128, dm=55).
public export
standardEpoch37 : UniverseState 27 128 55
standardEpoch37 =
  let initDM = replicate 55 (intToBoxInt 1)
      initVM = replicate 27 (intToBoxInt 0)
      initDE = replicate 128 (intToBoxInt 37)
  in MkUniverseState initVM initDE initDM

||| Simulates the transition from Epoch 37 to Epoch 38.
public export
transitionToNextEpoch : {vm, de, dm : Nat} -> 
                       (1 currentCosmos : UniverseState vm de dm) -> 
                       UniverseState vm de (S dm)
transitionToNextEpoch {dm} cosmos =
  contractAndFoldGeneric cosmos (natToBoxInt dm)
