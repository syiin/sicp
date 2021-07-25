(define (fast_iter_expt b n a)
  (cond (( = n 0 ) a )
  ((even? n) ( fast_iter_expt ( * b b ) ( / n 2 ) a ))
  ( else ( fast_iter_expt b ( - n 1 ) ( * b a) ))
  )
)

(define (expmod base exp m)
  (cond ((= exp 0) 1)
        ((even? exp) (remainder (square (expmod base (/ exp 2) m)) m))
        (else (remainder (* base (expmod base (- exp 1) m)) m))))

(define (congruent n a)
  (= (expmod a n n) a))

(define (really-prime-test? n a)
  (cond ((= a 0) true)
  ((congruent n a) (really-prime-test? n (- a 1)))
  (else false)))

(define (really-really-prime-test? n)
  (really-prime-test? n (- n 1)))

(define (show-and-tell n)
  (newline)
  (display "CANDIDATE: ")
  (display n)
  (newline)
  (display (really-really-prime-test? n))
  (newline)
)

; sanity checking
(show-and-tell 8)
(show-and-tell 13)

; actual checking
(show-and-tell 561)
(show-and-tell 1105)
(show-and-tell 1729)
(show-and-tell 2465)
(show-and-tell 2821)
(show-and-tell 6601)