module Task1
  (
  ) where

import Prelude

newtype Last a = Last (Maybe a)

instance Semigroup (Last a) where
  a <> Last Nothing = a
  _ <> b            = b

instance Monoid (Last a) where
  mempty = Last Nothing
