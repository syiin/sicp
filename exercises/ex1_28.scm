(define (expmod base exp m)
  (cond ((= exp 0) 1)
        ((even? exp) (remainder (square (expmod base (/ exp 2) m)) m))
        (else (remainder (* base (expmod base (- exp 1) m)) m))))


(define (expmod base exp m)
  (cond ((= exp 0) 1)
        ((even? exp) (remainder (nontrivial (square (expmod base (/ exp 2) m)) exp m) m))
        (else (remainder (nontrivial (* base (expmod base (- exp 1) m)) exp m) m) )))

(define (nontrivial a exp m)
  (cond ((= a 1) a)
        ((= a exp) a)
        ((= (remainder a m) 1) 0)
        (else a))) 

(define (fermat-test n)
  (define (try-it a)
    (< (expmod a (- n 1) n) 2))
  (try-it (+ 1 (random (- n 1)))))

(define (fast-prime? n times)
  (cond ((= times 0) true)
  ((fermat-test n) (fast-prime? n (- times 1)))
  (else false)))

(fast-prime? 9 10)
(fast-prime? 12 10)
(fast-prime? 1000000000062 10)

(fast-prime? 3 10)
(fast-prime? 11 10)
(fast-prime? 1000000000063 10)

(fast-prime? 561 10)
(fast-prime? 1105 10)
(fast-prime? 1729 10)
(fast-prime? 2465 10)
(fast-prime? 2821 10)
(fast-prime? 6601 10)



;pg 102

; This helps clear it up https://stackoverflow.com/questions/3733384/confused-on-miller-rabin

; I believe that the misunderstanding comes from the definition the book gives about the nontrivial root:
; "a “nontrivial square root of 1 modulo n” , that is, a number not equal to 1 or n - 1 whose square is equal to 1 modulo n"
; Where I believe it should say: "whose square is congruent to 1 modulo n"

