(define (make-from-mag-ang r ang)
  (define (dispatch op)
    (cond ((eq? op 'real-part) (* r (cos ang)))
          ((eq? op 'imag-part) (* r (sin ang)))
          ((eq? op 'magnitude) r)
          ((eq? op 'angle) ang)
          (else
           (error "Unknown op -- MAKE-FROM-REAL-IMAG" op))))
  dispatch)