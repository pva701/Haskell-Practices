module Task4
  ( foldMap
  ) where

import Prelude hiding (Foldable, foldMap)

class Foldable t where
  foldMap :: Monoid m => (a -> m) -> t a -> m

instance Foldable [] where
  foldMap _ [] = mempty
  foldMap f (x:xs) = f x <> foldMap f xs
