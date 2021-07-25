(define tolerance 0.00001)
(define (show-and-tell n) 
  (newline)
  (display n)
  n)

(define (fixed-point f first-guess)
  (define (close-enough? v1 v2) (< (abs (- v1 v2)) tolerance))
  (define (try guess)
    (let ((next (f guess)))
    (if (close-enough? guess next)
      next
      (try (show-and-tell next)))))
  (try first-guess))

(define (x-raised x) (/ (log 1000) (log x)))

(fixed-point x-raised 10) ; this version takes 32 steps

(define (average x y)
  (/ (+ x y) 2))
(define (x-raised-averaged x) (average x (x-raised x)))

(fixed-point x-raised-averaged 10) ; average damping - this takes 9 steps