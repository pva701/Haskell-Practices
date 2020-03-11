# Lecture 5 practice

There are three tasks to be implemented in `Parser.hs`.

Use `ghci Parser.hs` to type check and load file into ghci.

For reference with parser combinator idea,
one is adviced to check [this presentation](http://slides.com/fp-ctd/lecture-65).

## Task one

Task is simple: rewrite `<*>` of `Parser` with `>>=` from `Monad Maybe`.

## Task two

Implement `Alternative Parser` instance.

Implement int list grammar (described in file as Grammar 2).

Use non-empty int list grammar (Grammar 1 in file) as reference.

## Task three

Implement `Monad Parser` instance.

Implement list of strings grammar (described in file as Grammar 3).
