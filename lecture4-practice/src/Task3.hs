module Task3
  ( foldMap
  ) where

import Prelude hiding (foldMap)

foldMap :: (Foldable f, Monoid m) => (a -> m) -> f a -> m
foldMap f = foldr (mappend . f) mempty
