module Task13
  ( traverse
  ) where

import Prelude hiding (traverse)

traverse :: (Traversable t, Applicative f) => (a -> f b) -> t a -> f (t b)
traverse f xs = sequenceA $ f <$> xs
