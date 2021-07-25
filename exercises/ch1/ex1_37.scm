; 1/phi = 0.61803444782
(define (cont-frac n d k)
  (if (= k 1)
    (/ (n k) (d k))
    (+ (/ (n k) (cont-frac n d (- k 1))) (d (- k 1)) )
  )
)

(define (cont-frac n d k)
  (if (= k 1)
    (/ (n k) (d k))
    (/ (n k) (+ (cont-frac n d (- k 1)) (d k)))))

(cont-frac (lambda (i) 1.0)
           (lambda (i) 1.0)
           15) 

(define (cont-frac-iter n d k)
  (let ((initial_term (+ (d (- k 1)) (/ (n k) (d k)))))
  (define (iter c result)
    (let ((term (+ (d (- c 1)) (/ (n c) result))))
    (if (= c 0)
        result
        (iter (- c 1) term))))
  (iter (- k 1) initial_term)
))


(define (cont-frac n d k)
  (define (iter i result)
    (if (= i 0)
        result
        (iter (- i 1) (/ (n i) (+ (d i) result)))))
  (iter k (/ (n k) (d k))))

(cont-frac (lambda (i) 1.0)
           (lambda (i) 1.0)
            15)