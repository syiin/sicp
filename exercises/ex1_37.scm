; phi = 1.61803398875
(define (cont-frac n d k)
  (if (= k 1)
    (/ (n k) (d k))
    (+ (/ (n k) (cont-frac n d (- k 1))) (d (- k 1)))
  )
)

(cont-frac (lambda (i) 1.0)
           (lambda (i) 1.0)
           15) ;Value: 1.6180327868852458

(define (cont-frac-iter n d k)
  (let ((initial_term (+ (d (- k 1)) (/ (n k) (d k)))))
  (define (iter c result)
    (let ((term (+ (d (- c 1)) (/ (n c) result))))
    (if (= c 0)
        result
        (iter (- c 1) term))))
  (iter (- k 1) initial_term)
))

(cont-frac-iter (lambda (i) 1.0)
                (lambda (i) 1.0)
                12) ;Value: 1.6180257510729614