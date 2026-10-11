module Observation.FundamentalSubstrateLaws

import Stage0.BoxInt
import Stage1.FourGeometries
import Stage1.SubstrateMetricTensor
import Evolution.Init
import Data.Fin
import Data.Vect
import Data.List

%default total

------------------------------------------------------------------------
-- 1. MODEL CONSTANTS & GEOMETRIC CAPACITIES
------------------------------------------------------------------------

||| Canonical Model Capacity for the Parabolic Dark Matter Substrate (T_10 = 55).
public export
DarkMatterCapacity : Nat
DarkMatterCapacity = Stage1.FourGeometries.darkMatterTriangularResidue

||| Canonical 10D Phase Space Basis Dimension (4 Spacetime + 3 Color + 3 Scale).
public export
PhaseSpaceBasisDim : Nat
PhaseSpaceBasisDim = Stage1.FourGeometries.phaseSpaceBasisDim

||| Exact Discrete Cosmological Capacity partitioned across the 4 Fundamental Geometries:
||| - Elliptic:   27 states (Baryon Spatial Grid VM, 3^3)
||| - Hyperbolic: 128 states (Dark Energy ROM, 2^7)
||| - Parabolic:  55 states (Dark Matter Substrate Sink, T_10)
||| - Substrate:  210 states (Cosmic Master Primorial Budget, 2*3*5*7)
public export
CosmicCapacity : FundamentalGeometry -> Nat
CosmicCapacity EllipticGeom   = Stage1.FourGeometries.ellipticLatticeCapacity     -- 27
CosmicCapacity HyperbolicGeom = Stage1.FourGeometries.hyperbolicRomCapacity       -- 128
CosmicCapacity ParabolicGeom  = Stage1.FourGeometries.darkMatterTriangularResidue -- 55
CosmicCapacity SubstrateGeom  = Stage1.FourGeometries.primorial210Budget          -- 210

------------------------------------------------------------------------
-- 2. SUBSTRATE TENSOR CHANNELS & LAW SCHEMA
------------------------------------------------------------------------

||| A coordinate channel (i, j) on the 10D phase space substrate (1 <= i <= j <= 10).
public export
record SubstrateChannel where
  constructor MkChannel
  row : Nat
  col : Nat

public export
Eq SubstrateChannel where
  (MkChannel r1 c1) == (MkChannel r2 c2) = r1 == r2 && c1 == c2

public export
Show SubstrateChannel where
  show (MkChannel r c) = "(" ++ show r ++ ", " ++ show c ++ ")"

||| Fundamental Vacuum Substrate Law dependently indexed by the exact model capacity (cap : Nat).
||| Statically guarantees that the channel index is strictly bounded in Fin cap,
||| eliminating integer overflow and unconstrained BoxInt indices.
public export
record FundamentalSubstrateLaw (cap : Nat) where
  constructor MkSubstrateLaw
  channelIndex       : Fin cap
  channel            : SubstrateChannel
  sector             : MetricSector
  lawTitle           : String
  quadranceInvariant : BoxInt
  geometry           : FundamentalGeometry

public export
Eq (FundamentalSubstrateLaw cap) where
  (MkSubstrateLaw i1 c1 s1 t1 q1 g1) == (MkSubstrateLaw i2 c2 s2 t2 q2 g2) =
    i1 == i2 && c1 == c2 && s1 == s2 && t1 == t2 && q1 == q2 && g1 == g2

public export
Show (FundamentalSubstrateLaw cap) where
  show (MkSubstrateLaw idx ch sec title q geom) =
    "SubstrateLaw[" ++ show (finToNat idx + 1) ++ " " ++ show ch ++ " | " ++ title ++ " | Q=" ++ show (unwrapBox q) ++ "]"

||| Canonical type alias for the 55 Dark Matter Substrate Laws.
public export
SubstrateLaw : Type
SubstrateLaw = FundamentalSubstrateLaw DarkMatterCapacity

------------------------------------------------------------------------
-- 3. CANONICAL BIJECTION: 55 CHANNELS TO 55 FUNDAMENTAL SUBSTRATE LAWS
------------------------------------------------------------------------

