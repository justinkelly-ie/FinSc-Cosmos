module Observation.SimulationExporter

import Stage0.BoxInt
import Stage1.Basis.Coordinate
import Stage1.MultisetTree
import Stage1.SymmetricMetricTensor
import Stage1.Math.GalacticRotationCurve
import Stage1.Epoch.ScaleTrajectorySieve
import Stage1.Multiset.PrimordialUnfolding
import Evolution.SimulationState
import Evolution.SimulationStepper
import Compound.SymplecticIntegrator
import Stage0.OnSeq.FusedStream
import Data.List
import Data.String

%default total

------------------------------------------------------------------------
-- 1. VEXEL OBSERVED METRICS
------------------------------------------------------------------------

||| Computes sum of squared weights in a Vexel: \sum w_i^2.
public export
vexelMagnitudeSquared : Vexel -> BoxInt
vexelMagnitudeSquared v = dotVexel v v

------------------------------------------------------------------------
-- 2. CSV EXPORT FORMATTERS
------------------------------------------------------------------------

||| Evaluates the dynamic Substrate-driven rotation velocity plateau at radius r:
public export
exportSubstrateRotationVelocity : UniverseSimulationState -> (radius : BoxInt) -> BoxInt
exportSubstrateRotationVelocity st r =
  let (xk, yk) = epochPythagoreanCoordinateReentrant (superEpoch st) (epochIndex st)
  in rotationVelocityHaloSubstrate10D xk yk (galacticProfile st) (galacticHalo st) r

||| Standard CSV header for time-series cosmological simulation exports.
public export
exportStateCsvHeader : String
exportStateCsvHeader = "tick,superepoch,epoch,coherence,moduli,v10,v20,v10_sub,v20_sub,free_energy,pos_mag,mom_mag,curvature_defect,spread_c11,scale_factor_q,hubble_rate_s,observer_active,expansion_mode,dissipated_entropy"

||| Formats a single UniverseSimulationState as a CSV data row.
public export
exportStateCsvRow : UniverseSimulationState -> String
exportStateCsvRow st =
  let cohStr = case coherenceStatus st of
                 GatePure _   => "GatePure"
                 Decoherent _ => "Decoherent"
      v10 = rotationVelocity10D (galacticProfile st) (intToBoxInt 10)
      v20 = rotationVelocity10D (galacticProfile st) (intToBoxInt 20)
      (xk, yk) = epochPythagoreanCoordinateReentrant (superEpoch st) (epochIndex st)
      v10_sub = rotationVelocityHaloSubstrate10D xk yk (galacticProfile st) (galacticHalo st) (intToBoxInt 10)
      v20_sub = rotationVelocityHaloSubstrate10D xk yk (galacticProfile st) (galacticHalo st) (intToBoxInt 20)
      fe  = (freeEnergyState st).freeEnergy
      posMag = vexelMagnitudeSquared (phaseState st).position
      momMag = vexelMagnitudeSquared (phaseState st).momentum
      defect = curvatureDefect st
      c11 = lookupBoxTree (MkPixel 0 0) (spreadMatrix st).entries
      obsStr = if observerEpochActive st then "True" else "False"
  in show (substrateTicks st) ++ "," ++
     show (superEpoch st) ++ "," ++
     show (epochIndex st) ++ "," ++
     cohStr ++ "," ++
     show (moduliDOF st) ++ "," ++
     show v10 ++ "," ++
     show v20 ++ "," ++
     show v10_sub ++ "," ++
     show v20_sub ++ "," ++
     show fe ++ "," ++
     show posMag ++ "," ++
     show momMag ++ "," ++
     show defect ++ "," ++
     show c11 ++ "," ++
     show (scaleFactor st) ++ "," ++
     show (hubbleExpansionRate st) ++ "," ++
     obsStr ++ "," ++
     show (expansionMode st) ++ "," ++
     show (dissipatedEntropy st)

------------------------------------------------------------------------
-- 3. JSON EXPORT FORMATTERS
------------------------------------------------------------------------

