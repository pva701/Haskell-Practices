module Task5
  ( unsafeInterleaveIO
  , unIO
  ) where

import Prelude hiding (IO)

data State s
data RealWorld

newtype IO a = IO {unIO :: State RealWorld -> (State RealWorld, a)}

unsafeInterleaveIO :: IO a -> IO a
unsafeInterleaveIO (IO m) = IO $ \s ->
  let r = case m s of
              (_, res) -> res
  in (s, r)
