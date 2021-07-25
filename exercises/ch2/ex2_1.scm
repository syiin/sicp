;146
(define (gcd a b)
  (if (= b 0)
  a
  (gcd b (remainder a b))))

(define (reverse-sign n) (- n))
(define (is-negative? n) (< n 0))
(define (is-positive? n) (> n 0))

(define (make-rat n d)
  (let ((g (abs (gcd n d))))
       (cond ((is-positive? d) 
                (cons (/ n g) (/ d g)) )
             ((and (is-negative? d) (is-positive? n))
                (cons (/ (reverse-sign n) g) (/ (reverse-sign d) g)))
             ((and (is-negative? d) (is-negative? n)) 
                (cons (/ (reverse-sign n) g) (/ (reverse-sign d) g)))
       )
  )
)

(define (numer x) (car x))
(define (denom x) (cdr x))

(define (print-rat x)
  (newline)
  (display (numer x))
  (display "/")
  (display (denom x)))

(print-rat (make-rat 1 3))         ;1/3
(print-rat (make-rat (- 1) 3))     ;-1/3
(print-rat (make-rat 1 (- 3)))     ;-1/3
(print-rat (make-rat (- 1) (- 3))) ;1/3


(define (add-rat x y)
  (make-rat (+ (* (numer x) (denom y))
               (* (numer y) (denom x)))
               (* (denom x) (denom y))))

(define one-third (make-rat 1 3))
(print-rat (add-rat one-third one-third)) ;2/3
