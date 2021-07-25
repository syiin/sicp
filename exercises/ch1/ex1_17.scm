(define (double a)
  (+ a a)
)

; not used, just to tinker with the idea
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

;I made this and then realised after looking at 1.18 that this isn't what the question intended
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
(fast_mult 2 4)
(fast_mult 4 3)
(fast_mult 3 4)
(fast_mult 4 4)
(fast_mult 4 5)
(fast_mult 4 6)
(fast_mult 4 7)
(fast_mult 4 8)
(fast_mult 3 9)

;eventually made this
(define (fast_mult_recur a b)
  (cond 
  (( = b 1 ) a )
  ((even? b) (double (fast_mult_recur a (halve b))))
  (else ( + a (fast_mult_recur a (- b 1) )))
  )
)

(fast_mult_recur 4 2)
(fast_mult_recur 4 3)
(fast_mult_recur 4 4)
(fast_mult_recur 4 5)
(fast_mult_recur 4 6)
(fast_mult_recur 4 7)
(fast_mult_recur 4 8)
(fast_mult_recur 3 9)
