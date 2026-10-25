module Reflect.PermutationSolver

import Stage0.BoxInt
import Data.Vect
import Data.List
import Language.Reflection
import public Reflect.Auditor.Core

%default total

||| Swaps adjacent elements in a list at index k.
public export
swapAtList : Nat -> List a -> List a
swapAtList Z (x :: y :: rest) = y :: x :: rest
swapAtList (S j) (x :: rest)   = x :: swapAtList j rest
swapAtList _ xs                = xs

||| Applies a sequence of adjacent swaps to a list.
public export
applySwaps : List Nat -> List a -> List a
applySwaps [] xs = xs
applySwaps (k :: ks) xs = applySwaps ks (swapAtList k xs)

||| Finds the index of the first occurrence of an element in a list.
public export
findElemIndex : Nat -> List Nat -> Maybe Nat
findElemIndex target [] = Nothing
findElemIndex target (x :: xs) =
  if x == target
    then Just 0
    else map S (findElemIndex target xs)

||| Moves an element at index src to the front (index 0) using adjacent swaps.
||| Returns the list of swap indices [src - 1, src - 2, ..., 0].
public export
bubbleToFront : Nat -> List Nat
bubbleToFront Z = []
bubbleToFront (S k) = k :: bubbleToFront k

||| Helper to constructively compute the adjacent swap sequence transforming xs into target ys.
public export
solveSwapsHelper : Nat -> List Nat -> List Nat -> Maybe (List Nat)
solveSwapsHelper Z [] [] = Just []
solveSwapsHelper (S fuel) (y :: ys) current =
  case findElemIndex y current of
    Nothing => Nothing
    Just idx =>
      let swapsToFront = bubbleToFront idx
          afterFront = applySwaps swapsToFront current
      in case afterFront of
           (_ :: rest) =>
             case solveSwapsHelper fuel ys rest of
               Nothing => Nothing
               Just restSwaps =>
                 let shiftedRestSwaps = map S restSwaps
                 in Just (swapsToFront ++ shiftedRestSwaps)
           [] => Nothing
solveSwapsHelper _ _ _ = Nothing

||| Calculates the sequence of adjacent swap indices to transform list A into list B.
||| Returns Just [swapIdx1, swapIdx2, ...] if B is a valid permutation of A.
public export
calculateAdjacentSwaps : List Nat -> List Nat -> Maybe (List Nat)
calculateAdjacentSwaps xs ys =
  if length xs /= length ys
    then Nothing
    else solveSwapsHelper (length xs) ys xs

||| Swaps adjacent elements at index 0 in a vector.
public export
swapHead : Vect (2 + n) a -> Vect (2 + n) a
swapHead (x :: y :: rest) = y :: x :: rest

||| Swaps adjacent elements at a specific index k in a vector.
public export
swapAt : (k : Nat) -> Vect (2 + k + n) a -> Vect (2 + k + n) a
swapAt Z xs = swapHead xs
swapAt (S j) (x :: rest) = x :: swapAt j rest

------------------------------------------------------------------------
-- PERMUTATION GROUP Sn AS PERMUTATION MAXELS
------------------------------------------------------------------------

||| Converts a permutation mapping (where index i maps to target dst in 1..n) into a permutation Maxel:
||| P_sigma = sum_{i=1}^n [i, sigma(i)].
public export
permutationToMaxel : List Nat -> Maxel
permutationToMaxel perm =
  let pairs = zipWith (\src, dst => (MkPixel src dst, intToBoxInt 1)) [1..(length perm)] perm
  in canonicalizeMaxel (MkMaxel pairs)

||| Creates an elementary adjacent transposition Maxel swapping index k and k+1 in an n-dimensional space.
public export
swapTranspositionMaxel : (dim : Nat) -> (k : Nat) -> Maxel
swapTranspositionMaxel dim k =
  let identityPerm = [1..dim]
      swapped = swapAtList k identityPerm
  in permutationToMaxel swapped

||| Applies a permutation to a Vexel via pure Maxel-Vexel matrix contraction:
||| v' = P_sigma * v.
public export
permuteVexel : List Nat -> Vexel -> Vexel
permuteVexel perm v =
  let pMaxel = permutationToMaxel perm
  in actMaxelVexel pMaxel v

------------------------------------------------------------------------
-- COMPILE-TIME REFLECTION SOLVER PROOFS & WITNESSES
------------------------------------------------------------------------

||| Compile-time verification that swap solver correctly factorizes a permutation.
public export
auditPermutationSolverProof : Bool
auditPermutationSolverProof =
  let p1 = [1, 2, 3, 4]
      p2 = [3, 1, 4, 2]
  in case calculateAdjacentSwaps p1 p2 of
       Just swaps => applySwaps swaps p1 == p2
       Nothing    => False

