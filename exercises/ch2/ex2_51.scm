(define (below painter1 painter2) 
  (let ((split-point (make-vect 0.0 0.5))) 
    (let ((paint-bottom 
          (transform-painter painter1 
                              (make-vect 0.0 0.0) 
                              (make-vect 1.0 0.0) 
                              split-point)) 
          (paint-top 
          (transform-painter painter2 
                              split-point 
                              (make-vect 1.0 0.5) 
                              (make-vect 0.0 1.0)))) 
      (lambda (frame) 
        (paint-bottom frame) 
        (paint-top frame))))) 


(define (below p1 p2) 
  (rotate180 (rotate270 (beside (rotate270 p1) (rotate270 p2))))) 