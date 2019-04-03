module Task3
  ( incPair
  ) where

import Lens.Micro (over)
import Data.Traversable (Traversable (..))

data Pair a = Pair a a

instance Functor Pair where
  fmap f (Pair x y) = Pair (f x) (f y)

instance Foldable Pair where
  foldr f z (Pair x y) = f x (f y z)

instance Traversable Pair where
  traverse f (Pair x y) = Pair <$> f x <*> f y

incPair :: Num a => Pair a -> Pair a
incPair = over traverse (+1)
