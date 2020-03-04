# Practice for Lecture 4
## Monoids. Foldable

### Задание 1
Реализуйте инстансы `Semigroup`, `Monoid` для 
```haskell
newtype Last a = Last (Maybe a)
```

### Задание 2
Реализуйте функцию
```haskell
mconcat :: Monoid m => [m] -> m
```

### Задание 3
Реализуйте функцию через [foldr](http://hackage.haskell.org/package/base-4.12.0.0/docs/Data-Foldable.html#v:foldr)
```haskell
foldMap :: (Foldable f, Monoid m) => (a -> m) -> f a -> m
```

### Задание 4
Реализуйте инстанс `Foldable` для `[a]` через
```haskell
foldMap :: (Foldable f, Monoid m) => (a -> m) -> f a -> m
```

### Задание 5
Реализуйте функцию 
```haskell
foldr :: Foldable t => (a -> b -> b) -> b -> t a -> b
```
через
```haskell
foldMap :: (Foldable t, Monoid m) => (a -> m) -> t a -> m
```

### Задание 5*

Сравнить перформанс `f (+) 0 [1..10000000]` ,
подставляя в качестве `f` функции `foldl`, `foldr`, `foldl'`, `foldr'`.

Для сравнения перформанса запустите `ghci` и введите `:set +s`.

Объясните разницу в полученных замерах времени исполнения.

## Functor. Applicative. Traversable

### Задание 6

Определите инстанс классов `Functor` и `Applicative`  для следующего типа данных, представляющего точку в трёхмерном пространстве:
```haskell
data Point3D a = Point3D a a a 
  deriving Show
```
```haskell
ghci> fmap (+ 1) (Point3D 5 6 7)
Point3D 6 7 8
```

### Задание 7
Определите инстанс классов `Functor` и `Applicative` для бинарного дерева, 
в каждом узле которого хранятся элементы типа `Maybe`:
```haskell
data Tree a 
  = Leaf (Maybe a) 
  | Branch (Tree a) (Maybe a) (Tree a) 
  deriving Show
```

### Задание 8
Реализуйте операторы
```haskell
(<$) :: Functor f => a -> f b -> f a
```
Который является `<$>` отбрасывающим второй аргумент.

```haskell
(*>) :: Applicative f => f a -> f b -> f b
```
Который является `<*>` отбрасывающим первый аргумент.

### Задание 9
Реализуйте инстанс [Traversable](http://hackage.haskell.org/package/base-4.12.0.0/docs/Data-Traversable.html#t:Traversable) для
```haskell
data Tree a 
  = Leaf a 
  | Branch (Tree a) (Tree a)
```

### Задание 10
Реализуйте 
```haskell
traverse :: (Traversable t, Applicative f) => (a -> f b) -> t a -> f (t b)
```
из тайпкласса `Traversable` через
```haskell
sequenceA :: (Traversable t, Applicative f) => t (f a) -> f (t a)
```

### Задание 11
Реализуйте `sequenceA` через `traverse`.

## Phantom types

### Задание 12
У вас есть `newtype`
```haskell
newtype Path a = Path {unPath :: [String]}
  deriving Show
```
содержащий список компонент пути в файловой системе

Значения фантомного типа `a` могут быть
```haskell
data Abs -- для абсолютного пути
data Rel -- для относительного
```

Реализуйте следующие функции:
```haskell
createAbs :: String -> Maybe (Path Abs)
createRel :: String -> Maybe (Path Rel)
```
Будем считать, что абсолютный путь начинается с `/`, 
а относительный может начинаться с `./` либо просто с названия папки или файла.
Название папки или файла - это непустая строка, которая может содержать латинские буквы, цифры и точки

### Задание 13
Реализуйте инстансы `Semigroup` и `Monoid` для `Path` не используя `deriving`.
А также реализуйте функцию `isSubPath`, которая проверяет что первый переданный путь
является подпутем второго.

### Задание 14
Реализуйте оператор `</>`, который конкатенирует два пути.
Имейти ввиду, что два абсолютных пути сконкатенировать нелья.
Также нельзя добавить к относительному пути абсолютный.

```haskell
ghci> a :: Path Abs = Path ["home", "user", "work"]
ghci> b :: Path Rel = Path ["github"]
ghci> c :: Path Rel = Path ["fp-homework"]
ghci> a </> b
Path {unPath = ["home","user","work","github"]}
ghci> b </> c
Path {unPath = ["github","fp-homework"]}
```

[![MIT license](https://img.shields.io/badge/license-MIT-blue.svg)](https://github.com//fp-homework/blob/master/hw1/LICENSE)
