{-# LANGUAGE TemplateHaskell #-}

module Task1
  ( Point (..)
  , x
  , y
  , Atom (..)
  , point
  , checkXY
  , checkXY1
  , incX
  , incX1
  , atomX
  , atomY
  , reflect
  , move

  , element
  ) where

import Lens.Micro.Extras (view)
import Lens.Micro ((^.), over, (%~), (&), Lens')
import Lens.Micro.TH (makeLenses)

data Point = Point {
    _x :: Int
  , _y :: Int
  } deriving (Show)
makeLenses ''Point

data Atom = Atom {
    _element :: String
  , _point   :: Point
  } deriving (Show)

makeLenses ''Atom

atom :: Atom
atom = Atom "C" (Point 3 4)

checkXY :: Bool
checkXY = view (point . x) atom == 3 && view (point . y) atom == 4

checkXY1 :: Bool
checkXY1 = atom ^. point . x == 3 && atom ^. point . y == 4

incX :: Atom
incX = over (point . x) (+1) atom

incX1 :: Atom
incX1 = atom & point . x %~ (+1)

atomX :: Lens' Atom Int
atomX = point . x

atomY :: Lens' Atom Int
atomY = point . x

reflect :: Atom -> Atom
reflect a = a & atomX %~ negate
              & atomY %~ negate

move :: Point -> Atom -> Atom
move (Point sx sy) a =
  a & atomX %~ (+sx)
    & atomY %~ (+sy)
