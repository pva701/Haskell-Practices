module Task10
  ( Tree (..)
  ) where

import Prelude

data Tree a
  = Leaf (Maybe a)
  | Branch (Tree a) (Maybe a) (Tree a)
  deriving Show

instance Functor Tree where
  fmap f (Leaf x) = Leaf $ f <$> x
  fmap f (Branch l x r) = Branch (f <$> l) (f <$> x) (f <$> r)

instance Applicative Tree where
  pure = Leaf . Just

  Leaf f <*> Leaf x             = Leaf $ f <*> x
  Leaf f <*> Branch _ x _       = Leaf (f <*> x)
  Branch _ f _ <*> Leaf x       = Leaf (f <*> x)
  Branch l f r <*> Branch a x b = Branch (l <*> a) (f <*> x) (r <*> b)

