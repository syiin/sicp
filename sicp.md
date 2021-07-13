# Structure and Interpretation of Computer Programs 
1. https://mitpress.mit.edu/sites/default/files/sicp/full-text/book/book-Z-H-1.html

# Chapter 1

1. There are 3 key components
  1. primive expressions, simplest entities a language is concrned with
  1. means of combination, when compound elements are made from smaller ones
  1. means of abstraction, when compound elements can be named and manipulated as single units

Useful definitions
1. _Expression_ - just a thing you type into the computer `(+ 137 349)`. This is a _compound expression_.
1. _Procedure_ - `+`, `-`, `square`...etc
1. _Combinations_ - list of expressions within parantheses, just like `(+ 137 349)` or `(+ (* 3 5) (- 10 6))`
1. _Name_ - a variable whose value is the object `(define pi 3.14159)`
1. _Compound procedures_ - pretty much functions `(define (square x) (* x x))`
1. _Predicates_ - an expression or procedure evaluated to true or false `(> x 0)`
1. _Formal parameters_ - the actual parameters given to a procedure  ie. the `x` and `y` in `(define multiply x y)`

Notice functions are NOT procedures: f(x) -> 2x + 6 and g(x) -> 2(x+3), these are the SAME functions but DIFFERENT procedures

## The Evaluation Rule
1. Evaluate the subexpressions of the combination
1. Apply the procedure that is the value of the left most subexpression (the operator) to the arguments that are the values of the other subexpressions (the operands)

## Compound Procedures
1. when a compound operation can be given a name and referred to as a unit
1. can also be nested
```
(define (sum-of-squares x y)
  (+ (square x) (square y)))

(sum-of-squares 3 4)
25
```
1. notice you cannot tell looking at the definition of `sum-of-squares` whether `square` is built into the interpreter or defined by the user as a compound procedure.

## Applicative VS Normal Order

1. In applicative order, the arguments of the procedure are evaluated before the body of the procedure
1. In normal order, the body of the procedure is evaluated before the arguments

Given:
```
(define (f a)
  (sum-of-squares (+ a 1) (* a 2)))
```

### Applicative:
```
(f 5)
(sum-of-squares (+ a 1) (* a 2))
(sum-of-squares (+ 5 1) (* 5 2))
(+ (square 6) (square 10))
(+ (* 6 6) (* 10 10))
(+ 36 100)
136
```

### Normal
```
(f 5)
(sum-of-squares (+ 5 1) (* 5 2))
(+    (square (+ 5 1))      (square (* 5 2))  )
(+    (* (+ 5 1) (+ 5 1))   (* (* 5 2) (* 5 2)))
(+         (* 6 6)             (* 10 10))
(+           36                   100)
                    136
```

## Conditional Expressions & Predicates
```
(define (abs x)
  (cond ((> x 0) x)
        ((= x 0) 0)
        ((< x 0) (- x))))
```

## Newtons Method

A method for approximating square roots by taking a guess, dividing the subject by the guess and the averaging the guess with the subject or previous guess:

Guess    Quotient               Average
1	        (2/1) = 2	            ((2 + 1)/2) = 1.5
1.5	      (2/1.5) = 1.3333	    ((1.3333 + 1.5)/2) = 1.4167
1.4167	  (2/1.4167) = 1.4118	  ((1.4167 + 1.4118)/2) = 1.4142


This is an implementation that gets loops and conditionals just using recursion
```
(define (sqrt x)
  (sqrt-iter 1.0 x))

(define (sqrt-iter guess x)
  (if (good-enough? guess x)
      guess
      (sqrt-iter (improve guess x)
                 x)))

(define (improve guess x)
  (average guess (/ x guess)))

(define (average x y)
  (/ (+ x y) 2))

(define (good-enough? guess x)
  (< (abs (- (square guess) x)) 0.001))
```



# Procedures as Black-Box Abstractions
Procedures allow us to not care _how_ something is done, we can treat them as black boxes that solve
a given problem.

