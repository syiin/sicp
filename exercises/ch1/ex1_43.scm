(define (compose f g) (lambda (x) (f (g x))))
(define (square x) (* x x))
(define (cube x) (* x x x))

(define (repeated f n)
  (define (iter counter res)
    (if (= counter n)
      res
      (iter (+ counter 1) (compose f res))
    )
  )
  (iter 1 f)
)

((repeated square 2) 5)
((repeated cube 2) 2)