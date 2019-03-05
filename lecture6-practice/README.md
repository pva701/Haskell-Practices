# Practice for Lecture 6

## Задание 1
Напишите программу, которая будет спрашивать имя пользователя, а затем приветствовать его по имени. Причем, если пользователь не ввёл имя, программа должна спросить его повторно, и продолжать спрашивать, до тех пор, пока пользователь не представится.

Используйте [getLine](http://hackage.haskell.org/package/base-4.12.0.0/docs/Prelude.html#v:getLine) для считывания строки с консоли и [putStrLn](http://hackage.haskell.org/package/base-4.12.0.0/docs/Prelude.html#v:putStrLn) (и похожие) для печати.
```
What is your name?
Name: 
What is your name?
Name: 
What is your name?
Name: Valera
Hi, Valera!
```

## Задание 2
В этом задании ваша программа ожидает три аргумента командной строки: путь к директории и две строки, а затем переименовать все файлы в указанной директории, в имени которых встречается первая строка, заменив все вхождения первой строки на вторую, выдавая при этом соответствующие сообщения.

Используйте [getDirectoryContents](https://hackage.haskell.org/package/directory-1.2.3.1/docs/System-Directory.html#v:getDirectoryContents), [renameFile](https://hackage.haskell.org/package/directory-1.2.3.1/docs/System-Directory.html#v:renameFile) и другие функции оттуда же.

Для считывания аргументов командной строкий используйте [getArgs](http://hackage.haskell.org/package/base-4.12.0.0/docs/System-Environment.html#v:getArgs).

Пример работы вашей программы
```
$ ls ./test
anime.avi  file1.txt  riri.txt   ririri.txt
$ ./your-program ./test ri riri
Renaming riri.txt to riririri.txt
Renaming ririri.txt to riririririri.txt
Finished
$ ls ./test
anime.avi  file1.txt  riririri.txt   riririririri.txt
```
Если же данные невалидны: путь не существует или не хватает введеных данных, выведите сообщение об ошибке.

## Задание 3
Реализуйте [сортировку выбором](https://neerc.ifmo.ru/wiki/index.php?title=%D0%A1%D0%BE%D1%80%D1%82%D0%B8%D1%80%D0%BE%D0%B2%D0%BA%D0%B0_%D0%B2%D1%8B%D0%B1%D0%BE%D1%80%D0%BE%D0%BC).

В единственной входной строке вашей программе подается массив челых чисел.
Во второй строке выведите отсортированный по неубыванию массив.
```
3 2 1 0 1 2 3
0 1 1 2 2 3 3
```

В реализации используйте `IOArray` из `Data.Array.IO` и `IORef` из `Data.IORef`

## Задание 4
Реализуйте собственную сохранялку интересных страниц.
Она должна поддерживать четыре операции:
```
add link-name link
```
Сохранить ссылку `link` по короткому имени `link-name`.
Если данное имя уже есть, предупредите пользователя и спросите подтверждения, необходимо ли его заменить.

```
remove link-name
```
Удалить сохраненную ссылку с коротким именем `link-name`.

```
download link-name/link
```
Скачать страницу по короткому имени `link-name` или по полной ссылке `link`.

```
list
```
Вывести все сохраненные страницы.

Операции должны считываться из консоли и хранилище ващих интересных страниц должно быть перманентно, то есть при перезапуске программы данные не должны теряться.

```
./bookmarks-saver
> add lecture6-practice https://github.com/pva701/Haskell-Practices/edit/master/lecture6-practice/README.md
Successfully added
> add neerc http://neerc.ifmo.ru/information/index.html
Successfully added
> download neerc
Downloaded page saved to neerc-downloaded
> download http://neerc.ifmo.ru/lgd.pdf
Downloaded page saved to dwmddgsyccvlucvyyslm
> list
lecture6-practice: https://github.com/pva701/Haskell-Practices/edit/master/lecture6-practice/README.md
neerc: http://neerc.ifmo.ru/information/index.html
> ^CInterrupted.
```
Следующий запуск
```
./bookmarks-saver
> remove neerc
neerc removed
> download neerc
Couldn't download neerc
> download http://fdlfdk.re/fdf
Couldn't download http://fdlfdk.re/fdf
```

## Задание 5*
Реализуйте функцию (для версии IO, которая была приведена на лекции)
```haskell
unsafeInterleaveIO :: IO a -> IO a
``` 
которая делает переданное вычисление "отложенным".
То есть вычисление результата переданной функции будет отложено до тех пор, пока оно реально не потребуется (не потребуется вычислить его в нормальную форму).

С помощью этой функции реализованы все ленивые функции, которые работают с файлами.
