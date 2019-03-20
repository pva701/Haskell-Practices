{-# LANGUAGE MultiWayIf #-}
{-# LANGUAGE ScopedTypeVariables #-}

module Task5
  ( quickSort
  ) where

import qualified Data.Vector.Unboxed as U
-- ^ Unboxed immutable Vector
import qualified Data.Vector as V
-- ^ Boxed mutable Vector
import qualified Data.Vector.Generic as G
-- ^ Type classes to abstract Vector
import qualified Data.Vector.Mutable as M
-- ^ Boxed mutable Vector

import System.Random (randomR, StdGen, newStdGen)
import Control.Monad.State.Strict (State, put, evalState, get)
import System.IO.Unsafe (unsafePerformIO)
import Control.Applicative (liftA2)
import Debug.Trace (trace)

quickSort :: forall a . Ord a => V.Vector a -> V.Vector a
quickSort v = do
  let g = unsafePerformIO newStdGen
  trace ("StdGen " <> show g) $
    evalState (quickSortImpl v) g
  where
    quickSortImpl :: V.Vector a -> State StdGen (V.Vector a)
    quickSortImpl a
      | V.length a <= 1 = pure a
      | otherwise = do
          (m, gnew) <- randomR (0, length a - 1) <$> get
          put gnew
          let x = a V.! m
          let (l, r) = V.partition (<= x) a
          if | V.length l == 0 -> pure r
             | V.length r == 0 -> pure l
             | otherwise -> liftA2 (V.++) (quickSortImpl l) (quickSortImpl r)
