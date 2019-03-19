# Practice for Lecture 8

## Задание 1
Вам дан следующий `newtype`
```haskell
newtype DList a = DList { unDL :: [a] -> [a] }
```
Реализуйте следующие функции для него
```haskell
fromList :: [a] -> DList a

toList :: DList a -> [a]

cons :: a -> DList a -> DList a

snoc :: DList a -> a -> DList a

filter :: (a -> Bool) -> DList a -> DList a

zip :: DList a -> DList b -> DList (a, b)
```

## Задание 2
Реализуйте функцию 
```haskell
fib :: Int -> Integer
```
используя расширение языка
```
{-# LANGUAGE BangPatterns #-}
```

## Задание 3
Реализуйте инстанс `NFData` для `DList` и 
```haskell
data Tree a
  = Branch (Tree a) a (Tree a)
  | Leaf
```

Обратите внимание, что вам необходимо будет подключить пакет `deepseq`, для того чтобы использовать `NFData`.

## Задание 4
Вам дан `newtype`
```haskell
newtype State s a = State { runState :: s -> (a, s) }
```

Реализуйте для него инстансы `Functor`, `Applicative`, `Monad`, которые будут строго вычислять значение
возвращаемого значения (которое имеет тип `a`).

## Задание 5
Реализуйте быструю сортировку для [Vector](http://hackage.haskell.org/package/vector-0.12.0.2/docs/Data-Vector.html#t:Vector),
которая выбирает опорный элемент произвольным образом.
Функция должна принимать иммутабельный вектор.
На ваше усмотрение можете сделать ее чистой или монадической.
В реализации вы можете использовать любое из следующих:
* иммутабельный boxed [Vector](http://hackage.haskell.org/package/vector-0.12.0.2/docs/Data-Vector.html#t:Vector)
* иммутабельный unboxed [Vector](http://hackage.haskell.org/package/vector-0.12.0.2/docs/Data-Vector-Unboxed.html#t:Vector)
* мутабельный boxed [MVector](http://hackage.haskell.org/package/vector-0.12.0.2/docs/Data-Vector-Mutable.html#t:MVector)
* мутабельный unboxed [MVector](http://hackage.haskell.org/package/vector-0.12.0.2/docs/Data-Vector-Unboxed-Mutable.html#t:MVector)

Также желательно (но необязтаельно) использовать монаду [ST](http://hackage.haskell.org/package/base-4.12.0.0/docs/Control-Monad-ST.html#t:ST), 
а также [STRef](http://hackage.haskell.org/package/base-4.12.0.0/docs/Data-STRef.html#t:STRef).

Чтобы разобраться с API пакета `vector`, 
читайте Hackage и/или [этот туториал](https://wiki.haskell.org/Numeric_Haskell:_A_Vector_Tutorial).

## Задание 6
Проверьте, что сортировка из предыдущего задания является действительно быстрой и сортирует рандомно сгенерированный лист из
10^5 и 10^6 элементов типа `Int` за 1-2 секунды.
Используйте подход для измерения времени [отсюда](https://wiki.haskell.org/Timing_computations).
Убедитесь, что сортировка действительно вызывается: используйте функции [rnf](http://hackage.haskell.org/package/deepseq-1.4.4.0/docs/Control-DeepSeq.html#v:rnf) 
и [seq](http://hackage.haskell.org/package/base-4.12.0.0/docs/Prelude.html#v:seq) для этого.

## Задание 7
Реализуйте для дататайпа `Stream` из лекции
```haskell
data Step s a = Done
              | Skip    s
              | Yield a s

data Stream a = forall s . Stream (s -> Step s a) s
```
функцию 
```haskell
foldrS :: (a -> b -> b) -> b -> Stream a -> b
```
