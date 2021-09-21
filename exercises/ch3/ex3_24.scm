(define (make-table same-key?)
  (let ((table (list '*table*)))
    (define (assoc key records)
      (cond ((null? records) false)
            ((same-key? key (caar records)) (car records))
            (else (assoc key (cdr records)))))
    (define (lookup key)
      (let ((record (assoc key (cdr table))))
        (if record
            (cdr record)
            false)))
    (define (insert! key value)
      (let ((record (assoc key (cdr table))))
        (if record
            (set-cdr! record value)
            (set-cdr! table
                      (cons (cons key value) (cdr table)))))
      'ok)

    (define (dispatch m)
      (cond ((eq? m 'insert!) insert!)
            ((eq? m 'lookup) lookup)
            (else "NO SUCH METHOD")))
    dispatch
  ))

(define table (make-table eq?))
((table 'insert!) 'a 1)
((table 'insert!) 'b 2)
((table 'insert!) 'c 3)

((table 'lookup) 'a)
((table 'lookup) 'b)
((table 'lookup) 'c)

((table 'insert!) 'a 9)
((table 'lookup) 'a)
