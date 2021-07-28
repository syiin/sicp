(define (for-each fx a-list)
  (define (just-to-call a-list throw-away)
    (if (null? a-list)
        true
        (just-to-call (cdr a-list) (fx (car a-list)))
    )
  )
  (just-to-call a-list '())
)

(for-each (lambda (x)
              (newline)
              (display x))
              (list 57 321 88))