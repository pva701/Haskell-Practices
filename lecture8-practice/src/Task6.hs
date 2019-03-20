{-# LANGUAGE ExistentialQuantification #-}
{-# LANGUAGE ScopedTypeVariables #-}

module Task6
  ( foldrS
  ) where

data Step s a = Done
              | Skip    s
              | Yield a s

data Stream a = forall s . Stream (s -> Step s a) s

foldrS :: (a -> b -> b) -> b -> Stream a -> b
foldrS f z (Stream next s0) = go s0
  where
    go s = case next s of
      Done       -> z
      Skip s1    -> go s1
      Yield a s1 -> a `f` go s1
