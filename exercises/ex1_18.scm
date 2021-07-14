(define (halve a)
  (/ a 2)
)

(define (double a)
  (+ a a)
)

(define (fast_iter_expt b n a)
  (cond (( = n 0 ) a )
  ((even? n) ( fast_iter_expt ( * b b ) ( / n 2 ) a ))
  ( else ( fast_iter_expt b ( - n 1 ) ( * b a) ))
  )
)

(define (fast_mult a b)
  (cond 
  (( = b 1 ) a )
  ((even? b) (double (fast_mult a (halve b))))
  (else ( + a (fast_mult a (- b 1) )))
  )
)


(define (fast_mult_iter a b sum)
  (cond 
  (( = b 0 ) sum )
  ((even? b) (fast_mult_iter (double a) (halve b) sum))
  (else (fast_mult_iter a (- b 1) (+ sum a)))
  )
)


(fast_mult_iter 4 2 0)
(fast_mult_iter 3 6 0)
(fast_mult_iter 6 8 0)
(fast_mult_iter 9 10 0)
(fast_mult_iter 12 12 0)