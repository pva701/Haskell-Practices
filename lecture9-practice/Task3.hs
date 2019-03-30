import System.Random
import Data.IORef
import Control.Exception
import Control.Concurrent.Async (race)
import Control.Monad
import Data.List (sort)
import Control.DeepSeq (($!!))

-- To compile this, use
--  @
--  ghc -o test -O2 Task3.hs -threaded
--  @
--
-- and run with:
--
--  @
--  ./test +RTS -N2
--  @

lengths = [3, 10, 100, 1000, 10000, 50000]
repetitions = 100

doCompare sort1 sort2 l = do
  res <- compareSorts l repetitions sort1 sort2
  let f = fromIntegral res / fromIntegral repetitions :: Double
  putStrLn $ "Length = " <> show l <> "    sort1: " <> show f <> ", sort2: " <> show (1 - f)

main = do
  putStrLn "Comparing mergeSort and quicksort"
  mapM_ (doCompare mergeSort quickSort) lengths

  putStrLn "Comparing mergeSort and Data.List.sort"
  mapM_ (doCompare mergeSort sort) lengths

  putStrLn "Comparing quicksort and Data.List.sort"
  mapM_ (doCompare quickSort sort) lengths

-- Output:
--
-- Comparing mergeSort and quicksort
-- Length = 3    sort1: 0.1, sort2: 0.9
-- Length = 10    sort1: 0.2, sort2: 0.8
-- Length = 100    sort1: 0.9, sort2: 9.999999999999998e-2
-- Length = 1000    sort1: 1.0, sort2: 0.0
-- Length = 10000    sort1: 1.0, sort2: 0.0
-- Length = 50000    sort1: 1.0, sort2: 0.0
-- Comparing mergeSort and Data.List.sort
-- Length = 3    sort1: 2.0e-2, sort2: 0.98
-- Length = 10    sort1: 0.0, sort2: 1.0
-- Length = 100    sort1: 0.96, sort2: 4.0000000000000036e-2
-- Length = 1000    sort1: 0.82, sort2: 0.18000000000000005
-- Length = 10000    sort1: 1.0, sort2: 0.0
-- Length = 50000    sort1: 1.0, sort2: 0.0
-- Comparing quicksort and Data.List.sort
-- Length = 3    sort1: 1.0e-2, sort2: 0.99
-- Length = 10    sort1: 2.0e-2, sort2: 0.98
-- Length = 100    sort1: 8.0e-2, sort2: 0.92
-- Length = 1000    sort1: 0.0, sort2: 1.0
-- Length = 10000    sort1: 0.0, sort2: 1.0
-- Length = 50000    sort1: 0.0, sort2: 1.0

randomList :: Int -> IO [Int]
randomList l = do
  lst <- replicateM l $ randomRIO (0, 2*l)
  pure $!! lst

compareSorts
  :: Int -- ^ length of list
  -> Int -- ^ number of repetitions
  -> ([Int] -> [Int]) -- ^ sorting function 1
  -> ([Int] -> [Int]) -- ^ sorting function 2
  -> IO Int -- ^ how many times sorting function 1 won
compareSorts l n s1 s2 = do
  s1WonCnt <- newIORef 0
  replicateM n $ do
    let inverse = n `mod` 2 == 0
    -- ^ for some reason race is sometimes biased to first, so we
    -- make competition more honest
    l <- randomList l
    raceRes <-
      if inverse
        then
          race (pure $!! s2 l) (pure $!! s1 l)
        else
          race (pure $!! s1 l) (pure $!! s2 l)
    let (s1Won, res) = either ((,) $ not inverse) ((,) inverse) raceRes
    when (res /= sort l) $
      throw $ userError $
        "Wrong sort by " <> (if s1Won then "1" else "2")
                         <> " on " <> show l
    when s1Won $
      modifyIORef s1WonCnt (+1)
  readIORef s1WonCnt

quickSort :: Ord t => [t] -> [t]
quickSort [] = []
quickSort (p:xs) = (quickSort lesser) ++ [p] ++ (quickSort greater)
  where
    lesser = filter (< p) xs
    greater = filter (>= p) xs

-- | Returns sorted list, O(N * log N) time complexity
-- >>> mergeSort [8,3,1,5]
-- [1,3,5,8]
-- >>> mergeSort []
-- []
-- >>> mergeSort [1,17,5,3,89,-2]
-- [-2,1,3,5,17,89]
-- >>> mergeSort [5,1,-2,4,1]
-- [-2,1,1,4,5]
-- >>> mergeSort [5,7,0,-1,-3,1,5,99,1,1]
-- [-3,-1,0,1,1,1,5,5,7,99]
--
-- Implementation by Ilya Kokorin
mergeSort :: Ord t => [t] -> [t]
mergeSort [] = []
mergeSort [x] = [x]
mergeSort list =
  let (first, second) = divide (length list `div` 2) list
   in merge (mergeSort first) (mergeSort second)
  where
    merge :: Ord t => [t] -> [t] -> [t]
    merge xs ys = reverse $ mergeAcc xs ys []

    mergeAcc :: Ord t => [t] -> [t] -> [t] -> [t]
    mergeAcc [] second acc = reverse second ++ acc
    mergeAcc first [] acc  = reverse first ++ acc
    mergeAcc first@(x:xs) second@(y:ys) acc
      | x <= y    = mergeAcc xs second (x : acc)
      | otherwise = mergeAcc first ys (y : acc)

    divide :: Int -> [t] -> ([t], [t])
    divide elementsToCut l =
      let (left, right) = divideAcc elementsToCut [] l
       in (reverse left, right)

    divideAcc :: Int -> [t] -> [t] -> ([t], [t])
    divideAcc _ acc [] = (acc, [])
    divideAcc elementsLeft acc l@(x:xs)
      | elementsLeft > 0 = divideAcc (elementsLeft - 1) (x : acc) xs
      | otherwise        = (acc, l)

