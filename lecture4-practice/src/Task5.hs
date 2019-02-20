{-# LANGUAGE InstanceSigs #-}

module Task5
  ( foldMap
  ) where

import Prelude

data Tree a
  = Leaf a
  | Branch (Tree a) a (Tree a)

instance Foldable Tree where
  foldr :: (a -> b -> b) -> b -> Tree a -> b
  foldr f z (Leaf x)       = f x z
  foldr f z (Branch l x r) = foldr f (x `f` foldr f z r) l

  foldl :: (b -> a -> b) -> b -> Tree a -> b
  foldl f z (Leaf x)       = f z x
  foldl f z (Branch l x r) = foldl f (foldl f z l `f` x) r
