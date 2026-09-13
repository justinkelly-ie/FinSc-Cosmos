module Reflect.Auditor.Observation

import public Core.BoxInt
import public Core.Multiset
import public Core.UnixelFraction
import public Reflect.Auditor.Core
import Language.Reflection
import public Observation.Algebraic
import public Observation.Dataset
import public Observation.Scientific
import public Observation.Triad
import public Observation.HolographicStream

%default total

------------------------------------------------------------------------
-- COMPILE-TIME REFLECTION AUDITS: OBSERVATION DOMAIN
------------------------------------------------------------------------

-- Witness 12: Multiset Born Rule & Hehner Triad
public export
auditMultisetHehnerTriadProofExport : Bool
auditMultisetHehnerTriadProofExport = Core.UnixelFraction.auditMultisetHehnerTriadProof


-- Witness 159: Empirical Scientific Observation Dataset Consistency
public export
auditScientificObservationDatasetProofExport : Bool
auditScientificObservationDatasetProofExport = Observation.Dataset.auditScientificObservationDatasetProof


-- Witness 160: Algebraic Observation Catalog Completeness
public export
auditAlgebraicObservationCatalogProofExport : Bool
auditAlgebraicObservationCatalogProofExport = Observation.Algebraic.auditAlgebraicObservationCatalogProof


-- Witness 161: Cosmological Observation Triad 3-Way Soundness
public export
auditCosmologicalTriadProofExport : Bool
auditCosmologicalTriadProofExport = Observation.Triad.auditCosmologicalTriadProof


-- Witness 176: Dyck-Huffman Horizon Evaporation Stream & Page Curve (Law 21)
public export
auditHolographicStreamProofExport : Bool
auditHolographicStreamProofExport = Observation.HolographicStream.auditHolographicStreamProof

public export
%macro
auditHolographicStream : Elab (Reflect.Auditor.Observation.auditHolographicStreamProofExport = True)
auditHolographicStream = auditWitness auditHolographicStreamProofExport



