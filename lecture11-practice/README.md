# Lecture 11 practice

## Task one

Consider GADT-based DSL `ArithExpr` from lecture slides.

Add bool literal and multiply function to it, update show instances and interpreter.

```
data ArithExpr a where
  AENum  :: Int -> ArithExpr Int
  AEBool :: Bool -> ArithExpr Bool
  AEPlus :: ArithExpr Int -> ArithExpr Int -> ArithExpr Int
  AEAnd  :: ArithExpr Bool -> ArithExpr Bool -> ArithExpr Bool
  AEGt   :: ArithExpr Int -> ArithExpr Int -> ArithExpr Bool
```
