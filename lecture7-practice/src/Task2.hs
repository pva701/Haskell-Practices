import Data.Map (Map)
import qualified Data.Map as M
import Control.Monad.Except (ExceptT (..), throwError, runExceptT)
import Control.Monad.Reader (ReaderT (..), local, ask)
import Control.Monad.State (State, runState, get, modify)

type Var = String

data Template =
    Assign Var Expr
  | With Var Expr Template
  | Seq Template Template
  deriving Show

(#) :: Template -> Template -> Template
(#) = Seq

infixr 0 #

type Expr = [ SubExpr ]

data SubExpr = Ref Var | Lit String
  deriving Show

exampleTemplate :: Template
exampleTemplate =
  Assign "x" [ Lit "bla" ] #
  Assign "y" [ Lit "( ", Ref "x", Lit " )" ] #
  With "z" [ Ref "x" , Lit " ", Ref "y" ]
    ( Assign "z10" (Ref <$> replicate 10 "z") ) #
  Assign "res" [ Lit "--> ", Ref "z10", Lit " <--" ]


data TemplateError = UnknownVariable Var
  deriving Show

type Assignment = Map Var String

runTemplate :: Template -> Either TemplateError Assignment
runTemplate t = toRes $ flip runState mempty $ runExceptT $
                  runReaderT (runTemplateDo t) mempty
  where
    toRes (eRes, as) = const as <$> eRes

type TemplateDoM =
  ReaderT Assignment (ExceptT TemplateError (State Assignment))

evalExpr :: Expr -> Assignment -> Either TemplateError String
evalExpr es as = mconcat <$> mapM evalSubExpr es
  where
    evalSubExpr :: SubExpr -> Either TemplateError String
    evalSubExpr (Ref v) =
      case v `M.lookup` as of
        Just x -> pure x
        _ -> Left $ UnknownVariable v
    evalSubExpr (Lit s) = pure s

evalExpr' :: Expr -> TemplateDoM String
evalExpr' expr = do
  as <- get
  as' <- ask
  either throwError pure $ evalExpr expr (as <> as')

runTemplateDo :: Template -> TemplateDoM ()
-- runTemplateDo = error "TODO implement"
runTemplateDo (Assign v expr) = do
  res <- evalExpr' expr
  modify (M.insert v res)
runTemplateDo (With v expr t) = do
  res <- evalExpr' expr
  local (M.insert v res) (runTemplateDo t)
runTemplateDo (Seq p q) = runTemplateDo p >> runTemplateDo q