||| Physical metadata for each upper-triangular substrate coordinate channel.
public export
channelData : SubstrateChannel -> (MetricSector, String, BoxInt, FundamentalGeometry)
channelData (MkChannel r c) =
  let (r', c') = if r <= c then (r, c) else (c, r)
      sec = classifySector r' c'
  in case (r', c') of
    -- Row 1: Spacetime x (Spacetime, Color, Scale)
    (1, 1)   => (sec, "Metric Timelike Proper Time Gauge Invariant", intToBoxInt 1, HyperbolicGeom)
    (1, 2)   => (sec, "Spacetime Momentum Shift Vector Invariant", intToBoxInt 0, ParabolicGeom)
    (1, 3)   => (sec, "Spacetime Angular Momentum Shift Invariant", intToBoxInt 0, ParabolicGeom)
    (1, 4)   => (sec, "Spacetime Z-Axis Gravitational Shear Invariant", intToBoxInt 0, ParabolicGeom)
    (1, 5)   => (sec, "Temporal Gauge Red Chromoelectric Potential", intToBoxInt 1, HyperbolicGeom)
    (1, 6)   => (sec, "Temporal Gauge Green Chromoelectric Potential", intToBoxInt 1, HyperbolicGeom)
    (1, 7)   => (sec, "Temporal Gauge Blue Chromoelectric Potential", intToBoxInt 1, HyperbolicGeom)
    (1, 8)   => (sec, "Temporal Dilaton Blue Conformal Metric", intToBoxInt 25, EllipticGeom)
    (1, 9)   => (sec, "Temporal Dilaton Red Hyperbolic Flux", intToBoxInt 7, HyperbolicGeom)
    (1, 10)  => (sec, "Temporal Dilaton Green Dissipation Drain", intToBoxInt 24, ParabolicGeom)

    -- Row 2: Spacetime X x (Spacetime, Color, Scale)
    (2, 2)   => (sec, "Spacetime X-Axis Spatial Metric Confinement", intToBoxInt 25, EllipticGeom)
    (2, 3)   => (sec, "XY Spatial Cross-Curvature Dissipation", intToBoxInt 0, ParabolicGeom)
    (2, 4)   => (sec, "XZ Spatial Cross-Curvature Dissipation", intToBoxInt 0, ParabolicGeom)
    (2, 5)   => (sec, "Spatial Red Chromomagnetic Gauge Field", intToBoxInt 1, HyperbolicGeom)
    (2, 6)   => (sec, "Spatial Green Chromomagnetic Gauge Field", intToBoxInt 1, HyperbolicGeom)
    (2, 7)   => (sec, "Spatial Blue Chromomagnetic Gauge Field", intToBoxInt 1, HyperbolicGeom)
    (2, 8)   => (sec, "X-Axis Spatial Blue Scale Metric", intToBoxInt 25, EllipticGeom)
    (2, 9)   => (sec, "X-Axis Spatial Red Scale Flux", intToBoxInt 7, HyperbolicGeom)
    (2, 10)  => (sec, "X-Axis Spatial Green Scale Drain", intToBoxInt 24, ParabolicGeom)

    -- Row 3: Spacetime Y x (Spacetime, Color, Scale)
    (3, 3)   => (sec, "Spacetime Y-Axis Spatial Metric Confinement", intToBoxInt 25, EllipticGeom)
    (3, 4)   => (sec, "YZ Spatial Cross-Curvature Dissipation", intToBoxInt 0, ParabolicGeom)
    (3, 5)   => (sec, "Y-Axis Red Chromomagnetic Gauge Field", intToBoxInt 1, HyperbolicGeom)
    (3, 6)   => (sec, "Y-Axis Green Chromomagnetic Gauge Field", intToBoxInt 1, HyperbolicGeom)
    (3, 7)   => (sec, "Y-Axis Blue Chromomagnetic Gauge Field", intToBoxInt 1, HyperbolicGeom)
    (3, 8)   => (sec, "Y-Axis Spatial Blue Scale Metric", intToBoxInt 25, EllipticGeom)
    (3, 9)   => (sec, "Y-Axis Spatial Red Scale Flux", intToBoxInt 7, HyperbolicGeom)
    (3, 10)  => (sec, "Y-Axis Spatial Green Scale Drain", intToBoxInt 24, ParabolicGeom)

    -- Row 4: Spacetime Z x (Spacetime, Color, Scale)
    (4, 4)   => (sec, "Spacetime Z-Axis Spatial Metric Confinement", intToBoxInt 25, EllipticGeom)
    (4, 5)   => (sec, "Z-Axis Red Chromomagnetic Gauge Field", intToBoxInt 1, HyperbolicGeom)
    (4, 6)   => (sec, "Z-Axis Green Chromomagnetic Gauge Field", intToBoxInt 1, HyperbolicGeom)
    (4, 7)   => (sec, "Z-Axis Blue Chromomagnetic Gauge Field", intToBoxInt 1, HyperbolicGeom)
    (4, 8)   => (sec, "Z-Axis Spatial Blue Scale Metric", intToBoxInt 25, EllipticGeom)
    (4, 9)   => (sec, "Z-Axis Spatial Red Scale Flux", intToBoxInt 7, HyperbolicGeom)
    (4, 10)  => (sec, "Z-Axis Spatial Green Scale Drain", intToBoxInt 24, ParabolicGeom)

    -- Row 5: Red Color x (Color, Scale)
    (5, 5)   => (sec, "SU(3) Red Color Confinement Casimir", intToBoxInt 27, EllipticGeom)
    (5, 6)   => (sec, "SU(3) Red-Green Gluon Exchange Null Curvature", intToBoxInt 0, ParabolicGeom)
    (5, 7)   => (sec, "SU(3) Red-Blue Gluon Exchange Null Curvature", intToBoxInt 0, ParabolicGeom)
    (5, 8)   => (sec, "Red Color Blue Scale Confinement Coupling", intToBoxInt 25, EllipticGeom)
    (5, 9)   => (sec, "Red Color Red Scale Gauge Flux", intToBoxInt 7, HyperbolicGeom)
    (5, 10)  => (sec, "Red Color Green Scale Dissipation Coupling", intToBoxInt 24, ParabolicGeom)

    -- Row 6: Green Color x (Color, Scale)
    (6, 6)   => (sec, "SU(3) Green Color Confinement Casimir", intToBoxInt 27, EllipticGeom)
    (6, 7)   => (sec, "SU(3) Green-Blue Gluon Exchange Null Curvature", intToBoxInt 0, ParabolicGeom)
    (6, 8)   => (sec, "Green Color Blue Scale Confinement Coupling", intToBoxInt 25, EllipticGeom)
    (6, 9)   => (sec, "Green Color Red Scale Gauge Flux", intToBoxInt 7, HyperbolicGeom)
    (6, 10)  => (sec, "Green Color Green Scale Dissipation Coupling", intToBoxInt 24, ParabolicGeom)

    -- Row 7: Blue Color x (Color, Scale)
    (7, 7)   => (sec, "SU(3) Blue Color Confinement Casimir", intToBoxInt 27, EllipticGeom)
    (7, 8)   => (sec, "Blue Color Blue Scale Confinement Coupling", intToBoxInt 25, EllipticGeom)
    (7, 9)   => (sec, "Blue Color Red Scale Gauge Flux", intToBoxInt 7, HyperbolicGeom)
    (7, 10)  => (sec, "Blue Color Green Scale Dissipation Coupling", intToBoxInt 24, ParabolicGeom)

    -- Row 8: Blue Scale x Scale
    (8, 8)   => (sec, "Chromogeometric Blue Confinement Quadrance Q_Blue", intToBoxInt 25, EllipticGeom)
    (8, 9)   => (sec, "Chromogeometric Red Hyperbolic Flux Q_Red", intToBoxInt 7, HyperbolicGeom)
    (8, 10)  => (sec, "Chromogeometric Green Parabolic Spread Q_Green", intToBoxInt 24, ParabolicGeom)

    -- Row 9: Red Scale x Scale
    (9, 9)   => (sec, "Hyperbolic Lightcone Phase Invariant Q=0", intToBoxInt 0, HyperbolicGeom)
    (9, 10)  => (sec, "Pythagorean Triad Relation Q_Red^2 + Q_Green^2 = Q_Blue^2", intToBoxInt 25, EllipticGeom)

    -- Row 10: Green Scale x Scale
    (10, 10) => (sec, "Substrate Null Remainder Drain g22=0 g12=1", intToBoxInt 0, ParabolicGeom)

    -- Exhaustive fallback
    _ => (sec, "Vacuum Invariant Residual", intToBoxInt 0, ParabolicGeom)

