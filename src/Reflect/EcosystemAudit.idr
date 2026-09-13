module Reflect.EcosystemAudit

import Language.Reflection
import Reflect.Auditor.Core
import Reflect.Auditor.Math
import Reflect.Auditor.Evolution
import Reflect.Auditor.Geometry
import Reflect.Auditor.Observation
import Reflect.Auditor.Compound

%default total

||| Master Ecosystem Catalog witness list combining Core, Math, Evolution, Geometry, Observation, and Compound domain catalogs.
public export
masterEcosystemCatalogWitnesses : List Bool
masterEcosystemCatalogWitnesses =
  coreCatalogWitnesses ++ mathCatalogWitnesses ++ evolutionCatalogWitnesses ++ geometryCatalogWitnesses ++ observationCatalogWitnesses ++ compoundCatalogWitnesses

||| Top-level compile-time reflection macro macro-auditing the entire physical ecosystem catalog.
public export
%macro
auditMasterEcosystem : Elab (allTrue Reflect.EcosystemAudit.masterEcosystemCatalogWitnesses = True)
auditMasterEcosystem = auditCatalogWitnesses masterEcosystemCatalogWitnesses

||| Legacy single witness ecosystem master proof macro.
public export
%macro
auditEcosystemMasterProof : Elab (Reflect.Auditor.Evolution.auditReplEngineProofExport = True)
auditEcosystemMasterProof = pure Refl
