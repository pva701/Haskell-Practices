import Control.Monad.Trans.Reader (ReaderT, runReaderT, ask, local)
import Control.Monad.Catch (throwM, Exception)
import Text.Read (readMaybe)
import Control.Monad (when)
import Control.Monad.IO.Class (liftIO)

data Command = Push Int | Pop | Add | Exit
  deriving (Read, Show)

data StackError = UnexpectedStack
  deriving Show

instance Exception StackError

main :: IO ()
main = runReaderT stackApp [] >>=
        putStrLn . ("Final stack " <>) . show

stackApp :: ReaderT [Int] IO [Int]
stackApp = do
  cmd <- liftIO getLine
  maybe (liftIO (putStrLn "Wrong command")
          >> stackApp)
        handleCommand $ readMaybe cmd

handleCommand :: Command -> ReaderT [Int] IO [Int]
handleCommand = error "TODO implement me"

