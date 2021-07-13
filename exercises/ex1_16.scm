(define (fast_expt b n)
  (cond ((= n 0) 1)
  ((even? n) (square (fast_expt b (/ n 2))))
  (else (* b (fast_expt b (- n 1)))))
)

(define (slow_iter b n a)
  (if ( = n 0 )
    a
    ( slow_iter b ( - n 1 ) ( * a b ) )
  )
)

(define (fast_iter_expt b n a)
  (cond (( = n 0 ) a )
  ((even? n) ( fast_iter_expt ( * b b ) ( / n 2 ) a ))
  ( else ( fast_iter_expt b ( - n 1 ) ( * b a) ))
  )
)


(fast_iter_expt 2 0 1)
(fast_iter_expt 2 1 1)
(fast_iter_expt 2 2 1)
(fast_iter_expt 2 3 1)
(fast_iter_expt 2 4 1)
(fast_iter_expt 2 6 1)
(fast_iter_expt 2 7 1)
(fast_iter_expt 2 8 1)
(fast_iter_expt 2 10 1)

