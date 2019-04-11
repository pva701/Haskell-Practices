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

Solution by Ilya Kokorin: https://gist.github.com/KokorinIlya/a80f01062b8ab824f76333c40dae7b65.

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

Solution by Nikita Dugenets: https://gist.github.com/glcanvas/5683494358ae23eb3838fb6a949bc1c2.

## Task three

Consider Tagless final-based DSL `ArithExpr` from lecture slides.

Remove `aeNum`, `aePlus` constructor and use `Num` instance following way.

```
class Num (expr Int) => ArithExpr expr where
  aeAnd  :: expr Bool -> expr Bool -> expr Bool
  aeGt   :: expr Int -> expr Int -> expr Bool
```

Update interpreter and show according to updated DSL.

Solution by Evgeniy Glukhov: https://gist.github.com/AntiFrizz1/dfdd93e1173544bb068cdac005bf5e77.

## Task four

(Super easy)

Fix `applyTwo` from lecture slides by adding type for `f` or `call`:

```
applyTwo :: ([Int], [Bool])
applyTwo = let call f = (f [2, 1, 3], f [True, False])
            in call reverse
```

Solution by Lev Dovjik: https://pastebin.com/84iy8XQi.

## Task five

Take single-threaded monte-carlo-based integral evaluation from lecture 9 practice.

Rewrite DSL from lecture to use `Double` instead of `Int`.

Update tagless final DSL with constructors for `cos (x)`, random generation (in range `[0..1]`),
and `a * b` and `mean` function.

Mean function should have signature `mean :: Int -> expr Int -> expr Int` and
`mean n calc` shall repeat expression `calc` (which internally has random coin)
`n` times.

Implement expression `myExpr` to calculate integral of `cos^3 (x)` in range `[0.3..0.8]`.

Compare performance of bare Haskell implementation and `interpret myExpr` on large repetetion numbers.

Solution by Pavel Golovin: https://gist.github.com/GoPavel/22e54b4d8c752cad8bff54d57d523269.
