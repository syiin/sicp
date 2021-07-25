
(define (print-point p)
  (newline)
  (display "(")
  (display (x-point p))
  (display ",")
  (display (y-point p))
  (display ")"))

(define (make-point x y) (cons x y))
(define (x-point point) (car point))
(define (y-point point) (cdr point))

(define (make-segment p1 p2) (cons p1 p2))
(define (start-segment segment) (car segment))
(define (end-segment segment) (cdr segment))

(define (average x y) (/ (+ x y) 2))
(define (average-points p1 p2) 
  (cons (average (x-point p1) (x-point p2))
        (average (y-point p1) (y-point p2))
  )
)

(define (midpoint-segment segment)
  (let (
        (start_p (start-segment segment))
        (end_p (end-segment segment))
       )
  (average-points start_p end_p)
  )
)

(midpoint-segment (make-segment (make-point 0 0) (make-point 3 3)))
