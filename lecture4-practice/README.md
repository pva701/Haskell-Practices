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


[![MIT license](https://img.shields.io/badge/license-MIT-blue.svg)](https://github.com//fp-homework/blob/master/hw1/LICENSE)
