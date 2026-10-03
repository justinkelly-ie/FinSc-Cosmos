module Evolution.Init

import Stage0.BoxInt
import Evolution.State
import Data.Vect
import Data.Nat

%default total

------------------------------------------------------------------------
-- 1. MODEL GENERATORS & RELATIONAL SCALING FUNCTIONS
------------------------------------------------------------------------

||| Relational scaling function for 3D spatial field lattice cells.
||| Grid dimension k produces k^3 active spatial slots (1 -> 1, 2 -> 8, 3 -> 27).
public export
computeVMSize : (gridDim : Nat) -> Nat
computeVMSize dim = dim * dim * dim

||| Helper to calculate 2^n for Nat buffer depth.
public export
fastNatPower2 : Nat -> Nat
fastNatPower2 Z = 1
fastNatPower2 (S k) = 2 * fastNatPower2 k

||| Relational scaling function for Dark Energy binary ROM buffer depth.
||| Binary depth b produces 2^b conserved archival capacity slots (e.g. 7 -> 128).
public export
computeDESize : (deDepth : Nat) -> Nat
computeDESize depth = fastNatPower2 depth

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

||| Model-Derived Substrate Law Channels: 10×11/2 = 55.
public export
substrateLawChannelCount : Nat
substrateLawChannelCount = cast {to=Nat} (div (cast {to=Integer} (substratePhaseDim * (substratePhaseDim + 1))) 2)

||| Model-Derived Primorial Cosmic Budget: 27 + 128 + 55 = 210.
public export
primorialCosmicBudgetTotal : Nat
primorialCosmicBudgetTotal = baryonicTokenCapacity + darkEnergyModeCapacity + substrateLawChannelCount

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
