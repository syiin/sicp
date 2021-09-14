(define counted-list '())
(define (contains lsf i)
  (cond ((null? lsf) false)
        ((eq? (car lsf) i) true)
        (else (contains (cdr lsf) i))))
(define (has-counted? i)
  (contains counted-list i))
(define (count-item i) 
  (set! counted-list (cons i counted-list)))
(define (make-cycle x)
  (set-cdr! (last-pair x) x)
  x)

(define (is-cycle? node)
  (cond ((not (pair? node)) false)
        ((has-counted? node) true)
        (else 
          (begin
            (count-item node)
            (or (is-cycle? (car node)) 
                (is-cycle? (cdr node)))))))

(define z (make-cycle (list 'a 'b 'c)))

(is-cycle? z)
(is-cycle? (list 'a 'b 'c))