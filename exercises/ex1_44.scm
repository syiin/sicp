(define dx 0.00001)
(define (compose f g) (lambda (x) (f (g x))))
(define (repeated f n)
  (define (iter counter res)
    (if (= counter n)
      res
      (iter (+ counter 1) (compose f res))))
  (iter 1 f))

(define (smooth f)
  (lambda (x) 
    (/
      (+ 
        (+ (f (- x dx)) (f x))
      (f (+ x dx)))
    3)
  )
)

(define (n-smoothed f n)
  ((repeated smooth n) f)
)

(define (square x) (* x x))

((smooth square) 3)

((smooth (smooth (smooth square))) 3)

((n-smoothed square 3) 3)