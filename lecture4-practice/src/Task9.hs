module Task9
  ( Point3D (..)
  ) where

import Prelude

data Point3D a = Point3D a a a
  deriving Show

instance Functor Point3D where
  fmap f (Point3D x y z) = Point3D (f x) (f y) (f z)

instance Applicative Point3D where
  pure x = Point3D x x x
  Point3D f1 f2 f3 <*> Point3D x y z = Point3D (f1 x) (f2 y) (f3 z)
