(define (make-vect x y) (cons x y))
(define (xcor-vect v) (car v))
(define (ycor-vect v) (cdr v))

(define (add-vect v1 v2) 
  (make-vect 
    (+ (xcor-vect v1) (xcor-vect v2)) 
    (+ (ycor-vect v1) (ycor-vect v2))))

(define (sub-vect v1 v2) 
  (make-vect 
    (- (xcor-vect v1) (xcor-vect v2)) 
    (- (ycor-vect v1) (ycor-vect v2))))

(define (scale-vect sf v) 
  (make-vect 
    (* sf (xcor-vect v))
    (* sf (ycor-vect v))))

(define (make-segment start end) (cons start end))
(define (start-segment seg) (car seg))
(define (end-segment seg) (cdr seg))

(define segment (make-segment (make-vect 0 0) (make-vect 3 3)))
(start-segment segment) ;Value: (0 . 0)
(end-segment segment)   ;Value: (3 . 3)