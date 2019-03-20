module Task4
  ( State (..)
  ) where

newtype State s a = State { runState :: s -> (a, s) }

instance Functor (State s) where
    fmap f (State m) = State $ \ s ->
        (\(a, s') -> (f $! a, s')) $ m s

instance Applicative (State m) where
    pure a = State $ \s -> (a, s)
    State mf <*> State mx = State $ \s ->
        let (f, s1) = mf s in
        let (x, s2) = mx s1 in
        (f $! x, s2)

instance Monad (State s) where
    return a = State $ \s -> (a, s)
    State m >>= k  = State $ \s ->
      let (a, s1) = m s in
      let (b, s2) = runState (k a) s1 in
      a `seq` b `seq` (b, s2)
