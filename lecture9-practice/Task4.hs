import System.Random (randomRs, RandomGen, newStdGen, split)
import Data.Monoid (Sum(..))
import Data.Foldable(foldr')
import System.Environment (getArgs)
import Control.Parallel.Strategies (runEval, rpar)


integrate
  :: RandomGen g
  => g -- ^ Random generator
  -> Int -- ^ Number of random points to generate
  -> Double -- ^ Lower bound
  -> Double -- ^ Upper bound
  -> (Double -> Double) -- ^ Function to integrate
  -> Double
integrate gen n low up f =
    foldr' ((+) . f) 0 rands / fromIntegral n * (up - low)
  where
    rands = take n $ randomRs (low, up) gen

splits gen 0 = []
splits gen i = gen2 `seq` gen1 `seq` gen2 : splits gen1 (i - 1)
  where
    (gen1, gen2) = split gen


-- As an example, let's integrate
--
--  cos (x) ^ 3
--
-- over the range [0.3 ; 0.8]
main = do
  gen <- newStdGen
  isParallel <- read . (!! 0) <$> getArgs
  n <- read . (!! 1) <$> getArgs
  let low = 0.3
  let up = 0.8
  let f x = cos(x) ^ 3
  let res = if isParallel
              then
                let gens = splits gen 10
                    integratePar gen = rpar $ integrate gen (n `div` 10) low up f
                 in foldr' (+) 0 (runEval $ mapM integratePar gens) / 10
              else integrate gen n low up f
  putStrLn $ "Integrated: " <> show res
