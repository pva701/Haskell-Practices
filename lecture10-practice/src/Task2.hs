{-# LANGUAGE Rank2Types #-}

module Task2
  ( Molecule (..)
  , atomsTs
  ) where

import Lens.Micro (Traversal')

import Task1 (Atom)

data Molecule = Molecule
  { _atoms :: [Atom]
  }

atomsTs :: Traversal' Molecule Atom
atomsTs _ (Molecule []) = pure $ Molecule []
atomsTs f (Molecule (x : xs)) =
  (\x' (Molecule xs') -> Molecule $ x' : xs') <$> f x <*> atomsTs f (Molecule xs)
