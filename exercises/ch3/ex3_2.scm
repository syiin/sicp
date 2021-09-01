(define (make-monitored fn)
  (let ((counter 0))
  (lambda (x) 
    (if (eq? x 'how-many-calls?)
    counter
    (begin 
      (set! counter (+ 1 counter))
      (fn x)
    ))
  )))

(define s (make-monitored sqrt))
(s 100)
(s 100)
(s 'how-many-calls?)