{-# LANGUAGE FlexibleContexts #-}

module Task0
  ( f
  , f1
  , f2
  )where

import Control.Monad.Except (throwError, runExceptT, catchError, MonadError, runExcept)
import Control.Monad.State (runState, modify, MonadState, runStateT)

f :: (MonadError String m, MonadState Int m) => m ()
f =
  (modify (const 5) *> throwError "Nope")
    `catchError` \_ -> pure ()

f1 :: (Either String (), Int)
f1 = flip runState 0 $ runExceptT f

f2 :: Either String ((), Int)
f2 = runExcept $ runStateT f 0

-- *Main> f1
-- (Right (),5)
-- *Main> f2
-- Right ((),0)
