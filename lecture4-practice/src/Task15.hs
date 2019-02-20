module Task15
  ( Path (..)
  , createAbs
  , createRel
  , Abs
  , Rel
  ) where

import Prelude

import Control.Applicative (liftA2)
import Data.Char (isAlphaNum)
import Data.List (isPrefixOf)
import Data.List.Split (splitOn)

newtype Path a = Path {unPath :: [String]}
  deriving Show

data Abs
data Rel

createAbs :: String -> Maybe (Path Abs)
createAbs s
   | "/" `isPrefixOf` s = Path . unPath <$> createRel (drop 1 s)
   | otherwise          = Nothing

createRel :: String -> Maybe (Path Rel)
createRel s' =
  let s = if "./" `isPrefixOf` s'
          then drop 2 s'
          else s'
      path = splitOn "/" s
      checkFragment = \x -> all (liftA2 (||) isAlphaNum (== '.')) x && length x > 0
  in  if all checkFragment path then Just $ Path path
      else Nothing
