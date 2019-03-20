module Task3
  ( Tree (..)
  ) where

import Control.DeepSeq (NFData (..))

import Task1 (DList (..), toList)

instance NFData a => NFData (DList a) where
  rnf = rnf . toList

data Tree a
  = Branch (Tree a) a (Tree a)
  | Leaf

instance NFData a => NFData (Tree a) where
  rnf Leaf = ()
  rnf (Branch l a r) = rnf l `seq` rnf a `seq` rnf r