## Local Names
1. The meaning of a procedure should be independent of the parameter names used by its author 
  ie. the below do the same thing
  ```
  (define (square x) (* x x))
  (define (square y) (* y y))
  ```
1. The consequences of this:
  1. The parameter names of a procedure must be local to the body of the procedure. In other words, scope. 
     Variables in procedures must exist in its own environment to maintain the blackbox level of abstraction
  1. This also means that the _formal parameters_ of a procedure are special - it is called a _bound variable_ and the procedure
     definition is the same as long as the bound variable is consistently renamed throughout its definition. eg. in the above example, it doesn't matter if `x` is renamed to `y`
  1. So a procedure _binds_ its formal procedures
  1. If the variable is not bound, it is _free_ like inside `good_enough?`, `square` or `abs` are free. 
     Notice what the procedure does is not independent of the names of the free variables. 
     ie. if you change `abs` to `cos`, the procedure changes
  1. Another is that we have to allow block internal definitions (ie. definitions that are local to a procedure)
    ```
    (define (sqrt x)
      (define (good-enough? guess x)
        (< (abs (- (square guess) x)) 0.001))
      (define (improve guess x)
        (average guess (/ x guess)))
      (define (sqrt-iter guess x)
        (if (good-enough? guess x)
            guess
            (sqrt-iter (improve guess x) x)))
      (sqrt-iter 1.0 x)
    )
    ```
  1. Since `x` is bound in the definition of `sqrt` and the other procedures are only relevant inside `sqrt`, we don't need to pass `x` from procedure to procedure. This is called _lexical scoping_
  ```
  (define (sqrt x)
    (define (good-enough? guess)
      (< (abs (- (square guess) x)) 0.001))
    (define (improve guess)
      (average guess (/ x guess)))
    (define (sqrt-iter guess)
      (if (good-enough? guess)
          guess
          (sqrt-iter (improve guess))))
    (sqrt-iter 1.0)
  )
  ```

### Ex.1.16
- Because the counter does not decrement uniformly (ie. that's what makes this procedure logarithmic in steps), you cannot work through it with a table stepping through one step at a time. Each case has to be considered with its own branch. 

ie. The below kind of thinking got us nowhere even though it looked vaguely in the right direction

```
n     b        a
_     _        _
1     2^2      2
2     2^4      4
3     2^8      8
4     2^16     16
```

You have to think of each case separately with its own bifurcations in the tree, like this case for `(fast_iter_expt 2 6 1)`
```

(define (fast_iter_expt b n a)
  (cond (( = n 0 ) a )
  ((even? n) ( fast_iter_expt ( * b b ) ( / n 2 ) a ))
  ( else ( fast_iter_expt b ( - n 1 ) ( * b a) ))
  )
)


n     b        a
_     _        _
6     2^0      1
3     2^2      1
2     2^2      2^2
1     2^4      2^6
```

### Ex.1.19

Why does running the transformation twice halve the number of steps instead of just skipping 2 steps?

ie.
a = b.q + a.q + a.p
b = a.q + b.p

so, 
a' = (a.q + b.p).q + (b.q + a.q + a.p).q + (b.q + a.q + a.p).p = (2pq + q^2).b + (2q^2 + 2pq + p^2).a
b' = (b.q + a.q + a.p).q + (a.q + b.p).p = (p^2 + q^2).b + (2qp + q^2).a 

therefore,

q' = 2qp + q^2

what about p'?
p' = p^2 + q^2

notice from a',
(2q^2 + 2pq + p^2).a = (p' + q').a
2q^2 + 2pq + p^2 = (p' + q')
                 = (2qp + q^2 + p^2 + q^2)
                 = 2q^2 + 2pq + p^2

Consider that:
  1. a transformation run twice IS a transformation squared (remember our linear algebra)
      Q * D * D * D * D * D * D * D * Q^-1 = Q * (D * D) * (D * D) * (D * D) * Q^-1
  1. also, like `fast_expt` case in Ex1.16, conducting the operation once results in one step but squaring it skips more steps.