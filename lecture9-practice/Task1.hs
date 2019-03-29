{-# LANGUAGE GeneralizedNewtypeDeriving #-}
{-# LANGUAGE LambdaCase #-}

import Control.Concurrent
import Control.Exception
import Control.Applicative (liftA2)

data MyException = MyException
  deriving Show
instance Exception MyException

data OtherThreadException = OtherThreadException
  deriving Show
instance Exception OtherThreadException

-- Note that this solution might still
-- be missing some details and certainly shall
-- not be considered production-ready.
--
-- But still, it shows the idea
-- of how `concurrently` is implemented inside.
concurrently :: IO a -> IO b -> IO (a, b)
concurrently actA actB = do
  aTid <- myThreadId
  bMV <- newEmptyMVar
  bTid <-
    forkIO $
      (actB >>= putMVar bMV . Right)
        `catch` (\OtherThreadException -> pure ())
        `catch` (\e -> mask_ $ putMVar bMV (Left e) )
  aRes <-
    actA
      `catch`
        \(SomeException e) -> do
            throwTo bTid OtherThreadException
              `catch` \(SomeException e) -> pure ()
            throw e
  bResE <- takeMVar bMV
  case bResE of
    Left (SomeException e) -> throw e
    Right bRes -> pure (aRes, bRes)

main = do
  let action1 = do
        threadDelay 500000
        pure "foo"
  let action2 = do
        threadDelay 500000
        throwIO MyException
        pure "bar"
  (res1, res2) <- concurrently action1 action2
  putStrLn $ "Computed " <> res1 <> " and " <> res2
