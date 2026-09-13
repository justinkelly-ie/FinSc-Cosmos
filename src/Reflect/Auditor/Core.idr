module Reflect.Auditor.Core

import public Core.BoxInt
import public Core.Multiset
import public Core.MultisetTree
import public Core.OnSeq
import public Core.Polynumber
import public Core.UnixelFraction
import public Core.VexelMaxel
import Language.Reflection

%default total

------------------------------------------------------------------------
-- COMPILE-TIME REFLECTION AUDITS: CORE DOMAIN
------------------------------------------------------------------------

||| Universal generic macro witness auditor tactic.
%inline public export
auditWitness : (target : Bool) -> Elab (target = True)
auditWitness True = pure Refl
auditWitness False = fail "Audit witness check failed: proof export returned False"

||| Helper checking if a list of booleans are all True.
%inline public export
allTrue : List Bool -> Bool
allTrue [] = True
allTrue (True :: xs) = allTrue xs
allTrue (False :: _) = False

||| Generic catalog witness auditor tactic for batch witness validation.
%inline public export
auditCatalogWitnesses : (targets : List Bool) -> Elab (allTrue targets = True)
auditCatalogWitnesses targets = auditWitness (allTrue targets)

-- Witness 3: Maxel Row Extraction
public export
auditRowExtractionProofExport : Bool
auditRowExtractionProofExport = Core.VexelMaxel.auditRowExtractionProof

public export
%macro
auditRowExtraction : Elab (Reflect.Auditor.Core.auditRowExtractionProofExport = True)
auditRowExtraction = auditWitness auditRowExtractionProofExport

-- Witness 7: Unixel Denominator Positivity
public export
auditUnixelFractionPositivityProofExport : Bool
auditUnixelFractionPositivityProofExport = Core.UnixelFraction.auditSternBrocotProof

public export
%macro
auditUnixelFractionPositivity : Elab (Reflect.Auditor.Core.auditUnixelFractionPositivityProofExport = True)
auditUnixelFractionPositivity = auditWitness auditUnixelFractionPositivityProofExport

-- Witness 8: Rational Equivalence
public export
auditRationalEquivalenceProofExport : Bool
auditRationalEquivalenceProofExport = Core.UnixelFraction.auditContinuedFractionProof

public export
%macro
auditRationalEquivalence : Elab (Reflect.Auditor.Core.auditRationalEquivalenceProofExport = True)
auditRationalEquivalence = auditWitness auditRationalEquivalenceProofExport

-- Witness 9: OnSeq Clip Length Extraction
public export
auditOnSeqClipExtractionProofExport : Bool
auditOnSeqClipExtractionProofExport = Core.OnSeq.auditOnSeqClipExtractionProof

public export
%macro
auditOnSeqClipExtraction : Elab (Reflect.Auditor.Core.auditOnSeqClipExtractionProofExport = True)
auditOnSeqClipExtraction = auditWitness auditOnSeqClipExtractionProofExport

-- Witness 10: Hehner Scale Conversion
public export
auditHehnerScaleConversionProofExport : Bool
auditHehnerScaleConversionProofExport = Core.UnixelFraction.auditHehnerScaleConversionProof

public export
%macro
auditHehnerScaleConversion : Elab (Reflect.Auditor.Core.auditHehnerScaleConversionProofExport = True)
auditHehnerScaleConversion = auditWitness auditHehnerScaleConversionProofExport

-- Witness 11: Multiset Information Distance
public export
auditMultisetInformationDistanceProofExport : Bool
auditMultisetInformationDistanceProofExport = Core.Multiset.auditMultisetInformationDistanceProof

public export
%macro
auditMultisetInformationDistance : Elab (Reflect.Auditor.Core.auditMultisetInformationDistanceProofExport = True)
auditMultisetInformationDistance = auditWitness auditMultisetInformationDistanceProofExport

-- Witness 13: Multiset Cross-Entropy
public export
auditMultisetCrossEntropyProofExport : Bool
auditMultisetCrossEntropyProofExport = Core.Multiset.auditMultisetCrossEntropyProof

public export
%macro
auditMultisetCrossEntropy : Elab (Reflect.Auditor.Core.auditMultisetCrossEntropyProofExport = True)
auditMultisetCrossEntropy = auditWitness auditMultisetCrossEntropyProofExport

-- Witness 14: Multiset Compactness Intelligence
public export
auditMultisetCompactnessProofExport : Bool
auditMultisetCompactnessProofExport = Core.UnixelFraction.auditMultisetCompactnessRatioProof

public export
%macro
auditMultisetCompactness : Elab (Reflect.Auditor.Core.auditMultisetCompactnessProofExport = True)
auditMultisetCompactness = auditWitness auditMultisetCompactnessProofExport

