(define (double a)
  (+ a a)
)

(define (halve a)
  (define (iter counter)
    (cond 
      ((= (double counter) a) counter)
      ((< (double counter) a) (+ counter 1))
      (else (iter (- counter 1)))
    )
  )
  (iter a)
)

(define (halve a)
  (/ a 2)
)

(define (fast_mult_iter a b sum terminator)
  (cond 
  (( = b terminator ) sum )
  ((even? b) (fast_mult_iter a (halve b) (double sum) terminator))
  (else (fast_mult_iter a (- b 1) (+ sum a) terminator))
  )
)

(define (fast_mult a b)
  (if (odd? b)
    (fast_mult_iter a b 0 0)
    (fast_mult_iter a b a 1)
  )
)

(fast_mult 4 2)
(fast_mult 4 3)
(fast_mult 4 4)
(fast_mult 4 5)
(fast_mult 4 6)
(fast_mult 4 7)
(fast_mult 4 8)

(fast_mult 3 9)
