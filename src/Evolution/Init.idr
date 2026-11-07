module Evolution.Init

import Stage0.BoxInt
import public Stage0.StructuralFuel
import Evolution.State
import Data.Vect
import Data.Nat

%default total

------------------------------------------------------------------------
-- 1. MODEL GENERATORS & RELATIONAL SCALING FUNCTIONS
------------------------------------------------------------------------

||| Relational scaling function for Dark Matter historical log length.
||| The ledger records exactly the number of elapsed evolutionary epochs.
public export
computeDMSize : (epoch : Nat) -> Nat
computeDMSize epoch = epoch

------------------------------------------------------------------------
-- 2. MODEL-DERIVED PRIMORIAL 210 COSMIC BUDGET CONSTANTS
------------------------------------------------------------------------

||| Manifest Spatial Grid Dimension for the 3D Universe (3).
public export
spatialGridDim : Nat
spatialGridDim = 3

||| Spectral Vacuum Binary Depth (7 bits).
public export
vacuumBinaryDepth : Nat
vacuumBinaryDepth = 7

||| Phase Space Substrate Basis Dimension (10D).
public export
substratePhaseDim : Nat
substratePhaseDim = 10

||| Model-Derived Baryonic Matter Capacity: computeVMSize 3 = 3³ = 27.
public export
baryonicTokenCapacity : Nat
baryonicTokenCapacity = computeVMSize spatialGridDim

||| Model-Derived Dark Energy Modes: computeDESize 7 = 2⁷ = 128.
public export
darkEnergyModeCapacity : Nat
darkEnergyModeCapacity = computeDESize vacuumBinaryDepth

||| Model-Derived Substrate Law Channels: T_10 = 10×11/2 = 55.
public export
substrateLawChannelCount : Nat
substrateLawChannelCount = triangularSum substratePhaseDim

||| Model-Derived Primorial Cosmic Budget: 27 + 128 + 55 = 210.
public export
primorialCosmicBudgetTotal : Nat
primorialCosmicBudgetTotal = baryonicTokenCapacity + darkEnergyModeCapacity + substrateLawChannelCount

||| Formal constructive proof witness certifying that the Model-Derived Primorial Cosmic Budget
||| matches the 4th Primorial factorization: p_4# = 2 * 3 * 5 * 7 = 210.
public export
0 prfPrimorialCosmicBudgetMatchesFactorization : Evolution.Init.primorialCosmicBudgetTotal = 210
prfPrimorialCosmicBudgetMatchesFactorization = Refl

------------------------------------------------------------------------
-- 3. COSMIC VACUUM INITIALIZATION
------------------------------------------------------------------------

||| Dynamically initializes the cosmic vacuum state purely from spatial,
||| energy depth, and epoch parameters without magic constants or casts.
public export
seedCosmicVacuum : (gridDim : Nat) -> 
                    (deDepth : Nat) -> 
                    (epoch : Nat) -> 
                    UniverseState (computeVMSize gridDim) 
                                  (computeDESize deDepth) 
                                  (computeDMSize epoch)
seedCosmicVacuum gridDim deDepth epoch =
  let initVM = replicate (computeVMSize gridDim) (intToBoxInt 0)
      initDE = replicate (computeDESize deDepth) (natToBoxInt epoch)
      initDM = replicate (computeDMSize epoch) (natToBoxInt epoch)
  in MkUniverseState initVM initDE initDM

||| The Primordial Genesis Vacuum state at Epoch 1 (empty Dark Matter history log).
public export
genesisVacuumAtScale : (gridDim : Nat) -> (deDepth : Nat) -> UniverseState (computeVMSize gridDim) (computeDESize deDepth) 0
genesisVacuumAtScale gridDim deDepth = seedCosmicVacuum gridDim deDepth 0
