{-# LANGUAGE BangPatterns #-}

module Task2
  ( fib
  , fibSlow
  ) where

-- fib 0 == 1
-- fib 1 == 1
-- fib 2 == 2

-- ghci> rnf $ fib 1000000
-- ()
-- (4.92 secs, 44,169,345,312 bytes)
fib :: Int -> Integer
fib = fibImpl (1, 1)
  where
    fibImpl :: (Integer, Integer) -> Int -> Integer
    fibImpl (!a, !b) !n
       | n <= 1    = b
       | otherwise = fibImpl (b, a + b) (n - 1)


-- ghci> rnf $ fibSlow 1000000
-- ()
-- (43.66 secs, 44,211,386,480 bytes)
fibSlow :: Int -> Integer
fibSlow = fibImpl (1, 1)
  where
    fibImpl :: (Integer, Integer) -> Int -> Integer
    fibImpl (a, b) n
       | n <= 1    = b
       | otherwise = fibImpl (b, a + b) (n - 1)
