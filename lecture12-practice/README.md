# Lecture 12 practice

## Task one

Rewrite AST from lecture 11:

```
data ArithExpr a where
  AENum  :: Int -> ArithExpr Int
  AEBool :: Bool -> ArithExpr Bool
  AEPlus :: ArithExpr Int -> ArithExpr Int -> ArithExpr Int
  AEAnd  :: ArithExpr Bool -> ArithExpr Bool -> ArithExpr Bool
  AEGt   :: ArithExpr Int -> ArithExpr Int -> ArithExpr Bool
```

To use following data as type for expression:

```
data ArithType = AInt | ABool
```

## Task two

Implement `HList`:

```
data HList :: [*] -> * where
  HNil :: HList '[]
  (:^) :: a -> HList t -> HList (a ': t)
```

with `Rec` data type from `vinyl` package.


## Task three

Add custom effect `AppendToFile` to our effect system from

https://github.com/pva701/Haskell-Practices/blob/master/etc/SuperEffects.hs.

Write example code which generates 5 random numbers and prints them both to some fixed file
and to console.

## Task four

Write a function that calculates dot product
of two numerical vectors:

```
data Vec :: * -> Nat -> * where
  Nil  :: Vec a 0
  (:>) :: a -> Vec a n -> Vec a (n + 1)
```

## Task five

This is a hard task :).

Consider STLC formalization with following type:

```
class STLC expr where
  lam1  :: (expr v -> expr a) -> expr (v -> a)
  (@@)  :: expr (v -> a) -> expr v -> expr a
```

Extend this formalization with int and double expressions:

```
class (STLC expr, Num (expr Int), Num (expr Double)) => Expr expr where
  round :: expr Double -> expr Int
  fromInt :: expr Int -> expr Double
```

Implement pretty-printing for `Expr expr` and then implement conversion
for `Expr expr` from following "raw" data type (conversion returns either
`expr Double` or `expr Int` or an error):

```haskell
data SimpleLam =
    Lam SimpleLam
  | Ref Int -- de Brujin encoding of a variable within lambda abstraction
  | Plus SimpleLam SimpleLam
  | Minus SimpleLam SimpleLam
  | Mult SimpleLam SimpleLam
  | Round SimpleLam
  | FromInt SimleLam
```

Hint: use `Rec` data type to store context of
variables within lambda you're currently parsing.
