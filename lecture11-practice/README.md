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

## Task two

Consider Tagless final-based DSL `ArithExpr` from lecture slides.

Implement if operator: `if a b c` returns `b` is boolean expression `a`
evaluates to `True` and `c` otherwise.

```
class ArithExpr expr where
  aeNum  :: Int -> expr Int
  aePlus :: expr Int -> expr Int -> expr Int
  aeAnd  :: expr Bool -> expr Bool -> expr Bool
  aeGt   :: expr Int -> expr Int -> expr Bool
```

Update interpreter and show according to updated DSL.
