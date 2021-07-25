(define (cont-frac n d k)
  (define (iter i result)
    (if (= i 0)
        result
        (iter (- i 1) (/ (n i) (+ (d i) result)))))
  (iter k (/ (n k) (d k))))

(define (d-term i)
  (if (= (modulo i 3) 2)
      (* 2(/ (+ i 1) 3))
      1))

(cont-frac (lambda (i) 1.0)
                d-term
                100) 

;e - 2 = 0.7182818284




