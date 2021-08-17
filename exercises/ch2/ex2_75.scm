(define (apply-generic op . args)
  (let ((type-tags (map type-tag args)))
  (let ((proc (get op type-tags)))
    (if proc
      (apply proc (map contents args))
      (error
        "No method for these types: APPLY-GENERIC"
        (list op type-tags))))))

(define (make-from-mag-ang r ang)
  (define (dispatch op)
    (cond ((eq? op 'real-part) (* r (cos ang)))
          ((eq? op 'imag-part) (* r (sin ang)))
          ((eq? op 'magnitude) r)
          ((eq? op 'angle) ang)
          (else
           (error "Unknown op -- MAKE-FROM-REAL-IMAG" op))))
  dispatch)