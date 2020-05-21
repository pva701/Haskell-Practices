# Practice for Lecture 8

Ок, давай так:
Задание 1: быстрое возведение в степень через bang patterns
Задание 2: NFData для data Tree = Node { label :: String, children :: [Tree] }
Задание 3: для newtype StrictNum a = StrictNum a сделать instance Num a => Num (StrictNum a) так чтобы результаты арифметических операций были всегда в головной нормальной форме. Сравнить время работы`sum` на больших размерах списка для`Int` и StrictNum Int.
Задание 4: реализовать дерево Фенвика с операциями получения суммы префикса [0..i] и добавления значения delta к произвольному индексу i.
Дерево следует хранить в newtype, оборачивающем тип Vector.
Задание 5: померить эффективность работы дерева Фенвика

## Задание 1

Реализуйте функцию 
```haskell
fastPow :: Integer -> Int -> Integer
```
используя расширение языка
```
{-# LANGUAGE BangPatterns #-}
```
(функция должна реализовывать быстрое возведение в степень)

## Задание 2
Реализуйте инстанс `NFData` для 
```haskell
data Tree = Node { label :: String, children :: [Tree] }
```

Обратите внимание, что вам необходимо будет подключить пакет `deepseq`, для того чтобы использовать `NFData`.

## Задание 3
Вам дан `newtype`
```haskell
newtype StrictNum a = StrictNum a
```

Реализуйте `instance Num a => Num (StrictNum a)` так чтобы результаты арифметических операций были всегда в головной нормальной форме.
Сравните время работы `sum` на больших размерах списка для `Int` и `StrictNum Int`.

## Задание 4

Реализуйте дерево Фенвика с операциями получения суммы на подотрезке и изменения значения произвольного индекса.
Дерево следует хранить в newtype, оборачивающем иммутабельный тип Vector (boxed/unboxed на ваш выбор).

На ваше усмотрение можете реализовать функции чистыми или монадическими.
В реализации вы можете использовать любое из следующих:
* иммутабельный boxed [Vector](http://hackage.haskell.org/package/vector-0.12.0.2/docs/Data-Vector.html#t:Vector)
* иммутабельный unboxed [Vector](http://hackage.haskell.org/package/vector-0.12.0.2/docs/Data-Vector-Unboxed.html#t:Vector)
* мутабельный boxed [MVector](http://hackage.haskell.org/package/vector-0.12.0.2/docs/Data-Vector-Mutable.html#t:MVector)
* мутабельный unboxed [MVector](http://hackage.haskell.org/package/vector-0.12.0.2/docs/Data-Vector-Unboxed-Mutable.html#t:MVector)
* [ST](http://hackage.haskell.org/package/base-4.12.0.0/docs/Control-Monad-ST.html#t:ST), [STRef](http://hackage.haskell.org/package/base-4.12.0.0/docs/Data-STRef.html#t:STRef).

Чтобы разобраться с API пакета `vector`, 
читайте Hackage и/или [этот туториал](https://wiki.haskell.org/Numeric_Haskell:_A_Vector_Tutorial).

## Задание 5
Проверьте, что дерево Фенвика из предыдущего задания работает действительно быстрой и на списках размера
10^5 и 10^6 элементов типа `Int`.
Убедитесь, что время работы операций увеличивается логарифмически, а не полиномиально.
Используйте подход для измерения времени [отсюда](https://wiki.haskell.org/Timing_computations).
Убедитесь, что сортировка действительно вызывается: используйте функции [rnf](http://hackage.haskell.org/package/deepseq-1.4.4.0/docs/Control-DeepSeq.html#v:rnf) 
и [seq](http://hackage.haskell.org/package/base-4.12.0.0/docs/Prelude.html#v:seq) для этого.

Опционально, попробуйте соптимизировать внутренний код дерева Фенвика, поэкспериментируйте с boxed/unboxed версиями вектора.
