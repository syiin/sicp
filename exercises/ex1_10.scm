(define (A x y)
  (cond ((= y 0) 0)
    ((= x 0) (* 2 y))
    ((= y 1) 2)
    (else (A (- x 1) (A x (- y 1))))
  )
)

; f(n) -> 2n
(define (f n) (A 0 n))

; g(n) -> 2^n
(define (g n) (A 1 n))

; (2 3)
; (1 (A 2 2))
; (A 1 (A 2 2))
; (A 1 (A 0 (A 2 1)))
; (A 1 (A 0 2))
; (A 1 4)
; (A 0 (A 1 3))
; (A 0 (A 0 (A 1 2)))
; (A 0 (A 0 (A 0 (A 1 1))))
; (A 0 (A 0 (A 0 2)))
; (A 0 (A 0 4))
; (A 0 8)
; 16

; (2, 2)
; (A 1 (A 2 1))
; (A 1 2)
; (A 0 A(1 1))
; (A 0 2)
; 4

; h(n) -> 2^2^2...n OR exp(sum(log(2), n_times))
(define (h n) (A 2 n))
(h 0)
(h 1)
(h 2)
(h 3)
(h 4)