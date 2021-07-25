;;; prime functions
(define (prime? n)
  (= n (smallest-divisor n)))
(define (smallest-divisor n) (find-divisor n 2))
(define (find-divisor n test-divisor)
  (cond ((> (square test-divisor) n) n)
        ((divides? test-divisor n) test-divisor)
        (else (find-divisor n (+ test-divisor 1)))))
(define (divides? a b) (= (remainder b a) 0))

;;; filter-accumulate
(define (filtered-accumulate combiner null-value filter term a next b)
  (define (iter a result)
    (cond ((> a b) result)
          ((filter a) (iter (next a) (combiner result (term a))) )
          (else (iter (next a) (combiner result null-value)))
    )
  )
  (iter a null-value))

(define (sum-prime-square a b)
  (define (combiner x y) (+ x y))
  (define (next x) (+ x 1))
  (define (square x) (* x x))
  (filtered-accumulate combiner 0 prime? square a next b)
)

(sum-prime-square 1 3)


(define (gcd a b)
  (if (= b 0)
  a
  (gcd b (remainder a b))))

(define (product-prime n)
  (define (combiner x y) (* x y))
  (define (next x) (+ x 1))
  (define (identity x) x)
  (define (filter? i) ( = (gcd i n) 1))
  (filtered-accumulate combiner 1 filter? identity 1 next n)
)

(product-prime 10)