{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE TypeApplications #-}
{-# LANGUAGE DataKinds #-}
{-# LANGUAGE ScopedTypeVariables #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE InstanceSigs #-}
{-# LANGUAGE FunctionalDependencies #-}
module STLC where

import Prelude ()
import Universum

import Data.Vinyl.TypeLevel (Nat (..))
import Data.Kind (Type)

class STLC expr where
  lam1  :: (expr v -> expr a) -> expr (v -> a)
  (@@)  :: expr (v -> a) -> expr v -> expr a

newtype Interpret a = Interpret { interpret :: a }

instance STLC Interpret where
  lam1 f = Interpret $ \a -> interpret (f $ Interpret a)
  f @@ x = Interpret $ (interpret f) (interpret x)

  {-# INLINE lam1 #-}
  {-# INLINE (@@) #-}

ixToVarName :: Int -> String
ixToVarName i
  | 0 <= i && i < 26 = chr (ord 'a' + i) : []
  | i >= 26 = 'v' : show i
  | otherwise = error "negative var ix"

instance STLC (Const (Reader Int Text)) where
  lam1 f = Const $ asks (toText . ixToVarName) >>=
    \v -> (\e -> "(\\" <> v <> " -> " <> e <> ")") <$> local (+1) (getConst $ f $ Const $ pure v)
  Const f @@ Const x = Const $ liftA2 (\x y -> x <> " " <> y) f x

class Lam expr a b where
  lam :: (expr v -> a) -> expr (v -> b)

instance STLC expr => Lam expr (expr a) a where
  lam = lam1

instance (STLC expr, Lam expr b c) => Lam expr (expr a -> b) (a -> c) where
  lam f = lam1 (lam . f)

lam2 :: STLC expr => (expr v -> expr a -> expr b) -> expr (v -> a -> b)
lam2 = lam

lam3 :: STLC expr => (expr v -> expr a -> expr b -> expr c) -> expr (v -> a -> b -> c)
lam3 = lam

lam4 :: STLC expr => (expr v -> expr a -> expr b -> expr c -> expr d) -> expr (v -> a -> b -> c -> d)
lam4 = lam

flip_ :: forall expr a b c . STLC expr => expr ((a -> b -> c) -> b -> a -> c)
flip_ = lam $ \f a b -> f @@ b @@ a

constE
  :: STLC expr
  => expr b -> expr (a -> b)
constE = lam1 . const

