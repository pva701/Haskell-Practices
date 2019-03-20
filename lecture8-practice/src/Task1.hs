{-# LANGUAGE ViewPatterns #-}

module Task1
  ( DList (..)
  , fromList
  , toList
  , cons
  , snoc
  , filter
  , zip
  , filterWrong
  , zipWrong
  ) where

import qualified Prelude as P
import Prelude hiding (map, filter, zip)

newtype DList a = DList { unDL :: [a] -> [a] }

fromList :: [a] -> DList a
fromList xs = DList (xs ++)

toList :: DList a -> [a]
toList (DList f) = f []

cons :: a -> DList a -> DList a
cons x (DList f) = DList $ (x:) . f

snoc :: DList a -> a -> DList a
snoc (DList f) x = DList $ f . (x:)

filter :: (a -> Bool) -> DList a -> DList a
filter f (DList xs) = DList (P.filter f (xs []) ++)

zip :: DList a -> DList b -> DList (a, b)
zip (DList fa) (DList fb) = DList (P.zip (fa []) (fb []) ++)

filterWrong :: (a -> Bool) -> DList a -> DList a
filterWrong f (DList xs) = DList $ P.filter f . xs

zipWrong :: DList a -> DList b -> DList (a, b)
zipWrong (DList fa) (DList fb) = DList $ \(unzip -> (axs, bxs)) -> P.zip (fa axs) (fb bxs)
