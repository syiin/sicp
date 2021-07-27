(define (show n) ((display n) n) )
(define (same-parity . a-list)
  (define (inner filter? a-list)
  (cond ((null? a-list) a-list)
        ((filter? (car a-list)) (cons (car a-list) (inner filter? (cdr a-list))) )
        (else (inner filter? (cdr a-list)))))
  (if (even? (car a-list))
      (inner even? a-list)
      (inner odd? a-list))
)


(same-parity 1 2 3 4 5 6 7)
(same-parity 2 3 4 5 6 7)
