module Task11
  ( (<$)
  , (*>)
  , (*>!)
  ) where

import Prelude hiding ((*>), (<$))

(<$) :: Functor f => a -> f b -> f a
x <$ f = const x <$> f


(*>) :: Applicative f => f a -> f b -> f b
f *> x = const <$> x <*> f

(*>!) :: Applicative f => f a -> f b -> f b
_ *>! x = x
