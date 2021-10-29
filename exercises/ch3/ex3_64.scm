(define (average x y) (/ (+ x y) 2))

(define (sqrt-improve guess x)
  (average guess (/ x guess)))

(define (sqrt-stream x)
  (define guesses
    (cons-stream 1.0
                 (stream-map (lambda (guess)
                               (sqrt-improve guess x))
                             guesses)))
  guesses)

(define (stream-limit s tol)
  (define (iter guess sofar)
    (if (< (abs (- guess (stream-car sofar))) tol)
      guess
      (iter (stream-car sofar) (stream-cdr sofar))
    )
  )
  (iter (stream-car s) (stream-cdr s))
)

(define (sqrt x tolerance)
  (stream-limit (sqrt-stream x) tolerance))

(sqrt 2 0.000001)
