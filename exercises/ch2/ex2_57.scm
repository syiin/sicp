(define (=number? exp num) (and (number? exp) (= exp num)))
(define (variable? x) (symbol? x))
(define (same-variable? v1 v2)
  (and (variable? v1) (variable? v2) (eq? v1 v2)))
(define (sum? x) (and (pair? x) (eq? (car x) '+)))
(define (product? x) (and (pair? x) (eq? (car x) '*)))
(define (multiplier p) (cadr p))
(define (multiplicand p) (caddr p))
(define (accumulate op initial sequence)
  (if (null? sequence)
      initial
      (op (car sequence) (accumulate op initial (cdr sequence)))))

; SUMMING
(define (addend s) (cadr s))
(define (augend s) 
  (accumulate make-sum 0 (cddr s)))
(define (make-sum a1 a2)
  (cond ((=number? a1 0) a2)
        ((=number? a2 0) a1)
        ((and (number? a1) (number? a2))
        (+ a1 a2))
        (else (list '+ a1 a2))))
; PRODUCTS
(define (multiplier p) (cadr p))
(define (multiplicand p) 
  (accumulate make-product 1 (cddr p)))

(define (make-product m1 m2)
  (cond ((or (=number? m1 0) (=number? m2 0)) 0)
        ((=number? m1 1) m2)
        ((=number? m2 1) m1)
        ((and (number? m1) (number? m2)) (* m1 m2))
        (else (list '* m1 m2))))

(define (deriv exp var)
  (cond ((number? exp) 0)
         ((variable? exp) (if (same-variable? exp var) 1 0))
         ((sum? exp) (make-sum 
                        (deriv (addend exp) var)
                        (deriv (augend exp) var)))
         ((product? exp)
          (make-sum
            (make-product (multiplier exp)
                          (deriv (multiplicand exp) var))
            (make-product (deriv (multiplier exp) var)
                          (multiplicand exp))))
         (else
          (error "unknown expression type: DERIV" exp))))

(define expr '(* (* x y) (+ x 3)))
(deriv expr 'x) ;Value: (+ (* x y) (* y (+ x 3)))

; Remember the accumulator pattern - we got really confused trying to recreate the accumulator pattern 
; for the specific augend case. They weren't very elegant because we didn't use the initial property and 
; forgot that make-sum will simplify the (+ x 0) case. Something using accumulator + make-product and 
; trusting their individual internal roles.
; It can be hard to think along the level of abstraction you should and you will waste a lot of time and
; energy if you don't.
; You also have to remember you can't just think of functions as a series of steps because it makes recursive
; calls from one function into another difficult to brain. They are "experts" of a certain domain