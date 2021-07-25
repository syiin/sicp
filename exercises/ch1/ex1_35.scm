(define tolerance 0.00001)
(define (fixed-point f first-guess)
  (define (close-enough? v1 v2) (< (abs (- v1 v2)) tolerance))
  (define (try guess)
    (let ((next (f guess)))
    (if (close-enough? guess next)
      next
      (try next))))
  (try first-guess))

(define (ratio x) (+ 1 (/ 1 x)))
(fixed-point ratio 1) ;987/610 = 1.61803278689