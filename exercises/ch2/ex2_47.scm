;origin-frame, edge1-frame, and edge2-frame
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

(define (make-frame origin edge1 edge2)
  (list origin edge1 edge2))

(define (origin-frame fr) (car fr))
(define (edge1-frame fr) (cadr fr))
(define (edge2-frame fr) (caddr fr))

(define (frame-coord-map frame)
  (lambda (v)
    (add-vect
      (origin-frame frame)
      (add-vect (scale-vect (xcor-vect v) (edge1-frame frame))
                (scale-vect (ycor-vect v) (edge2-frame frame))))))

(define origin (make-vect 0 0))
(define v1 (make-vect 1 0))
(define v2 (make-vect 0 1))
(define frame1 (make-frame origin v1 v2))
 
(origin-frame frame1)                      ;Value: (0 . 0)
(edge1-frame frame1)                       ;Value: (1 . 0)
(edge2-frame frame1)                       ;Value: (0 . 1)
((frame-coord-map frame1) (make-vect 2 2)) ;Value: (2 . 2)

(define (make-frame origin edge1 edge2)
  (cons origin (cons edge1 edge2)))

(define (origin-frame fr) (car fr))
(define (edge1-frame fr) (car (cdr fr)))
(define (edge2-frame fr) (cdr (cdr fr)))

(define (frame-coord-map frame)
  (lambda (v)
    (add-vect
      (origin-frame frame)
      (add-vect (scale-vect (xcor-vect v) (edge1-frame frame))
                (scale-vect (ycor-vect v) (edge2-frame frame))))))

(define origin (make-vect 0 0))
(define v1 (make-vect 1 0))
(define v2 (make-vect 0 1))
(define frame1 (make-frame origin v1 v2))
 
(origin-frame frame1)                      ;Value: (0 . 0)
(edge1-frame frame1)                       ;Value: (1 . 0)
(edge2-frame frame1)                       ;Value: (0 . 1)
((frame-coord-map frame1) (make-vect 2 2)) ;Value: (2 . 2)