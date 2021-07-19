;;; linearly iterative version
(define (accumulate combiner null-value term a next b)
  (define (iter a result)
    (if (> a b)
        result
        (iter (next a) (combiner result (term a)) )))
  (iter a null-value))

(define (product_iter term a next b)
  (define (prod_combiner x y) (* x y))
  (accumulate prod_combiner 1 term a next b))

(define (sum_iter term a next b)
  (define (sum_combiner x y) (+ x y))
  (accumulate sum_combiner 0 term a next b))

(define (factorial a b)
  (define (next n) (+ n 1))
  (define (identity n) n)
  (product_iter identity a next b))

(define (sum-cubes a b)
  (define (cube x) (* x x x))
  (define (inc n) (+ n 1))
  (sum_iter cube a inc b))

(factorial 1 9)
(sum-cubes 1 15)

;;; linearly recursive version
(define (accumulate_recur combiner null-value term a next b)
    (if (> a b)
    null-value
    (combiner (term a) (accumulate_recur combiner null-value term (next a) next b))))

(define (product_recur term a next b)
  (define (prod_combiner x y) (* x y))
  (accumulate_recur prod_combiner 1 term a next b))

(define (sum_recur term a next b)
  (define (sum_combiner x y) (+ x y))
  (accumulate_recur sum_combiner 0 term a next b))

(define (factorial-recur a b)
  (define (next n) (+ n 1))
  (define (identity n) n)
  (product_recur identity a next b))

(define (sum-cubes-recur a b)
  (define (cube x) (* x x x))
  (define (inc n) (+ n 1))
  (sum_recur cube a inc b))

(factorial-recur 1 9)
(sum-cubes-recur 1 15)