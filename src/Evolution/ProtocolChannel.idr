module Evolution.ProtocolChannel

import public Evolution.PolynumberTransducer

import Stage0.BoxInt
import Stage1.Polynumber
import Stage1.UnixelFraction
import Stage1.MaxelTransform
import Evolution.State
import Evolution.LinearPipeline
import Evolution.Expansion
import Evolution.Contraction
import Data.Vect

%default total

------------------------------------------------------------------------
-- BACKWARD COMPATIBILITY ALIASES: TRANSDUCER REPLACES PROTOCOL CHANNEL
------------------------------------------------------------------------

||| Backward-compatible alias for MultisetClockTransducer.
||| Channel terminology is superseded by MultisetClockTransducer.
public export
PhysicsChannel : Polynumber -> Nat -> Nat -> Nat -> Type
PhysicsChannel = MultisetClockTransducer

||| Constructor alias
public export
MkPhysicsChannel : UniverseState vm de dm -> MultisetClockTransducer poly vm de dm
MkPhysicsChannel = MkClockTransducer

||| Backward-compatible step alias
public export
stepPhysicsChannelTick : {vm, de, dm, newCells : Nat} ->
                        {poly : Polynumber} ->
                        (1 ch : PhysicsChannel poly vm de dm) ->
                        (budgetTokens : Vect newCells BoxInt) ->
                        PhysicsChannel (addPolynumber poly (monomialPolynumber (intToBoxInt 1) newCells)) 
                                       (vm + newCells) de dm
stepPhysicsChannelTick = stepClockTransducerTick

||| Backward-compatible fold alias
public export
foldPhysicsChannel137 : {vm, de, dm, k : Nat} ->
                       {poly : Polynumber} ->
                       (1 ch : PhysicsChannel poly vm de dm) ->
                       (newTokens : Vect k BoxInt) ->
                       (remainder : BoxInt) ->
                       PhysicsChannel (snd (foldEpochPolynumber poly (toPolynumber Stage1.Polynumber.cyclotomic137DepPoly)))
                                      (vm + k) de (S dm)
foldPhysicsChannel137 = foldClockTransducer137

||| Backward-compatible interact alias
public export
interactPhysicsChannels : {vmA, deA, dmA, vmB, deB, dmB : Nat} ->
                          {polyA, polyB : Polynumber} ->
                          (1 chA : PhysicsChannel polyA vmA deA dmA) ->
                          (1 chB : PhysicsChannel polyB vmB deB dmB) ->
                          (w : BoxInt) ->
                          ( PhysicsChannel polyA vmA deA dmA
                          , PhysicsChannel (addPolynumber polyB (monomialPolynumber w 1)) (vmB + 1) deB dmB
                          )
interactPhysicsChannels = interactClockTransducers

||| Backward-compatible pullback alias
public export
autoScaleGaloisPullback : {vm, de, dm : Nat} ->
                          {poly : Polynumber} ->
                          (1 ch : PhysicsChannel poly vm de dm) ->
                          (gridTokens : Vect 4 BoxInt) ->
                          PhysicsChannel (addPolynumber poly (monomialPolynumber (intToBoxInt 1) 4)) (vm + 4) de dm
autoScaleGaloisPullback = autoScaleGaloisPullbackTransducer

||| Backward-compatible pushforward alias
public export
autoScaleGaloisPushforward : {vm, de, dm : Nat} ->
                             {poly : Polynumber} ->
                             (1 ch : PhysicsChannel poly vm de dm) ->
                             (remainder : BoxInt) ->
                             PhysicsChannel (snd (foldEpochPolynumber poly (toPolynumber Stage1.Polynumber.cyclotomic137DepPoly))) (vm + 1) de (S dm)
autoScaleGaloisPushforward = autoScaleGaloisPushforwardTransducer

||| Backward-compatible audit alias
public export
auditProtocolChannelConservationProof : Bool
auditProtocolChannelConservationProof = auditClockTransducerConservationProof
