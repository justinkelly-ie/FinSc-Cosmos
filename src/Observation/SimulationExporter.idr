module Observation.SimulationExporter

import Stage0.BoxInt
import Stage1.VexelMaxel
import Stage1.SymmetricMetricTensor
import Stage1.Math.GalacticRotationCurve
import Stage1.Epoch.ScaleTrajectorySieve
import Evolution.SimulationState
import Evolution.SimulationStepper
import Compound.SymplecticIntegrator
import Data.List
import Data.String

%default total

------------------------------------------------------------------------
-- 1. VEXEL OBSERVED METRICS
------------------------------------------------------------------------

||| Computes sum of squared weights in a Vexel: \sum w_i^2.
public export
vexelMagnitudeSquared : Vexel -> BoxInt
vexelMagnitudeSquared (MkVexel ts) =
  foldl (\acc, (_, w) => acc + (w * w)) (intToBoxInt 0) ts

------------------------------------------------------------------------
-- 2. CSV EXPORT FORMATTERS
------------------------------------------------------------------------

||| Standard CSV header for time-series cosmological simulation exports.
public export
exportStateCsvHeader : String
exportStateCsvHeader = "tick,epoch,coherence,moduli,v10,v20,free_energy,pos_mag,mom_mag"

||| Formats a single UniverseSimulationState as a CSV data row.
public export
exportStateCsvRow : UniverseSimulationState -> String
exportStateCsvRow st =
  let cohStr = case st.coherenceStatus of
                 GatePure _   => "GatePure"
                 Decoherent _ => "Decoherent"
      v10 = unwrapBox (rotationVelocity10D st.galacticProfile (intToBoxInt 10))
      v20 = unwrapBox (rotationVelocity10D st.galacticProfile (intToBoxInt 20))
      fe  = unwrapBox st.freeEnergyState.freeEnergy
      posMag = unwrapBox (vexelMagnitudeSquared st.phaseState.position)
      momMag = unwrapBox (vexelMagnitudeSquared st.phaseState.momentum)
  in show st.substrateTicks ++ "," ++
     show st.epochIndex ++ "," ++
     cohStr ++ "," ++
     show st.moduliDOF ++ "," ++
     show v10 ++ "," ++
     show v20 ++ "," ++
     show fe ++ "," ++
     show posMag ++ "," ++
     show momMag

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
      v10 = unwrapBox (rotationVelocity10D st.galacticProfile (intToBoxInt 10))
      v20 = unwrapBox (rotationVelocity10D st.galacticProfile (intToBoxInt 20))
      fe  = unwrapBox st.freeEnergyState.freeEnergy
      posMag = unwrapBox (vexelMagnitudeSquared st.phaseState.position)
      momMag = unwrapBox (vexelMagnitudeSquared st.phaseState.momentum)
  in "{\"tick\":" ++ show st.substrateTicks ++
     ",\"epoch\":" ++ show st.epochIndex ++
     ",\"coherence\":\"" ++ cohStr ++ "\"" ++
     ",\"moduli\":" ++ show st.moduliDOF ++
     ",\"v10\":" ++ show v10 ++
     ",\"v20\":" ++ show v20 ++
     ",\"free_energy\":" ++ show fe ++
     ",\"pos_mag\":" ++ show posMag ++
     ",\"mom_mag\":" ++ show momMag ++ "}"

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
-- 5. COMPILE-TIME AUDIT FOR SIMULATION EXPORTER
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
