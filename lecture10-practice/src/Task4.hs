{-# LANGUAGE Rank2Types #-}

module Task4
  ( atoms
  , atomsTs
  , atomsPt
  , atomsX
  , atomsY
  , moveAtoms
  ) where

import Lens.Micro (Traversal', Lens', over)
import Data.Traversable (Traversable (..))

import Task1 (Atom, Point, point, x, y, move)
import Task2 (Molecule (..))

lens :: (s -> a) -> (s -> a -> s) -> Lens' s a
lens get set = \f s -> set s <$> f (get s)

atoms :: Lens' Molecule [Atom]
atoms = lens _atoms (\m ats -> m {_atoms = ats})

atomsTs :: Traversal' Molecule Atom
atomsTs = atoms . traverse

atomsPt :: Traversal' Molecule Point
atomsPt = atomsTs . point

atomsX  :: Traversal' Molecule Int
atomsX = atomsPt . x

atomsY  :: Traversal' Molecule Int
atomsY = atomsPt . y

moveAtoms :: Point -> Molecule -> Molecule
moveAtoms p = over atomsTs (move p)
