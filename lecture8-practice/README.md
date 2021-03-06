# Practice for Lecture 8

В заданиях, где требуется померить производительность, используйте подход для измерения времени [отсюда](https://wiki.haskell.org/Timing_computations)
Убедитесь, что функции действительно выполняются: используйте функции [rnf](http://hackage.haskell.org/package/deepseq-1.4.4.0/docs/Control-DeepSeq.html#v:rnf)
и [seq](http://hackage.haskell.org/package/base-4.12.0.0/docs/Prelude.html#v:seq) для этого.

В качестве альтернативы вы можете использовать пакет
[criterion](http://www.serpentine.com/criterion/).

## Задание 1

Реализуйте функцию
```haskell
fastPow :: Integer -> Int -> Integer
```
используя расширение языка
```
{-# LANGUAGE BangPatterns #-}
```
(функция должна реализовывать бинарное возведение в степень).

Реализуйте также версию без расширения, сравните производительность
двух функций.

## Задание 2
Реализуйте вручную инстанс `NFData` для
```haskell
data Tree = Node { label :: String, children :: [Tree] }
```

Обратите внимание, что вам необходимо будет подключить пакет
`deepseq`, для того чтобы использовать `NFData`.

## Задание 3
Вам дан `newtype`
```haskell
newtype StrictNum a = StrictNum a
```

Реализуйте `instance (_) => Num (StrictNum a)` так чтобы результаты
арифметических операций были всегда в головной нормальной
форме. Заметьте, что необходимые constraint'ы (`(_) =>`) опущены, их
вам надо заполнить самостоятельно.  Сравните время работы `sum` на
больших размерах списка для `Int` и `StrictNum Int`.

Результаты могут оказаться неожиданны, будьте готовы их объяснить.

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

Опционально, попробуйте соптимизировать внутренний код дерева Фенвика, поэкспериментируйте с boxed/unboxed версиями вектора.
