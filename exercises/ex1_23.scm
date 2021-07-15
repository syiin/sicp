(define (timed-prime-test n)
  (newline)
  (display "CANDIDATE: ")
  (newline)
  (display n)
  (start-prime-test n (runtime)))

(define (start-prime-test n start-time)
  (if (smallest-divisor n)
    (report-prime (- (runtime) start-time))))

(define (report-prime elapsed-time)
  (display " ELAPSED TIME: ")
  (newline)
  (display elapsed-time)
  (newline)
  (newline))

(define (smallest-divisor n) (find-divisor n 2))
(define (find-divisor n test-divisor)
  (cond ((> (square test-divisor) n) n)
        ((divides? test-divisor n) test-divisor)
        (else (find-divisor n (next test-divisor)))))
(define (divides? a b) (= (remainder b a) 0))

(define (next n)
  (if (= n 2) 
      3
      (+ n 2)))

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

; The difference is closer to half the time at smaller numbers. 
; However, at the larger numbers, it becomes closer to 2/3 of the before time.
; This is because of the remainder operation requiring more time to do the division computation

; AFTER

; CANDIDATE: 
; 1000000007 ELAPSED TIME: 
; .01
; 
; CANDIDATE: 
; 1000000009 ELAPSED TIME: 
; 9.999999999999998e-3
; 
; CANDIDATE: 
; 1000000021 ELAPSED TIME: 
; 2.0000000000000004e-2
; 
; CANDIDATE: 
; 10000000019 ELAPSED TIME: 
; 3.9999999999999994e-2
; 
; CANDIDATE: 
; 10000000033 ELAPSED TIME: 
; .04000000000000001
; 
; CANDIDATE: 
; 10000000061 ELAPSED TIME: 
; .04999999999999999
; 
; CANDIDATE: 
; 100000000003 ELAPSED TIME: 
; .12
; 
; CANDIDATE: 
; 100000000019 ELAPSED TIME: 
; .12
; 
; CANDIDATE: 
; 100000000057 ELAPSED TIME: 
; .13999999999999996
; 
; CANDIDATE: 
; 1000000000039 ELAPSED TIME: 
; .41000000000000003
; 
; CANDIDATE: 
; 1000000000061 ELAPSED TIME: 
; .41999999999999993
; 
; CANDIDATE: 
; 1000000000063 ELAPSED TIME: 
; .40000000000000013

;BEFORE

; CANDIDATE: 
; 1000000007 ELAPSED TIME: 
; 1.9999999999999997e-2
; 
; CANDIDATE: 
; 1000000009 ELAPSED TIME: 
; 2.0000000000000004e-2
; 
; CANDIDATE: 
; 1000000021 ELAPSED TIME: 
; 2.0000000000000004e-2
; 
; CANDIDATE: 
; 10000000019 ELAPSED TIME: 
; .07
; 
; CANDIDATE: 
; 10000000033 ELAPSED TIME: 
; .06
; 
; CANDIDATE: 
; 10000000061 ELAPSED TIME: 
; .07
; 
; CANDIDATE: 
; 100000000003 ELAPSED TIME: 
; .20999999999999996
; 
; CANDIDATE: 
; 100000000019 ELAPSED TIME: 
; .20999999999999996
; 
; CANDIDATE: 
; 100000000057 ELAPSED TIME: 
; .21000000000000008
; 
; CANDIDATE: 
; 1000000000039 ELAPSED TIME: 
; .65
; 
; CANDIDATE: 
; 1000000000061 ELAPSED TIME: 
; .6500000000000001
; 
; CANDIDATE: 
; 1000000000063 ELAPSED TIME: 
; .6299999999999999
