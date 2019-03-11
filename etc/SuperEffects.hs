-- To load this file you need following packages:
-- "free union random vinyl"
--
-- For Nix:
-- nix-shell -p "haskellPackages.ghcWithPackages (pkgs: with pkgs; [ free union random vinyl ])" --run ghci

{-# LANGUAGE DataKinds #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE FlexibleContexts #-}

import Control.Monad
import Control.Monad.Free
import Data.Union
import Data.Vinyl
import Data.Vinyl.TypeLevel (RIndex)
import System.Random hiding (RandomGen)

type family EffectRes s :: *

data RandomGen = RandomGen
data WriteLn = WriteLn { unWriteLn :: String }

type instance EffectRes RandomGen = Int
type instance EffectRes WriteLn = ()

data MyFEl a s = MyFEl s (EffectRes s -> a)

fmapMyFEl :: (a -> b) -> MyFEl a s -> MyFEl b s
fmapMyFEl f (MyFEl s h) = MyFEl s (fmap f h)

newtype MyF xs a = MyF ( Union (MyFEl a) xs)

instance Functor (MyF xs) where
  f `fmap` (MyF u) = MyF (umap (fmapMyFEl f) u)

effect
  :: (UElem s xs (RIndex s xs))
  => s -> Free (MyF xs) (EffectRes s)
effect = Free . MyF . ulift . flip MyFEl pure

newtype Handler m s = Handler ( s -> m (EffectRes s) )

runMyF
  :: Monad m
  => Rec (Handler m) xs -> MyF xs (m a) -> m a
runMyF (Handler h1 :& hRest) (MyF u) =
  union (runMyF hRest . MyF) handle u
  where
    handle (MyFEl e resH) = resH =<< h1 e
runMyF RNil (MyF u) = absurdUnion u

myExecution :: Free (MyF '[ RandomGen , WriteLn ]) Int
myExecution = do
  rand1 <- effect RandomGen
  rand2 <- effect RandomGen
  effect $ WriteLn $ "Generated two random numbers: "
    <> show rand1 <> " " <> show rand2
  pure $ rand1 ^ 2 + rand2

runExecution :: IO Int
runExecution = iterM (runMyF handlers) myExecution
  where
    handlers =
         Handler (const randomIO)
      :& Handler (putStrLn . unWriteLn)
      :& RNil