||| Audits that acting on a Vexel with permutation Maxel re-indexes elements correctly:
||| For perm = [2, 3, 1] and v = { [1]=>10, [2]=>20, [3]=>30 },
||| P_sigma * v evaluates to { [1]=>20, [2]=>30, [3]=>10 }.
public export
auditPermutationMaxelActionProof : Bool
auditPermutationMaxelActionProof =
  let perm = [2, 3, 1]
      v = MkVexel [ (MkUnixel 1, intToBoxInt 10)
                  , (MkUnixel 2, intToBoxInt 20)
                  , (MkUnixel 3, intToBoxInt 30)
                  ]
      vPerm = permuteVexel perm v
  in boxEq (lookupUnixel (MkUnixel 1) vPerm) (intToBoxInt 20) &&
     boxEq (lookupUnixel (MkUnixel 2) vPerm) (intToBoxInt 30) &&
     boxEq (lookupUnixel (MkUnixel 3) vPerm) (intToBoxInt 10)

||| Compile-time macro verifying permutation action on Vexels via permutation Maxels.
export
%macro
auditPermutationMaxelAction : Elab (Reflect.PermutationSolver.auditPermutationMaxelActionProof = True)
auditPermutationMaxelAction = auditWitness auditPermutationMaxelActionProof

------------------------------------------------------------------------
-- YOUNG TABLEAUX HOOK-LENGTH FORMULA & Sn REPRESENTATIONS
------------------------------------------------------------------------

||| Factorial of a natural number n!.
public export
factorialNat : Nat -> Nat
factorialNat Z = 1
factorialNat (S k) = (S k) * factorialNat k

||| Computes the column length at column index col (1-indexed) of a Young diagram.
public export
colLength : List Nat -> (col : Nat) -> Nat
colLength rowLens col =
  length (filter (\r => r >= col) rowLens)

||| Computes the Hook Length of box (row, col) in a Young diagram:
||| h(i, j) = (row_len - j) + (col_len - i) + 1.
public export
hookLengthBox : List Nat -> (rowIdx : Nat) -> (rowLen : Nat) -> (colIdx : Nat) -> Nat
hookLengthBox rowLens rowIdx rowLen colIdx =
  let arm = if rowLen >= colIdx then minus rowLen colIdx else 0
      colLen = colLength rowLens colIdx
      leg = if colLen >= rowIdx then minus colLen rowIdx else 0
  in arm + leg + 1

||| Product of all hook lengths in a Young diagram for partition lambda.
public export
hookLengthProduct : List Nat -> Nat
hookLengthProduct rowLens =
  let colHooks : (rowIdx : Nat) -> (rowLen : Nat) -> (colCountdown : Nat) -> List Nat
      colHooks _ _ Z = []
      colHooks rowIdx rowLen (S remaining) =
        let colIdx = minus rowLen remaining
        in (hookLengthBox rowLens rowIdx rowLen colIdx) :: colHooks rowIdx rowLen remaining

      allRows : Nat -> List Nat -> List Nat
      allRows _ [] = []
      allRows rowIdx (rLen :: rest) = colHooks rowIdx rLen rLen ++ allRows (S rowIdx) rest
  in foldl (*) 1 (allRows 1 rowLens)



||| Exact integer division on Nat reducing definitionally at compile-time.
public export
divExactNat : Nat -> Nat -> Nat
divExactNat num Z = 0
divExactNat num (S dMinus1) =
  let step : Nat -> Nat -> Nat
      step Z _ = 0
      step (S n) remaining =
        if remaining == 0
          then S (step n dMinus1)
          else step n (minus remaining 1)
  in step num dMinus1

||| Dimension of the Irreducible Representation of Sn corresponding to partition lambda |- n:
||| dim(lambda) = n! / prod_{(i, j)} h(i, j).
public export
representationDimension : List Nat -> Nat
representationDimension rowLens =
  let n = sum rowLens
      hProd = hookLengthProduct rowLens
  in divExactNat (factorialNat n) hProd


||| Audits the Hook-Length Formula on S3:
||| Partitions of 3:
||| - [3]: dim = 3! / (3*2*1) = 6/6 = 1 (Trivial)
||| - [2, 1]: dim = 3! / (3*1*1) = 6/3 = 2 (Standard representation)
||| - [1, 1, 1]: dim = 3! / (3*2*1) = 6/6 = 1 (Sign representation)
||| Burnside identity: 1^2 + 2^2 + 1^2 = 1 + 4 + 1 = 6 = 3!.
public export
auditHookLengthProof : Bool
auditHookLengthProof =
  let dTriv = representationDimension [3]
      dStd  = representationDimension [2, 1]
      dSign = representationDimension [1, 1, 1]
      sumSquares = (dTriv * dTriv) + (dStd * dStd) + (dSign * dSign)
  in dTriv == 1 && dStd == 2 && dSign == 1 && sumSquares == 6

||| Compile-time macro verifying the Young Tableaux Hook-Length formula and S3 Burnside identity.
export
%macro
auditHookLengthFormula : Elab (Reflect.PermutationSolver.auditHookLengthProof = True)
auditHookLengthFormula = auditWitness auditHookLengthProof