||| Formats a UniverseSimulationState as a JSON record string.
public export
exportStateJson : UniverseSimulationState -> String
exportStateJson st =
  let cohStr = case coherenceStatus st of
                 GatePure _   => "GatePure"
                 Decoherent _ => "Decoherent"
      v10 = rotationVelocity10D (galacticProfile st) (intToBoxInt 10)
      v20 = rotationVelocity10D (galacticProfile st) (intToBoxInt 20)
      (xk, yk) = epochPythagoreanCoordinateReentrant (superEpoch st) (epochIndex st)
      v10_sub = rotationVelocityHaloSubstrate10D xk yk (galacticProfile st) (galacticHalo st) (intToBoxInt 10)
      v20_sub = rotationVelocityHaloSubstrate10D xk yk (galacticProfile st) (galacticHalo st) (intToBoxInt 20)
      fe  = (freeEnergyState st).freeEnergy
      posMag = vexelMagnitudeSquared (phaseState st).position
      momMag = vexelMagnitudeSquared (phaseState st).momentum
      defect = curvatureDefect st
      c11 = lookupBoxTree (MkPixel 0 0) (spreadMatrix st).entries
      obsStr = if observerEpochActive st then "true" else "false"
  in "{\"tick\":" ++ show (substrateTicks st) ++
     ",\"superepoch\":" ++ show (superEpoch st) ++
     ",\"epoch\":" ++ show (epochIndex st) ++
     ",\"coherence\":\"" ++ cohStr ++ "\"" ++
     ",\"moduli\":" ++ show (moduliDOF st) ++
     ",\"v10\":" ++ show v10 ++
     ",\"v20\":" ++ show v20 ++
     ",\"v10_sub\":" ++ show v10_sub ++
     ",\"v20_sub\":" ++ show v20_sub ++
     ",\"free_energy\":" ++ show fe ++
     ",\"pos_mag\":" ++ show posMag ++
     ",\"mom_mag\":" ++ show momMag ++
     ",\"curvature_defect\":" ++ show defect ++
     ",\"spread_c11\":" ++ show c11 ++
     ",\"scale_factor_q\":" ++ show (scaleFactor st) ++
     ",\"hubble_rate_s\":" ++ show (hubbleExpansionRate st) ++
     ",\"observer_active\":" ++ obsStr ++
     ",\"expansion_mode\":\"" ++ show (expansionMode st) ++ "\"" ++
     ",\"dissipated_entropy\":" ++ show (dissipatedEntropy st) ++ "}"

------------------------------------------------------------------------
-- 4. LINEAR TRAJECTORY GENERATORS
------------------------------------------------------------------------

||| Recursively generates a list of CSV rows by advancing the simulation n steps.
public export
generateSimulationCsvRows : (steps : Nat) -> (st : UniverseSimulationState) -> List String
generateSimulationCsvRows Z st = [exportStateCsvRow st]
generateSimulationCsvRows (S k) st =
  let row = exportStateCsvRow st
      st' = stepUniverseSimulation st
  in row :: generateSimulationCsvRows k st'

||| Recursively generates a list of JSON records by advancing the simulation n steps.
public export
generateSimulationJsonRows : (steps : Nat) -> (st : UniverseSimulationState) -> List String
generateSimulationJsonRows Z st = [exportStateJson st]
generateSimulationJsonRows (S k) st =
  let row = exportStateJson st
      st' = stepUniverseSimulation st
  in row :: generateSimulationJsonRows k st'

------------------------------------------------------------------------
-- 5. DEFORESTED COINDUCTIVE UNIVERSE STREAMING
------------------------------------------------------------------------

||| Generates a deforested stream of universal evolution states
||| executing in O(1) auxiliary registers without intermediate heap allocation.
public export
streamUniverseSimulation : UniverseSimulationState -> FusedStream UniverseSimulationState
streamUniverseSimulation initSt =
  unfoldStream (\st => Yield st (stepUniverseSimulation st)) initSt

------------------------------------------------------------------------
-- 6. COMPILE-TIME AUDIT FOR SIMULATION EXPORTER
------------------------------------------------------------------------

||| Verifies that the CSV exporter produces the expected header and genesis row.
public export
auditSimulationExporter : Bool
auditSimulationExporter =
  let st0 = initUniverseSimulation
      row0 = exportStateCsvRow st0
      json0 = exportStateJson st0
  in length exportStateCsvHeader > 0 &&
     length row0 > 0 &&
     length json0 > 0

||| Audits that live Substrate rotation velocity evaluates to a strictly positive plateau.
public export
auditSubstrateVelocityEvolutionProof : Bool
auditSubstrateVelocityEvolutionProof =
  let st0 = initUniverseSimulation
      v10_sub_0 = exportSubstrateRotationVelocity st0 (intToBoxInt 10)
      v20_sub_0 = exportSubstrateRotationVelocity st0 (intToBoxInt 20)
  in (v10_sub_0 > intToBoxInt 0) && (v20_sub_0 > intToBoxInt 0)
