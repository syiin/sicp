(define (cube x) (* x x x))

(define (h a b n) ( / (- b a) n))
(define (y f a h k) (f (+ a (* h k))))

(define (simpson f a b n)
  (define (h) ( / (- b a) n))
  (define (y k) (f (+ a (* (h) k))))
  (define (inner-simpson k) 
    (cond ((= k 0) (y k)) ;last term
          ((= k n) (+ (y k) (inner-simpson (- k 1)) )) ;first term
          ((odd? k) (+ (* 4 (y k)) (inner-simpson (- k 1) ) )) ;odd terms
          (else (+ (* 2 (y k)) (inner-simpson (- k 1)) )))) ;even terms
  (* (inner-simpson n) (/ (h) 3))
)

(simpson cube 0 1 100)
(simpson cube 0 1 1000)