||| Smart constructor building a Dark Matter Substrate Law from bounded index and coordinate channel.
public export
makeSubstrateLaw : Fin DarkMatterCapacity -> SubstrateChannel -> SubstrateLaw
makeSubstrateLaw idx ch =
  let (sec, title, q, geom) = channelData ch
  in MkSubstrateLaw idx ch sec title q geom

------------------------------------------------------------------------
-- 4. THE COMPLETE VECTOR OF 55 FUNDAMENTAL SUBSTRATE LAWS
------------------------------------------------------------------------

||| Canonical listing of the 55 upper-triangular substrate channels in order.
public export
AllSubstrateChannels : Vect DarkMatterCapacity SubstrateChannel
AllSubstrateChannels =
  [ MkChannel 1 1, MkChannel 1 2, MkChannel 1 3, MkChannel 1 4, MkChannel 1 5, MkChannel 1 6, MkChannel 1 7, MkChannel 1 8, MkChannel 1 9, MkChannel 1 10
  , MkChannel 2 2, MkChannel 2 3, MkChannel 2 4, MkChannel 2 5, MkChannel 2 6, MkChannel 2 7, MkChannel 2 8, MkChannel 2 9, MkChannel 2 10
  , MkChannel 3 3, MkChannel 3 4, MkChannel 3 5, MkChannel 3 6, MkChannel 3 7, MkChannel 3 8, MkChannel 3 9, MkChannel 3 10
  , MkChannel 4 4, MkChannel 4 5, MkChannel 4 6, MkChannel 4 7, MkChannel 4 8, MkChannel 4 9, MkChannel 4 10
  , MkChannel 5 5, MkChannel 5 6, MkChannel 5 7, MkChannel 5 8, MkChannel 5 9, MkChannel 5 10
  , MkChannel 6 6, MkChannel 6 7, MkChannel 6 8, MkChannel 6 9, MkChannel 6 10
  , MkChannel 7 7, MkChannel 7 8, MkChannel 7 9, MkChannel 7 10
  , MkChannel 8 8, MkChannel 8 9, MkChannel 8 10
  , MkChannel 9 9, MkChannel 9 10
  , MkChannel 10 10
  ]

