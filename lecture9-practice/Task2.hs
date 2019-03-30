import Control.Exception
import Control.Monad (replicateM)
import System.IO (openFile, hClose, IOMode(..), hGetChar)

-- In practice, use `withFile` instead of handmade
-- construction with bracket
main = do
  fiveChars <-
    bracket (openFile "README.md" ReadMode) hClose $
      \handle -> replicateM 5 (hGetChar handle)
  putStrLn $ "Read 5 chars: '" <> fiveChars <> "'"

