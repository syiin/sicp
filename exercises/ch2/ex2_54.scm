(define (equal? a b)
  (cond ((and (null? a) (null? b)) true)
        ((not (eq? (car a) (car b))) false)
        (else (equal? (cdr a) (cdr b)))
  )
)

(equal? '(this is a list) '(this is a list))   ;Value: #t
(equal? '(this is a list) '(this (is a) list)) ;Value: #f