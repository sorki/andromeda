{-# LANGUAGE ScopedTypeVariables #-}
module Andromeda.Lambda.StdLib where

import GHC.TypeLits

import Andromeda.Lambda.NatR
import Andromeda.Lambda.Expr
import Andromeda.Lambda.Type
import Andromeda.Lambda.Utils

scalar :: KnownScalar a => Scalar a -> String -> Expr a
scalar ty name = Var (V name (VectT (Vect (TS TZ) ty)))

vecn :: (KnownScalar a, KnownNat n) =>
         NatR n -> Scalar a -> String -> Expr (VecN n a)
vecn n ty name = Var (V name (VectT (Vect n ty)))

sampler :: KnownNat n => NatR n -> String -> Expr (Sampler n)
sampler n name = Var (V name (SamplerT n))

scalarTy :: KnownScalar a => Scalar a -> Type a
scalarTy ty = VectT (Vect (TS TZ) ty)

vecTy :: (KnownScalar a, KnownNat n) =>
    NatR n -> Scalar a -> Type (VecN n a)
vecTy n ty = VectT (Vect n ty)

pair :: forall a b. (HasType a, HasType b) => Expr (a -> b -> (a, b))
pair = -- Lit Pair
    let ta = typeOf (undefined :: a)
        tb = typeOf (undefined :: b)
        tf = ta :->: tb :->: (ta :*: tb)
    in Lit (PrimOp tf)

unit :: Expr ()
unit = Lit (PrimOp UnitT)