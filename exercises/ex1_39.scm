(define (cont-frac n d k)
  (define (iter i result)
    (if (= i 0)
        result
        (iter (- i 1) (/ (n i) (+ (d i) result)))))
  (iter k (/ (n k) (d k))))


(define x 3.14159)
(define (odds i) (+ (* 2 (- i 1)) 1))

(define (n-sq i) 
  (if (= i 1) 
      (- x)
      (- (* x x))))

(cont-frac n-sq odds 100) ;Value: 2.6535897933138355e-6