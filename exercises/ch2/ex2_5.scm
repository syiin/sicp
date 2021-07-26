; pg 154
(define (fast_expt b n)
  (cond ((= n 0) 1)
  ((even? n) (square (fast_expt b (/ n 2))))
  (else (* b (fast_expt b (- n 1))))))

 (define (count-0-remainder-divisions n p d) 
  (if (= (remainder p d) 0) 
    (count-0-remainder-divisions (+ n 1) (/ p d) d)  n))

(define (cons a b) (* (fast_expt 2 a) (fast_expt 3 b)))
(define (car pair) (count-0-remainder-divisions 0 pair 2))
(define (cdr pair) (count-0-remainder-divisions 0 pair 3))

(car (cons 1 2))
(cdr (cons 1 2))

