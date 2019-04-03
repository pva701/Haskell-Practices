# Practice for Lecture 10

В данном практике будут использованы линзы и функции из этого 
[модуля](http://hackage.haskell.org/package/microlens-0.4.10/docs/Lens-Micro.html)
и функция `view` из этого [модуля](http://hackage.haskell.org/package/microlens-0.4.10/docs/Lens-Micro-Extras.html#v:view).

## Задание 1

Вам даны следующиee датайпы:
```haskell
data Point = Point { 
    _x :: Int
  , _y :: Int
  }
  
data Atom = Atom { 
    _element :: String
  , _point   :: Point
  }
```

Определите для них линзы с помощью TH функции `makeLenses` [отсюда](http://hackage.haskell.org/package/microlens-th-0.4.2.3/docs/Lens-Micro-TH.html#v:makeLenses). 
Для этого вам потребуется подключить пакеты `microlens` и `microlens-th`. А также расширение языка `{-# LANGUAGE TemplateHaskell #-}`.

Создайте 
```haskell
atom = Atom "C" (Point 3 4)
```

Проверьте, что значение `x` координаты равно 3, а `y` 4. 
Сделайте это двумя способами: используя `view` и `^.`.

Затем создайте atom у которого `x` координата увеличена на 1. 
Сделайте это двумя способами: используйте функцию `over` и `%~` вместе с `&`.

Затем определите `atomX :: Lens' Atom Int` и `atomY :: Lens' Atom Int`.

Затем определите функцию
```haskell
reflect :: Atom -> Atom
```
которая отражает позицию атома относительно точки `(0, 0)`. Используйте `over` или `%~` вместе с `&`.

Затем определите функцию
```haskell
move :: Point -> Atom -> Atom
```
которая перемещает атом на заданный вектор, используя `over` или `%~` вместе с `&`.

## Задание 2
В этом задании вам предлагается разобраться с `Traversal'`.

`Traversal'` служит сеттером и геттером для произвольного количества значений.

`Traversal'` можно рассматривать как следующий наивный datatype:
```haskell
data Traversal' a b = Traversal'
    { toListOf :: a -> [b]
    , over     :: (b -> b) -> (a -> a)
    }
```
Который хранит в себе функцию, которая превращает объект типа `a` в лист типа `b`, а также функцию, 
которая принимает правило (функцию), по которому менять каждый элемент типа `b` и возвращает (правило) функцию, 
которая превращает объект типа `a` в объект такого же типа.

На самом же деле, `Traversal'` имеет [тип](http://hackage.haskell.org/package/microlens-0.4.10/docs/Lens-Micro.html#t:Traversal-39-)
```haskell
type Traversal' a b = forall f . Applicative f => (b -> f b) -> (a -> f a)

type Lens'      a b = forall f . Functor     f => (b -> f b) -> (a -> f a)
```

**Поэтому то, что является линзой является также траверcаблом.**

То есть любой траверсабл может передаваться в любую функцию, где ожидается линза.

Вам дан следующий datatype
```haskell
data Molecule = Molecule 
  { _atoms :: [Atom] 
  }
```

Реализуйте самостоятельно
```haskell
atomsTs :: Traversal' Molecule Atom
```

## Задание 3
В данном задании вам предстоит еще немножко больше разобраться с `Traversal'`.

До этого мы встречали "другой" `traverse` [отсюда](http://hackage.haskell.org/package/base-4.12.0.0/docs/Data-Traversable.html#v:traverse),
который имеет тип
```haskell
traverse :: (Applicative f, Traversable t) => (a -> f b) -> t a -> f (t b)
```
Если мы посмотрим внимательно, он имеет тип
```haskell
traverse :: Traversable t => Traversal' (t a) a
```

То есть `traverse` может передаваться в любую функцию, где ожидается линза, например в `over` или `set`.

Вам дан следующий datatype
```haskell
data Pair a = Pair a a 
```
Определите для него инстанс `Traversable` через `traverse`.

Затем напишите функцию
```haskell
incPair :: Num a => Pair a -> Pair a
```
которая увеличивает каждый элемент пары на 1, используя `over` и `traverse`.

## Задание 4

Используя функцию `lens` из слайдов
```haskell
lens :: (s -> a) -> (s -> a -> s) -> Lens' s a
lens get set = \f s -> set s <$> f (get s)
```
определите линзу `atoms :: Lens Molecule [Atom]`.

Далее, реализуйте следующие `Traversable'` для datatype `Molecule`, используя созданную линзу.

```haskell
atomsTs :: Traversal' Molecule Atom
atomsPt :: Traversal' Molecule Point
atomsX  :: Traversal' Molecule Int
atomsY  :: Traversal' Molecule Int
```
как композицию линз и траверсаблов.

Затем реализуйте функцию
```haskell
moveAtoms :: Point -> Molecule -> Molecule
```
которая сдвигает все атомы переданной `Molecule` на переданный вектор, используя композицию линз и траверсаблов и `over` (или `%~`).

