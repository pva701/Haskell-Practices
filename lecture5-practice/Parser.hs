module Parser where

import qualified Data.Set as S
import Control.Applicative (liftA2, Alternative (..))
import Control.Monad (replicateM)
import Data.List.NonEmpty (NonEmpty (..))

first :: (a -> c) -> (a, b) -> (c, b)
first f (r, s) = (f r, s)

newtype Parser a = Parser { runP :: String -> Maybe (a, String) }

instance Functor Parser where
    fmap f (Parser parser) = Parser (fmap (first f) . parser)

instance Applicative Parser where
    pure a = Parser $ \s -> Just (a, s)

-- ==== Task one =====
-- Rewrite (<*>) for Parser below with use
-- of `Monad Maybe`.

    -- Parser pf <*> Parser pa = Parser $ \s -> case pf s of
    --     Nothing     -> Nothing
    --     Just (f, t) -> case pa t of
    --         Nothing     -> Nothing
    --         Just (a, r) -> Just (f a, r)

    Parser pf <*> Parser pa = Parser $ \s -> do
      (f, t) <- pf s
      (a, r) <- pa t
      pure (f a, r)

---------------------------------------
-- Grammar 1
--
-- "[1]"
-- "[1,3,4,5]"
--
-- (non-empty integer list, no spaces)
---------------------------------------

someChar :: S.Set Char -> Parser Char
someChar cs = Parser $ \s ->
  case s of
    c' : rs ->
      if c' `S.member` cs
        then Just (c', rs)
        else Nothing
    _ -> Nothing

char :: Char -> Parser Char
char = someChar . S.singleton

myMany :: Parser a -> Parser [a]
myMany oneParser = Parser $ \s ->
  case runP oneParser s of
    Nothing -> Just ([], s)
    Just (a, s') ->
      first (a :) <$> runP (myMany oneParser) s'

int :: Parser Int
int = read <$> liftA2 (:) numChar (many numChar)
  where
    numChar = someChar $ S.fromList "0123456789"

neIntList :: Parser (NonEmpty Int)
neIntList =
  char '[' *>
    liftA2 (:|) int (myMany (char ',' *> int))
   <* char ']'


-- Example runs:
--
--
-- *Parser> runP neIntList "[23]"
--   Just (23 :| [],"")
-- *Parser> runP neIntList "[23, 34, 56]"
--   Nothing
-- *Parser> runP neIntList "[23,34,56]"
--   Just (23 :| [34,56],"")
-- *Parser> runP neIntList "[23,34,56] "
--   Just (23 :| [34,56]," ")
-- *Parser> runP neIntList "[23,34,56 ] "
--   Nothing
-- *Parser> runP neIntList "[23,34,56] "
--   Just (23 :| [34,56]," "


---------------------------------------
-- Grammar 2
--
-- "[]"
-- "[1]"
-- "[1,3,4,5]"
--
-- (integer list, no spaces)
---------------------------------------

-- ==== Task two =====
-- Implement `instance Alternative Parser` and use its
-- method (<|>) to parse Grammar 2.
--
-- Hint: for `Alternative Parser` instance implementation
-- use existing `Alternative Maybe`.
--
-- Do not use methods of `Monad Parser`!

intList :: Parser [Int]
intList = (char '[' *>) $
        ([] <$ char ']')
    <|> (liftA2 (:) int (many (char ',' *> int)) <* char ']')

instance Alternative Parser where
  empty = Parser $ const Nothing
  (Parser pa) <|> (Parser pb) = Parser $ \s -> pa s <|> pb s


---------------------------------------
-- Grammar 3
--
-- We want to parse list of strings from
-- the following awkward format:
--
-- <list> = <string> <list> | EOF
-- <string> = "0" | <num> ":" <chars>
-- <num> = "0" | ... | "9"
-- <chars> = <any char> | <chars>
--
-- There is a condition that `<chars>` is a char string of
-- length given by corresponding `<num>`.
--
-- Examples (string and parse Haskell value).
--
-- "3:a1b" -> ["a1b"]
-- "0" -> [""]
-- "" -> []
-- "3:2:b02:z&" -> ["2:b", "", "z&"]
--
---------------------------------------

-- ==== Task three =====
-- Implement `instance Monad Parser` and use it
-- to implement Grammar 3.

anyChar :: Parser Char
anyChar = Parser $ \s ->
  case s of
    c : rest -> Just (c, rest)
    _ -> Nothing

instance Monad Parser where
  return = pure
  (Parser p) >>= qf = Parser $ \s -> do
    (r, t) <- p s
    runP (qf r) t

intNoLeadingZero :: Parser Int
intNoLeadingZero =
    (char '0' *> pure 0)
    <|> (read <$> liftA2 (:) numChar (many numChar))
  where
    numChar = someChar $ S.fromList "0123456789"

stringLists :: Parser [String]
stringLists = many $ intNoLeadingZero >>= readChars
  where
    readChars 0 = pure ""
    readChars i = char ':' *> replicateM i anyChar
