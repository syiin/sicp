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

;Because the counter does not decrement uniformly (ie. that's what makes this procedure logarithmic in steps), you cannot work through it with a table stepping through one step at a time. 
;Each case has to be considered with its own branch. 
;ie. The below kind of thinking got us nowhere even though it looked vaguely in the right direction
;
;```
;n     b        a
;_     _        _
;1     2^2      2
;2     2^4      4
;3     2^8      8
;4     2^16     16
;```