public export
allSubstrateChannels : List SubstrateChannel
allSubstrateChannels = toList AllSubstrateChannels

||| The canonical vector of 55 Fundamental Substrate Laws dependently indexed by Fin DarkMatterCapacity.
public export
FundamentalSubstrateCatalog : Vect DarkMatterCapacity SubstrateLaw
FundamentalSubstrateCatalog =
  zipWith makeSubstrateLaw (allFins DarkMatterCapacity) AllSubstrateChannels

||| The canonical list of 55 Fundamental Substrate Laws.
public export
fundamentalSubstrateCatalog : List SubstrateLaw
fundamentalSubstrateCatalog = toList FundamentalSubstrateCatalog

------------------------------------------------------------------------
-- 5. FORMAL AUDIT PROOFS & COMPILE-TIME REFLECTION WITNESSES
------------------------------------------------------------------------

||| Audits that all 55 fundamental laws are populated and match the 55 substrate channels.
public export
auditFundamentalSubstrateLawsProof : Bool
auditFundamentalSubstrateLawsProof =
  length fundamentalSubstrateCatalog == 55

||| Definitional proof that the fundamental substrate catalog vector has length exactly 55.
public export
0 prfFundamentalSubstrateCatalogLengthIs55 :
  Data.Vect.length FundamentalSubstrateCatalog = 55
prfFundamentalSubstrateCatalogLengthIs55 = Refl

||| Definitional proof that the Dark Matter substrate law channels count from Evolution.Init is 55.
public export
0 prfSubstrateLawCountMatchesEvolutionInit :
  Evolution.Init.substrateLawChannelCount = 55
prfSubstrateLawCountMatchesEvolutionInit = Refl

||| Definitional proof that DarkMatterCapacity is exactly 55.
public export
0 prfDarkMatterCapacityMatchesTriangularResidue :
  DarkMatterCapacity = 55
prfDarkMatterCapacityMatchesTriangularResidue = Refl

||| Definitional proof that DarkMatterCapacity matches Evolution.Init.substrateLawChannelCount.
public export
0 prfDarkMatterCapacityMatchesEvolutionInit :
  DarkMatterCapacity = Evolution.Init.substrateLawChannelCount
prfDarkMatterCapacityMatchesEvolutionInit = Refl
