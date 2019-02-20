module Task6
  ( Endo (..)
  ) where

import Prelude

newtype Endo a = Endo { appEndo :: a -> a }

instance Semigroup (Endo a) where
    Endo f1 <> Endo f2 = Endo (f1 . f2)

instance Monoid (Endo a) where
  mempty = Endo id
