module Task16
  ( isSubPath
  ) where

import Prelude

import Data.List (isInfixOf)

import Task15 (Path(..))

instance Semigroup (Path a) where
  Path a <> Path b = Path $ a <> b

instance Monoid (Path a) where
  mempty = Path mempty

isSubPath :: Path tag1 -> Path tag2 -> Bool
isSubPath (Path sub) (Path a) = sub `isInfixOf` a