-- Witness 95: Fast O(log N) MultisetTree Lookup
public export
auditMultisetTreeLookupProofExport : Bool
auditMultisetTreeLookupProofExport = Core.MultisetTree.auditMultisetTreeLookupProof

public export
%macro
auditMultisetTreeLookup : Elab (Reflect.Auditor.Core.auditMultisetTreeLookupProofExport = True)
auditMultisetTreeLookup = auditWitness auditMultisetTreeLookupProofExport

-- Witness 96: MultisetTree Token Multiplicity Summation
public export
auditMultisetTreeTokenSumProofExport : Bool
auditMultisetTreeTokenSumProofExport = Core.MultisetTree.auditMultisetTreeTokenSumProof

public export
%macro
auditMultisetTreeTokenSum : Elab (Reflect.Auditor.Core.auditMultisetTreeTokenSumProofExport = True)
auditMultisetTreeTokenSum = auditWitness auditMultisetTreeTokenSumProofExport

-- Witness 114: Caret Product Identity Invariant
public export
auditCaretProductIdentityProofExport : Bool
auditCaretProductIdentityProofExport = Core.Polynumber.auditCaretProductIdentityProof

public export
%macro
auditCaretProductIdentity : Elab (Reflect.Auditor.Core.auditCaretProductIdentityProofExport = True)
auditCaretProductIdentity = auditWitness auditCaretProductIdentityProofExport

-- Witness 115: Fundamental Identity of Arithmetic (FIA) Euler Caret Factorization
public export
auditFIAEulerProductProofExport : Bool
auditFIAEulerProductProofExport = Core.Polynumber.auditFIAEulerProductProof

public export
%macro
auditFIAEulerProduct : Elab (Reflect.Auditor.Core.auditFIAEulerProductProofExport = True)
auditFIAEulerProduct = auditWitness auditFIAEulerProductProofExport

-- Witness 116: Canonical Box Ordering & Dyck Path Contour Walk Isomorphism
public export
auditBoxOrderingAndContourWalkProofExport : Bool
auditBoxOrderingAndContourWalkProofExport = Core.Multiset.auditBoxOrderingProof

public export
%macro
auditBoxOrderingAndContourWalk : Elab (Reflect.Auditor.Core.auditBoxOrderingAndContourWalkProofExport = True)
auditBoxOrderingAndContourWalk = auditWitness auditBoxOrderingAndContourWalkProofExport

-- Witness 117: Balance Arrays & Subtraction-Free Natural Linear Independence
public export
auditVexelBalanceArrayProofExport : Bool
auditVexelBalanceArrayProofExport = Core.VexelMaxel.auditVexelBalanceProof

public export
%macro
auditVexelBalanceArray : Elab (Reflect.Auditor.Core.auditVexelBalanceArrayProofExport = True)
auditVexelBalanceArray = auditWitness auditVexelBalanceArrayProofExport

-- Witness 118: Magic Maxels & Doubly Stochastic Token Mass Conservation
public export
auditMagicMaxelConservationProofExport : Bool
auditMagicMaxelConservationProofExport = Core.VexelMaxel.auditMagicMaxel3x3Proof

public export
%macro
auditMagicMaxelConservation : Elab (Reflect.Auditor.Core.auditMagicMaxelConservationProofExport = True)
auditMagicMaxelConservation = auditWitness auditMagicMaxelConservationProofExport

------------------------------------------------------------------------
-- BATCH CATALOG WITNESS REFLECTION AUDITOR
------------------------------------------------------------------------

public export
coreCatalogWitnesses : List Bool
coreCatalogWitnesses =
  [ auditRowExtractionProofExport
  , auditUnixelFractionPositivityProofExport
  , auditRationalEquivalenceProofExport
  , auditOnSeqClipExtractionProofExport
  , auditHehnerScaleConversionProofExport
  , auditMultisetInformationDistanceProofExport
  , auditMultisetCrossEntropyProofExport
  , auditMultisetCompactnessProofExport
  , auditMultisetTreeLookupProofExport
  , auditMultisetTreeTokenSumProofExport
  , auditCaretProductIdentityProofExport
  , auditFIAEulerProductProofExport
  , auditBoxOrderingAndContourWalkProofExport
  , auditVexelBalanceArrayProofExport
  , auditMagicMaxelConservationProofExport
  ]

public export
%macro
auditCoreCatalog : Elab (allTrue Reflect.Auditor.Core.coreCatalogWitnesses = True)
auditCoreCatalog = auditCatalogWitnesses coreCatalogWitnesses


