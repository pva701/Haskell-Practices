module Task8
  ( secondMax
  , secondMax2
  , secondMaxWrong

  , Maxes (..)
  ) where

import Prelude

-- First solution
secondMax :: Ord a => [a] -> Maybe a
secondMax []     = Nothing
secondMax (h:xs) = snd $ foldl combine (h, Nothing) xs
  where
    combine :: Ord a => (a, Maybe a) -> a -> (a, Maybe a)
    combine r@(x, y) v
      | x > v && Just v > y = (x, Just v)
      | v > x               = (v, Just x)
      | otherwise           = r

-- Second solution
data Maxes a = Maxes {
    fmax :: Maybe a
  , smax :: Maybe a
  }

instance Ord a => Semigroup (Maxes a) where
  a <> Maxes f s = combine (combine a f) s
    where
      combine r@(Maxes x y) v
        | x > v && v > y = Maxes x v
        | v > x          = Maxes v x
        | otherwise      = r

instance Ord a => Monoid (Maxes a) where
  mempty = Maxes Nothing Nothing

secondMax2 :: Ord a => [a] -> Maybe a
secondMax2 xs = smax $ foldMap (flip Maxes Nothing . Just) xs

-- Wrong solution
secondMaxWrong :: Ord a => [a] -> Maybe a
secondMaxWrong [] = Nothing
secondMaxWrong xs = Just $ fst $ foldl searcher (h, h) xs
  where
    h = head xs
    searcher :: (Ord a) => (a, a) -> a -> (a, a)
    searcher (f, s) x = (max f x, min f (max s x))
