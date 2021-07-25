(define (timed-prime-test n)
  (newline)
  (display "CANDIDATE: ")
  (newline)
  (display n)
  (newline)
  (start-prime-test n (runtime)))


(define (start-prime-test n start-time)
  (if (fast-prime? n 1000)
    (report-prime (- (runtime) start-time))))

(define (report-prime elapsed-time)
  (display " ELAPSED TIME: ")
  (newline)
  (display elapsed-time)
  (newline)
  (newline))

(define (expmod base exp m)
  (cond ((= exp 0) 1)
        ((even? exp) (remainder (square (expmod base (/ exp 2) m)) m))
        (else (remainder (* base (expmod base (- exp 1) m)) m))))

(define (fermat-test n)
  (define (try-it a)
    (= (expmod a n n) a))
  (try-it (+ 1 (random (- n 1)))))

(define (fast-prime? n times)
  (cond ((= times 0) true)
  ((fermat-test n) (fast-prime? n (- times 1)))
  (else false)))

(define (next n)
  (if (= n 2) 
      3
      (+ n 2)))

(timed-prime-test 100003)
(timed-prime-test 100019)
(timed-prime-test 100043)
(timed-prime-test 1000000007)
(timed-prime-test 1000000009)
(timed-prime-test 1000000021)
(timed-prime-test 10000000019)
(timed-prime-test 10000000033)
(timed-prime-test 10000000061)
(timed-prime-test 100000000003)
(timed-prime-test 100000000019)
(timed-prime-test 100000000057)
(timed-prime-test 1000000000039)
(timed-prime-test 1000000000061)
(timed-prime-test 1000000000063)

; Digits that are half as long as roughly half as fast which corresponds with O(log n)

;CANDIDATE: 
;100003
; ELAPSED TIME: 
;1.9999999999999997e-2
;
;
;CANDIDATE: 
;100019
; ELAPSED TIME: 
;.03
;
;
;CANDIDATE: 
;100043
; ELAPSED TIME: 
;2.0000000000000004e-2
;
;
;CANDIDATE: 
;1000000007
; ELAPSED TIME: 
;3.9999999999999994e-2
;
;
;CANDIDATE: 
;1000000009
; ELAPSED TIME: 
;.03
;
;
;CANDIDATE: 
;1000000021
; ELAPSED TIME: 
;.04000000000000001
;
;
;CANDIDATE: 
;10000000019
; ELAPSED TIME:  
;.06
;
;
;CANDIDATE: 
;10000000033
; ELAPSED TIME: 
;.04999999999999999
;
;
;CANDIDATE: 
;10000000061
; ELAPSED TIME: 
;4.0000000000000036e-2
;
;
;CANDIDATE: 
;100000000003
; ELAPSED TIME: 
;.04999999999999999
;
;
;CANDIDATE: 
;100000000019
; ELAPSED TIME: 
;.04999999999999999
;
;
;CANDIDATE: 
;100000000057
; ELAPSED TIME: 
;.06
;
;
;CANDIDATE: 
;1000000000039
; ELAPSED TIME: 
;5.0000000000000044e-2
;
;
;CANDIDATE: 
;1000000000061
; ELAPSED TIME: 
;5.0000000000000044e-2
;
;
;CANDIDATE: 
;1000000000063
; ELAPSED TIME: 
;.06000000000000005


; This is me puzzling over whether the remainder calls matter 
; (expmod 4 3 3)
; (remainder (* 4 (expmod 4 2 3)) 3)
; (remainder (* 4 (remainder (square (expmod 4 1 3)) 3)) 3)
; (remainder (* 4 (remainder (square (remainder (* 4 (expmod 4 0 3)) 3)) 3)) 3)
; (remainder (* 4 (remainder (square (remainder (* 4 1) 3)) 3)) 3)
; (remainder (* 4 (remainder (square (remainder 4 3)) 3)) 3)
; (remainder (* 4 (remainder (square 1) 3)) 3)
; (remainder (* 4 (remainder 1 3)) 3)
; (remainder (* 4 1) 3)
; (remainder 4 3)
; 1

; Remember the note in the book
; The reduction steps in the cases where the exponent e is greater than 1 are based
; on the fact that, for any integers x, y, and m, we can find the remainder of x times y
; modulo m by computing separately the remainders of x modulo m and y modulo m,
; multiplying these, and then taking the remainder of the result modulo m. For instance,
; in the case where e is even, we compute the remainder of b^(e/2) modulo m, square this,
; and take the remainder modulo m. This technique is useful because it means we can
; perform our computation without ever having to deal with numbers much larger than
; m
