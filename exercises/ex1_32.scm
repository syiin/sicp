;;; for test cases
(define (product_iter term a next b)
  (define (iter a result)
    (if (> a b)
        result
        (iter (next a) (* result (term a)))))
  (iter a 1))

(define (factorial a b)
  (define (next n) (+ n 1))
  (define (identity n) n)
  (product_iter identity a next b))

(define (sum term a next b)
  (define (iter a result)
    (if (> a b)
        result
        (iter (next a) (+ result (term a)))))
  (iter a 0))


(define (sum-cubes a b)
  (define (cube x) (* x x x))
  (define (inc n) (+ n 1))
  (sum cube a inc b))

;;; my actual version
(define (accumulate combiner null-value term a next b)
  (define (iter a result)
    (if (> a b)
        result
        (iter (next a) (combiner result (term a)) )))
  (iter a null-value))

(define (factorial_acc a b)
  (define (fact_combiner x y) (* x y))
  (define (next n) (+ n 1))
  (define (identity n) n)
  (accumulate fact_combiner 1 identity a next b)
)

(define (sum_cubes_acc a b)
  (define (sum_combiner x y) (+ x y))
  (define (cube x) (* x x x))
  (define (inc n) (+ n 1))
  (accumulate sum_combiner 0 cube a inc b)
)

(factorial_acc 1 9)
(factorial 1 9)

(sum_cubes_acc 1 15)
(sum-cubes 1 15)