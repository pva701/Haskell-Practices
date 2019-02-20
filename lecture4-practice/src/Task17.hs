module Task17
  ( (</>)
  ) where

import Prelude

import Task15 (Path(..), Abs, Rel)

class AppendableTag x where

instance AppendableTag Abs where
instance AppendableTag Rel where

(</>) :: AppendableTag tag => Path tag -> Path Rel -> Path tag
Path p </> (Path x) = Path $ p <> x


