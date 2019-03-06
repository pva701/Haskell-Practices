{-# LANGUAGE LambdaCase #-}

module Task2
  ( main2
  ) where

import Prelude

import Control.Monad (filterM, forM_, when)
import Data.String (fromString)
import qualified Data.Text as T
import System.Directory
  (doesDirectoryExist, doesFileExist, getDirectoryContents, renameFile, withCurrentDirectory)
import System.Environment (getArgs)

main2 :: IO ()
main2 = getArgs >>= \case
  [dir, s1', s2'] -> do
    let (s1, s2) = (fromString s1', fromString s2')
    ex <- doesDirectoryExist dir
    if not ex then
      putStrLn $ "Directory " <> dir <> " doesn't exist"
    else withCurrentDirectory dir $ do
      files <- filterM doesFileExist =<< getDirectoryContents "."
      forM_ files $ \f -> do
        let newF = T.unpack $ T.replace s1 s2 $ fromString f
        when (f /= newF) $ do
          putStrLn $ "Renaming " <> f <> " to " <> newF
          renameFile f newF
  _ -> putStrLn "Expected path and two strings"

