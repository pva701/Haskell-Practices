{-# LANGUAGE LambdaCase #-}

module Task3
  ( main3
  ) where

import Prelude

import Control.Monad (forM_, liftM2)
import Data.Array.IO (IOArray, getElems, newListArray, readArray, writeArray)
import Data.List (intercalate)
import Data.IORef (newIORef, readIORef, writeIORef)

selectionSort :: [Int] -> IO [Int]
selectionSort xs = do
  let l = length xs
  a <- newListArray (0, l - 1) xs :: IO (IOArray Int Int)
  forM_ [0..l-1] $ \i -> do
    mn <- newIORef i
    forM_ [i+1..l-1] $ \j -> do
      mnidx <- readIORef mn
      liftM2 (>) (readArray a mnidx) (readArray a j) >>= \case
        True  -> writeIORef mn j
        False -> pure ()
    mnIndex <- readIORef mn
    tmp <- readArray a mnIndex
    writeArray a mnIndex =<< readArray a i
    writeArray a i tmp
  getElems a

main3 :: IO ()
main3 =
  map read . words <$> getLine >>=
  selectionSort >>=
  putStrLn . intercalate " " . map show

