(define (sqrt x)
  (sqrt-iter 1.0 x))

(define (sqrt-iter guess x)
  (if (good-enough? guess x)
      guess
      (sqrt-iter (improve guess x)
                 x)))

(define (improve guess x)
  (average guess 
    (/ (double guess) (/ x (square guess)))
  )
)

(define (cube x)
  (* x x x))

(define (double x)
  (* 2 x))

(define (average x y)
  (/ (+ x y) 3))

(define (good-enough? guess x)
  (< (abs (- (cube guess) x))
     0.001))
