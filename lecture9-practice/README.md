# Lecture 9 practice

Let's practice on concurrency, exception handling and parallelism!

## Task one

Package `async` defines following helper:

```
concurrently :: IO a -> IO b -> IO (a, b)
```

It executes two actions in parallel and returns a result.

Implement `concurrently` with `forkIO` and `MVar`.
Mind exceptions, you shall not produce a deadlock.

Any exception caught must be re-thrown and other computation cancelled.


## Task two

Use `bracket` to open file, read first 5 bytes of data and close it.

## Task three

Take two sorting algorithms. E.g. `Data.List.sort` and custom `mergeSort` from HW1.

Or custom `mergeSort` and custom `quickSort`.

Then let's make a competition.
We run 10000 rounds, in which we generate a random array of length `5, 10, 50, 100, 1000`
with int elements from `0` to `30`.

In each round we execute `race` giving both algorithms as parameters and
we count who won the race over all such repetitions.

## Task four

Implement parallel Monte-Carlo integral calculation.

```
integrate
  :: RandomGen g
  => g -- ^ Random generator
  -> Int -- ^ Number of random points to generate
  -> Double -- ^ Lower bound
  -> Double -- ^ Upper bound
  -> (Double -> Double) -- ^ Function to integrate
  -> Double
```

Using Monte-Carlo method means that we generate `N` random points,
calculate function value at each point and then calculate mean value
multiplied by `b - a` for `b` and `a` being upper and lower bounds respectively.

See https://goo.gl/DkCm6Y.

## Task five

Account name is represented by `String`.
Account balance is represented by `Int`.

Ledger is a map from account name to balance, supporting following operations:

* Get current balance of account `A`
  * If there is no key `A` in the map, return `0`
* Transfer `c` coins from account `A` to account `B`
  * If `A` has balance of less than `c` coins, throw an exception

Implement a ledger as newtype over `Map` from http://hackage.haskell.org/package/stm-containers-1.1.0.2/docs/StmContainers-Map.html.

Try to launch 100000 concurrent operations, working on:

* Same keys
* Different keys

And roughly compare performance via output of RTS (see slides).
