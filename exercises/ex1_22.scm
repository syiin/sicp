(define (timed-prime-test n)
  (newline)
  (display "CANDIDATE: ")
  (newline)
  (display n)
  (start-prime-test n (runtime)))

(define (start-prime-test n start-time)
  (if (search-for-primes n 0)
    (report-prime (- (runtime) start-time))))

(define (report-prime elapsed-time)
  (display " ELAPSED TIME: ")
  (newline)
  (display elapsed-time)
  (newline)
  (newline))

(define (prime? n)
  (= n (smallest-divisor n))
)

(define (smallest-divisor n) (find-divisor n 2))

(define (find-divisor n test-divisor)
  (cond ((> (square test-divisor) n) n)
        ((divides? test-divisor n) test-divisor)
        (else (find-divisor n (+ test-divisor 1)))
  )
)
(define (divides? a b) (= (remainder b a) 0))

(define (search-for-primes n num_primes)
  (if (= num_primes 3)
    n
    (search-for-primes (search-for-primes-check n) (+ num_primes 1))
  ))

(define (search-for-primes-check n)
  (define (search-for-primes-iter n)
    (if (prime? n)
        (show-and-tell n)
        (search-for-primes-iter (+ n 2)))
  )
  (if (even? n)
      (search-for-primes-iter (+ n 1))
      (search-for-primes-iter (+ n 2))))

(define (show-and-tell n)
  (display n)
  (newline)
  n
)

(start-prime-test 1000000000 (runtime))     ;.06999999999999999
(start-prime-test 10000000000 (runtime))    ;.24000000000000002
(start-prime-test 100000000000 (runtime))   ;.7
(start-prime-test 1000000000000 (runtime))  ; 2.06

;The O(log n) prediction is surprisingly accurate - had to make the numbers much larger to get a long enough time 