{-# LANGUAGE InstanceSigs #-}

module Task12
  ( Tree (..)
  ) where

import Prelude

data Tree a
  = Leaf a
  | Branch (Tree a) a (Tree a)

instance Functor Tree where
  fmap f (Leaf a) = Leaf $ f a
  fmap f (Branch l x r) = Branch (f <$> l) (f x) (f <$> r)

instance Foldable Tree where
  foldMap :: Monoid m => (a -> m) -> Tree a -> m
  foldMap f (Leaf x) = f x
  foldMap f (Branch l x r) = foldMap f l <> f x <> foldMap f r

instance Traversable Tree where
  traverse :: Applicative f => (a -> f b) -> Tree a -> f (Tree b)
  traverse f (Leaf x) = Leaf <$> f x
  traverse f (Branch l x r) = Branch <$> traverse f l <*> f x <*> traverse f r
