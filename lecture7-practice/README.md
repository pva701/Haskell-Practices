# Lecture 7 practice


## Task 0

Task 0 is not actually a task, but a demonstration of
why mixing `StateT` and `ExceptT` might be dangerous.

Function `f` is some generic code which manipulates with state
and optionally throws an exception.

Functions `f1` and `f2` are conceret instantiations of generic
function `f`.

Conventional interpretation of `f` is that it updates state with
value `5`, throws an error and immediately suppresses it.

However, for `f2` it turns out that state update wasn't handled.
That's it, any state update happened inside left argument of `catch`
would be ignored.

Functions `f1` and `f2` represent different semantics. Former
is conventional impreative interpretation, while latter is something
lookalike to transactional approach (changes ignored in case of failure).

Normally `f1` is expected and/or considered intuitive and bottom line
is that one should be very careful when executing her transformer
stack.

One more think to mention, we could implement `fIO`:

```
instance MonadError String IO where
  -- .. some code, basically throw IOException
  --   using throwIO and ~same for catch ...

fIO :: IO ((), Int)
fIO = runStateT f 0

-- ghci> fIO
-- 0

```

And it would work similarly to `f2` (again, counter-intuitive).
This is a particular demonstration of why `StateT s IO` is a bad design.

## Task 1

A demonstration of how to use `ReaderT IO` in order to do some seemingly
stateful computations.

The idea is to modify context and pass control to subsequent recursive
calls in order to maintain "state".

We model a very simple stack interpreter. It's state is an integer stack.
At each moment we read a command from CLI and apply it to stack.

Your task is to implement `handleCommand` (when rest of application is given).

## Task 2

Task is to demonstrate how to use `ReaderT r (ExceptT e (State s))`.

You're given a task to implement interpretation of simple templating AST.

This AST contains instruction to assign variable a value.
Value is a concatenation of list of elements, where each element is either
reference to one of defined variables or a literal.

Next, AST contains an instruction to set a variable to some value only within
some context. Note, that is some variable is given within context, all
assignments would affect state, but all reads will use value from context.
This is an exteremely broken design, but suffices for purpose of
reader / state demonstration.

In this task you need to implement `runTemplateDo` function (rest of file
is implemented already).


