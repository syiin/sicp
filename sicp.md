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

## The Evaluation Rule
1. Evaluate the subexpressions of the combination
1. Apply the procedure that is the value of the left most subexpression (the operator) to the arguments that are the values of the other subexpressions (the operands)

## Compound Procedures
1. when a compound operation can be given a name and referred to as a unit\
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
