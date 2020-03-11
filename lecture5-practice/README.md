# Practice for Lecture 5

Во всех заданиях подразумевается использование монад.

## Задание 1

Рассмотрим игрушечный eDSL:
```haskell
data Expr a
  = Const a
  | MinusInfinity
  | PlusInfinity
  | Add (Expr a) (Expr a)
  | Sub (Expr a) (Expr a)
  | Mul (Expr a) (Expr a)
  | Div (Expr a) (Expr a)
  | Pow (Expr a) (Expr a)

data ErrMsg
  = DivisionByZero
  | ...
```

Реализуйте функцию
```haskell
evalExpr :: (???) => Expr a -> Either ErrMsg a
```

## Задание 2

Еще один игрушечный eDSL:
```haskell
data Expr a
  = Const a
  | Var String
  | Add (Expr a) (Expr a)
  | Sub (Expr a) (Expr a)
  | Mul (Expr a) (Expr a)

type VarMap a = Map String a
```

Реализуйте функцию:
```haskell
evalExpr :: (???) => Expr a -> VarMap a -> a
```

В случае, если переменная неопределена, можно кидать ошибку с помощью `error`

## Задание 3

Больше игрушечных eDSL богу игрушечных eDSL:
```haskell
data Expr a
  = Const a
  | Add (Expr a) (Expr a)
  | Sub (Expr a) (Expr a)
  | Mul (Expr a) (Expr a)

data Statement a
  = Seq (Statement a) (Statement a)
  | EvalAndPrint (Expr a)
  | Log String
```

Реализуйте функцию:
```haskell
evalStatement :: (???) => Statement a -> String
```

## Задание 4

Реализуйте алгоритм Евклида с логированием
(для каждого шага алгоритма необходимо сообщить, чему были равны числа,
для которых считалось GCD).

```haskell
gcdWithLog :: (???) => a -> a -> ([(a, a)], a)
```

## Задание 5

Рассмотрим следующие типы:
```haskell
data Post = Post { pTitle :: String, pBody :: String }

data Blog = Blog
  { bPosts   :: [Post]
  , bCounter :: Int
  }
```

Реализуйте инстанс `Monad` для:
```haskell
newtype BlogM a = BlogM (Blog -> (a, Blog))
```

А также функции:
```haskell
readPost :: Int -> BlogM Post

newPost :: Post -> BlogM ()
```

## Задание 6

Докажите законы монад (left/right identity, associativity) для `Writer`.

## Задание 7

Докажите законы монад (left/right identity, associativity) для `Reader`.

## Задание 8

Докажите законы монад (left/right identity, associativity) для `State`.

