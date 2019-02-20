module Task2
  ( mconcat
  ) where

import Prelude hiding (mconcat)

mconcat :: Monoid m => [m] -> m
mconcat = foldMap id
