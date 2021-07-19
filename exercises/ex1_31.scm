;pi/4 = 0.78539816339

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

(define (pi_over_4 a b)
  (define (next n) (+ n 1))
  (define (term a) 
    (cond ((= a 1) (/ (+ a 1) (+ a 2)))
              ((even? a) (/ (+ a 2) (+ a 1)))
              (else (/ (+ a 1) (+ a 2))))
  )
  (product_iter term a next b)
)

(factorial 1 3)
(factorial 1 6)

(pi_over_4 1 100) 

(define (product_recur term a next b)
  (if (> a b)
  1
  (* (term a) (product_recur term (next a) next b))))

(define (pi_over_4 a b)
  (define (next n) (+ n 1))
  (define (term a) 
    (cond ((= a 1) (/ (+ a 1) (+ a 2)))
              ((even? a) (/ (+ a 2) (+ a 1)))
              (else (/ (+ a 1) (+ a 2))))
  )
  (product_recur term a next b)
)

(pi_over_4 1 100) 
