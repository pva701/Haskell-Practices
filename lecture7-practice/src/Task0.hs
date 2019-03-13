{-# LANGUAGE FlexibleContexts #-}

import Control.Monad.Except (ExceptT (..), throwError, runExceptT, catchError, MonadError, runExcept)
import Control.Monad.State (State, runState, modify, MonadState, runStateT)

f :: (MonadError String m, MonadState Int m) => m ()
f = do
  (modify (const 5) *> throwError "Nope")
    `catchError` \_ -> pure ()

f1 :: (Either String (), Int)
f1 = flip runState 0 $ runExceptT f

f2 :: Either String ((), Int)
f2 = runExcept $ flip runStateT 0 f

-- *Main> f1
-- (Right (),5)
-- *Main> f2
-- Right ((),0)
