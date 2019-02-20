module Task14
  ( sequenceA
  ) where

import Prelude hiding (sequenceA)

sequenceA :: (Traversable t, Applicative f) => t (f a) -> f (t a)
sequenceA = traverse id
