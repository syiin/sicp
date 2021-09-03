(define (random-in-range low high)
  (let ((range (- high low)))
    (+ low (random range))))

(define (monte-carlo trials experiment)
  (define (iter trials-remaining trials-passed)
    (cond ((= trials-remaining 0)
           (/ trials-passed trials))
          ((experiment)
           (iter (- trials-remaining 1) (+ trials-passed 1)))
          (else
           (iter (- trials-remaining 1) trials-passed))))
  (iter trials 0))

(define (make-experiment x1 x2 y1 y2 pred) 
  (let ((curr-x (random-in-range x1 x2))
        (curr-y (random-in-range y1 y2)))
  (lambda () 
    (begin 
      (set! curr-x (random-in-range x1 x2))
      (set! curr-y (random-in-range y1 y2))
      (pred curr-x curr-y)
    )
  )
))

(define (in-unit-circle? x y)
  (<= (+ (expt (- x c-center-x) 2) 
         (expt (- y c-center-y) 2)) 
    (expt c-radius 2)))

(define (estimate-integral pred x1 x2 y1 y2 n-trials)
  (monte-carlo n-trials (make-experiment x1 x2 y1 y2 pred)))


(define c-center-x 5)
(define c-center-y 7)
(define c-radius 3)

(define lo-x 2.0)
(define hi-x 8.0)
(define lo-y 4.0)
(define hi-y 10.0)
(define area (* (- hi-x lo-x) (- hi-y lo-y)) )

(define pi 
   (/ (* (estimate-integral in-unit-circle? 2.0 8.0 4.0 10.0 100000) area) 
      (square c-radius))) 
pi ;Value: 3.14168 