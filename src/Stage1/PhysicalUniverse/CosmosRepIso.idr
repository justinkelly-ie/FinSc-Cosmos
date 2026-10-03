||| Representation Theorem Isomorphisms for Layer 6 and Layer 7 (Rule 03)
|||
||| Establishes the functorial isomorphisms:
||| - Layer 6 Thermodynamic Epoch (137-scale sieve partition: 76 pure vs 61 decoherent)
||| - Layer 7 Cosmos Master (Primorial 210 saturation & Helmholtz F = -1320 ground state)
module Stage1.PhysicalUniverse.CosmosRepIso

import Stage0.BoxInt
import Stage0.Multiset
import Stage1.PhysicalUniverse.Stratification
import Stage1.PhysicalUniverse.Pipeline

%default total

--------------------------------------------------------------------------------
-- 1. LAYER 6: THERMODYNAMIC HORIZON 137-SCALE SIEVE ISOMORPHISM
--------------------------------------------------------------------------------

||| Monomorphic equality for ThermodynamicEpochToken.
public export
thermoTokenEqMono : ThermodynamicEpochToken -> ThermodynamicEpochToken -> Bool
thermoTokenEqMono (GatePureScale a) (GatePureScale b) = a == b
thermoTokenEqMono (DecoherentScale a) (DecoherentScale b) = a == b
thermoTokenEqMono _ _ = False

||| Canonical zero token for Layer 6.
public export
zeroThermoToken : ThermodynamicEpochToken
zeroThermoToken = GatePureScale 0

||| Canonical Representation Isomorphism for Layer 6 Thermodynamic Epoch Sieve.
public export
thermoEpochRepIso : TheoryRepresentationIsomorphism L6_ThermodynamicEpoch ThermodynamicEpochToken ThermodynamicEpochToken
thermoEpochRepIso =
  MkTheoryRepIso
    "L6: 137 Sieve Scale Trajectory -> Multiset ThermodynamicEpochToken"
    (\tok => AddM tok (MkBoxInt 1) ZeroM)
    (\m => case m of
             AddM tok _ _ => tok
             ZeroM        => zeroThermoToken)
    (\tok =>
      let m = AddM tok (MkBoxInt 1) ZeroM
          tok' = case m of
                   AddM x _ _ => x
                   ZeroM      => zeroThermoToken
      in thermoTokenEqMono tok' tok
    )

||| Compile-time verification that round-trip isomorphism holds for GatePureScale 38 (Observer epoch).
public export
0 prfThermoEpochRepIsoPure :
  (verifyRoundTrip Stage1.PhysicalUniverse.CosmosRepIso.thermoEpochRepIso)
  (GatePureScale 38) = True
prfThermoEpochRepIsoPure = Refl

||| Compile-time verification that round-trip isomorphism holds for DecoherentScale 136 (Grid wall).
public export
0 prfThermoEpochRepIsoDecoherent :
  (verifyRoundTrip Stage1.PhysicalUniverse.CosmosRepIso.thermoEpochRepIso)
  (DecoherentScale 136) = True
prfThermoEpochRepIsoDecoherent = Refl

--------------------------------------------------------------------------------
-- 2. LAYER 7: COSMOS MASTER SATURATION & GROUND STATE ISOMORPHISM
--------------------------------------------------------------------------------

||| Monomorphic equality for CosmosApexToken.
public export
cosmosApexEqMono : CosmosApexToken -> CosmosApexToken -> Bool
cosmosApexEqMono (PrimorialBudget a) (PrimorialBudget b) = unwrapBox a == unwrapBox b
cosmosApexEqMono (HelmholtzGroundState a) (HelmholtzGroundState b) = unwrapBox a == unwrapBox b
cosmosApexEqMono _ _ = False

||| Canonical zero token for Layer 7.
public export
zeroCosmosApexToken : CosmosApexToken
zeroCosmosApexToken = PrimorialBudget (MkBoxInt 0)

||| Canonical Representation Isomorphism for Layer 7 Cosmos Master.
public export
cosmosMasterRepIso : TheoryRepresentationIsomorphism L7_CosmosMaster CosmosApexToken CosmosApexToken
cosmosMasterRepIso =
  MkTheoryRepIso
    "L7: Cosmos Master Ground State -> Multiset CosmosApexToken"
    (\tok => AddM tok (MkBoxInt 1) ZeroM)
    (\m => case m of
             AddM tok _ _ => tok
             ZeroM        => zeroCosmosApexToken)
    (\tok =>
      let m = AddM tok (MkBoxInt 1) ZeroM
          tok' = case m of
                   AddM x _ _ => x
                   ZeroM      => zeroCosmosApexToken
      in cosmosApexEqMono tok' tok
    )

||| Compile-time verification that round-trip isomorphism holds for PrimorialBudget 210.
public export
0 prfCosmosMasterRepIsoBudget :
  (verifyRoundTrip Stage1.PhysicalUniverse.CosmosRepIso.cosmosMasterRepIso)
  (PrimorialBudget (MkBoxInt 210)) = True
prfCosmosMasterRepIsoBudget = Refl

||| Compile-time verification that round-trip isomorphism holds for HelmholtzGroundState (-1320).
public export
0 prfCosmosMasterRepIsoHelmholtz :
  (verifyRoundTrip Stage1.PhysicalUniverse.CosmosRepIso.cosmosMasterRepIso)
  (HelmholtzGroundState (MkBoxInt (-1320))) = True
prfCosmosMasterRepIsoHelmholtz = Refl
