module Task7
  ( foldr
  ) where

import Prelude hiding (foldr)

import Task6 (Endo (..))

foldr :: Foldable t => (a -> b -> b) -> b -> t a -> b
foldr f z ts = appEndo (foldMap (Endo . f) ts) z
