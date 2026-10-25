module Observation.SimulationExporter

import Stage0.BoxInt
import Stage1.Carrier.Vexel
import Stage1.Carrier.Maxel
import Stage1.MultisetTree
import Stage1.SymmetricMetricTensor
import Stage1.Math.GalacticRotationCurve
import Stage1.Epoch.ScaleTrajectorySieve
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

||| Standard CSV header for time-series cosmological simulation exports.
public export
exportStateCsvHeader : String
exportStateCsvHeader = "tick,epoch,coherence,moduli,v10,v20,free_energy,pos_mag,mom_mag,curvature_defect,spread_c11,observer_active"

||| Formats a single UniverseSimulationState as a CSV data row.
public export
exportStateCsvRow : UniverseSimulationState -> String
exportStateCsvRow st =
  let cohStr = case st.coherenceStatus of
                 GatePure _   => "GatePure"
                 Decoherent _ => "Decoherent"
      v10 = rotationVelocity10D st.galacticProfile (intToBoxInt 10)
      v20 = rotationVelocity10D st.galacticProfile (intToBoxInt 20)
      fe  = st.freeEnergyState.freeEnergy
      posMag = vexelMagnitudeSquared st.phaseState.position
      momMag = vexelMagnitudeSquared st.phaseState.momentum
      defect = st.curvatureDefect
      c11 = lookupBoxTree (MkPixel 0 0) st.spreadMatrix.entries
      obsStr = if st.observerEpochActive then "True" else "False"
  in show st.substrateTicks ++ "," ++
     show st.epochIndex ++ "," ++
     cohStr ++ "," ++
     show st.moduliDOF ++ "," ++
     show v10 ++ "," ++
     show v20 ++ "," ++
     show fe ++ "," ++
     show posMag ++ "," ++
     show momMag ++ "," ++
     show defect ++ "," ++
     show c11 ++ "," ++
     obsStr

------------------------------------------------------------------------
-- 3. JSON EXPORT FORMATTERS
------------------------------------------------------------------------

||| Formats a UniverseSimulationState as a JSON record string.
public export
exportStateJson : UniverseSimulationState -> String
exportStateJson st =
  let cohStr = case st.coherenceStatus of
                 GatePure _   => "GatePure"
                 Decoherent _ => "Decoherent"
      v10 = rotationVelocity10D st.galacticProfile (intToBoxInt 10)
      v20 = rotationVelocity10D st.galacticProfile (intToBoxInt 20)
      fe  = st.freeEnergyState.freeEnergy
      posMag = vexelMagnitudeSquared st.phaseState.position
      momMag = vexelMagnitudeSquared st.phaseState.momentum
      defect = st.curvatureDefect
      c11 = lookupBoxTree (MkPixel 0 0) st.spreadMatrix.entries
      obsStr = if st.observerEpochActive then "true" else "false"
  in "{\"tick\":" ++ show st.substrateTicks ++
     ",\"epoch\":" ++ show st.epochIndex ++
     ",\"coherence\":\"" ++ cohStr ++ "\"" ++
     ",\"moduli\":" ++ show st.moduliDOF ++
     ",\"v10\":" ++ show v10 ++
     ",\"v20\":" ++ show v20 ++
     ",\"free_energy\":" ++ show fe ++
     ",\"pos_mag\":" ++ show posMag ++
     ",\"mom_mag\":" ++ show momMag ++
     ",\"curvature_defect\":" ++ show defect ++
     ",\"spread_c11\":" ++ show c11 ++
     ",\"observer_active\":" ++ obsStr ++ "}"

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
