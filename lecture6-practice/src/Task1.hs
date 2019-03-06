module Task1
  ( main1
  ) where

import Prelude

main1 :: IO ()
main1 = do
  putStrLn "What is your name?"
  putStr "Name: "
  name <- getLine
  if name == ""
  then main1
  else putStrLn $ "Hi, " ++ name ++ "!"
