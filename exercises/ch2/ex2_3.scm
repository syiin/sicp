;150
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
        (average (y-point p1) (y-point p2))))

(define (sub_square x_1 x_2) (square (- x_1 x_2)))
(define (distance p1 p2)
  (sqrt (+ (sub_square (x-point p1) (x-point p2))
           (sub_square (y-point p1) (y-point p2)))))

(define (midpoint-segment segment)
  (let ((start_p (start-segment segment))
        (end_p (end-segment segment)))
  (average-points start_p end_p)))

; Base Data
(define bottom-left (make-point 0 0) )
(define top-left (make-point 0 2) )
(define top-right (make-point 5 2) )
(define btm-right (make-point 5 0) )

; Representation #1
(define (make-rect seg_1 seg_2)
  (cons seg_1 seg_2))
(define (len-rect rect) 
  (let (( seg1 (car rect))
        ( seg2 (cdr rect)))
  (cons (distance (start-segment seg1) (end-segment seg1)) 
        (distance (start-segment seg2) (end-segment seg2)))
))

(define (area-rect rect)
  (let (( distances (len-rect rect)))
  (* (car distances) (cdr distances))))

(define (perimeter-rect rect)
  (let (( distances (len-rect rect)))
  (+ (* 2 (car distances)) (* 2 (cdr distances)))))

(define rectangle (make-rect (make-segment bottom-left top-left) (make-segment top-left top-right)))
(area-rect rectangle) ;10
(perimeter-rect rectangle) ;14

; Representation #2
(define (make-rect top_left_x top_left_y btm_right_x btm_right_y)
  (cons (cons top_left_x top_left_y) (cons btm_right_x btm_right_y)))
(define (len-rect rect)
  (let (( top_left (car rect))
        ( btm_right (cdr rect)))
  (cons (distance top_left (make-point (x-point btm_right) (y-point top_left)))
        (distance top_left (make-point (x-point top_left) (y-point btm_right))))))

(define rectangle (make-rect (x-point top-left) (y-point top-left) (x-point btm-right) (y-point btm-right)))
(area-rect rectangle)
(perimeter-rect rectangle)
