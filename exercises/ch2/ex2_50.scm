(define (frame-coord-map frame)
  (lambda (v)
    (add-vect
      (origin-frame frame)
      (add-vect (scale-vect (xcor-vect v) (edge1-frame frame))
                (scale-vect (ycor-vect v) (edge2-frame frame))))))

; produces a painter that takes a frame and transforms it according to an initial
; painter given at intialisation plus coordinates that specify a new frame
; frame -> new-frame -> new-painter wrapped in painter
(define (transform-painter painter origin corner1 corner2)
  (lambda (frame)
    (let ((m (frame-coord-map frame)))
      (let ((new-origin (m origin)))
        (painter (make-frame
                  new-origin
                  (sub-vect (m corner1) new-origin)
                  (sub-vect (m corner2) new-origin)))))))

(define (flip-horiz painter) 
  (transform-painter painter 
                    (make-vect 1.0 0.0) 
                    (make-vect 0.0 0.0) 
                    (make-vect 1.0 1.0))) 

(define (rotate180 painter) 
  (transform-painter painter 
                    (make-vect 1.0 1.0) 
                    (make-vect 0.0 1.0) 
                    (make-vect 1.0 0.0))) 

(define (rotate270 painter) 
  (transform-painter painter 
                    (make-vect 0.0 1.0) 
                    (make-vect 0.0 0.0) 
                    (make-vect 1.0 1.0))) 