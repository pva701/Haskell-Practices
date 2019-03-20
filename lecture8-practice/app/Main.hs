{-# LANGUAGE BangPatterns #-}

module Main where

import System.Random (newStdGen, randomRs)
import System.CPUTime
import qualified Data.Vector as V
import Control.DeepSeq (rnf, NFData)
import Text.Printf

import Task5 (quickSort)

measure :: (NFData a, Ord a) => String -> V.Vector a -> IO ()
measure name !a = do
  start <- getCPUTime
  let res = rnf $ quickSort a
  end   <- res `seq` getCPUTime
  let diff = (fromIntegral (end - start)) / (10^12)
  printf "%s computation took: %0.3f sec\n" name (diff :: Double)

main :: IO ()
main = do
  g <- newStdGen
  let ls1 = take (10^5) $ randomRs (0, 10^9) g :: [Int]
  let ls2 = take (10^6) $ randomRs (0, 10^9) g :: [Int]
  measure "Sorting 10^5 ints" $ V.fromList ls1
  measure "Sorting 10^6 ints" $ V.fromList ls2
